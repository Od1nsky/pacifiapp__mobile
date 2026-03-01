# gRPC Integration для iOS приложения

## Структура файлов

- `GRPCConfig.swift` - Конфигурация gRPC подключения
- `GRPCClientManager.swift` - Менеджер для управления gRPC клиентами и токенами
- `GRPCServiceFactory.swift` - Фабрика для создания всех сервисов
- `GRPCServices.swift` - Основные сервисы (User, Sleep, Work)
- `GRPCServicesExtended.swift` - Расширенные сервисы (Stress, Burnout, Recommendation, Calendar, Dashboard)
- `ProtoExtensions.swift` - Расширения для конвертации между proto типами и моделями приложения

## Использование

### Пример использования в ViewModel:

```swift
@MainActor
final class SleepViewModel: ObservableObject {
    @Published var sleepRecords: [SleepRecord] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let sleepService = GRPCServiceFactory.shared.sleepService
    
    func fetchSleepRecords() {
        guard let service = sleepService else {
            errorMessage = "gRPC сервис недоступен"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let result = try await service.listSleepRecords()
                await MainActor.run {
                    self.sleepRecords = result.records
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    func createSleepRecord(record: SleepRecordCreate) {
        guard let service = sleepService else {
            errorMessage = "gRPC сервис недоступен"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let created = try await service.createSleepRecord(
                    date: record.date,
                    durationHours: record.durationHours,
                    quality: record.quality.map { Int32($0) },
                    notes: record.notes
                )
                await MainActor.run {
                    self.sleepRecords.insert(created, at: 0)
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}
```

## Важные замечания

1. **После генерации proto файлов** нужно будет:
   - Обновить импорты в файлах сервисов
   - Заменить плейсхолдеры типов (UserProto, SleepRecordProto и т.д.) на реальные имена
   - Убедиться, что все поля соответствуют proto определениям

2. **Аутентификация**: Токены автоматически добавляются в метаданные через `GRPCClientManager`

3. **Обработка ошибок**: Все методы могут выбрасывать ошибки, их нужно обрабатывать в try-catch блоках

4. **Async/Await**: Все методы используют async/await для асинхронных операций

## Следующие шаги

1. Добавить gRPC-Swift библиотеку через Swift Package Manager
2. Сгенерировать Swift код из proto файлов
3. Обновить все типы в сервисах
4. Обновить ViewModels для использования gRPC сервисов
5. Протестировать все методы
