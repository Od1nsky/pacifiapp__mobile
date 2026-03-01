import SwiftUI
import AlertToast

struct SignupView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var email = ""
    @State private var password = ""
    @State private var fullName = ""
    @State private var confirmPassword = ""
    @State private var localError: String?
    @FocusState private var focusedField: Field?
    
    private enum Field {
        case name
        case email
        case password
        case confirmPassword
    }
    
    private var isSignupDisabled: Bool {
        email.isEmpty || password.isEmpty || fullName.isEmpty || password != confirmPassword || authViewModel.isLoading
    }
    
    private var errorToastBinding: Binding<Bool> {
        Binding(
            get: { (authViewModel.errorMessage ?? localError) != nil },
            set: { if !$0 { authViewModel.errorMessage = nil; localError = nil } }
        )
    }
    
    private var errorText: String? {
        authViewModel.errorMessage ?? localError
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    TextField("Полное имя", text: $fullName)
                        .textContentType(.name)
                        .autocapitalization(.words)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        .focused($focusedField, equals: .name)
                    
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
                        .textContentType(.newPassword)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        .focused($focusedField, equals: .password)
                    
                    SecureField("Подтверждение пароля", text: $confirmPassword)
                        .textContentType(.newPassword)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        .focused($focusedField, equals: .confirmPassword)
                    
                    if password != confirmPassword && !confirmPassword.isEmpty {
                        Text("Пароли не совпадают")
                            .font(.caption)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Button {
                        guard password == confirmPassword else {
                            localError = "Пароли должны совпадать"
                            return
                        }
                        authViewModel.signup(email: email, password: password, fullName: fullName)
                    } label: {
                        HStack {
                            if authViewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(.circular)
                            }
                            Text("Создать аккаунт")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isSignupDisabled ? Color.gray.opacity(0.3) : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .disabled(isSignupDisabled)
                }
                .padding()
            }
            .navigationTitle("Регистрация")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Закрыть") {
                        dismiss()
                    }
                }
            }
            .onChange(of: authViewModel.isAuthenticated) { isAuthenticated in
                if isAuthenticated {
                    dismiss()
                }
            }
            .toast(isPresenting: errorToastBinding) {
                AlertToast(type: .error(.red), title: errorText)
            }
        }
    }
}
