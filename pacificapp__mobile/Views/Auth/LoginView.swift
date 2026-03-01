import SwiftUI
import AlertToast

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showingSignup = false
    @FocusState private var focusedField: Field?
    
    private enum Field {
        case email
        case password
    }
    
    private var isButtonDisabled: Bool {
        email.isEmpty || password.isEmpty || authViewModel.isLoading
    }
    
    private var errorToastBinding: Binding<Bool> {
        Binding(
            get: { authViewModel.errorMessage != nil },
            set: { if !$0 { authViewModel.errorMessage = nil } }
        )
    }
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text("С возвращением 👋")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Введите учётные данные, чтобы продолжить отслеживать баланс работы и отдыха.")
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 16) {
                TextField("Email", text: $email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .focused($focusedField, equals: .email)
                
                SecureField("Пароль", text: $password)
                    .textContentType(.password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .focused($focusedField, equals: .password)
                
                Button {
                    authViewModel.login(email: email, password: password)
                } label: {
                    HStack {
                        if authViewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(.circular)
                        }
                        Text("Войти")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isButtonDisabled ? Color.gray.opacity(0.3) : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(isButtonDisabled)
            }
            
            Button {
                showingSignup = true
            } label: {
                Text("Нет аккаунта? Зарегистрируйтесь")
                    .foregroundColor(.blue)
            }
            .padding(.top, 8)
            
            Spacer()
        }
        .padding()
        .toast(isPresenting: errorToastBinding) {
            AlertToast(type: .error(.red), title: authViewModel.errorMessage)
        }
        .sheet(isPresented: $showingSignup) {
            SignupView()
                .environmentObject(authViewModel)
        }
    }
} 
