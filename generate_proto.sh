#!/bin/bash

# Скрипт для генерации Swift кода из proto файлов
# Использует grpc-swift версии 1.20.0 (совместима с модулем GRPC)

PROTO_DIR="pacificapp__mobile/Proto"
OUTPUT_DIR="pacificapp__mobile/Networking/GRPC/Generated"
PROTOC_GEN_SWIFT="/tmp/grpc-swift/protoc-gen-swift"
PROTOC_GEN_GRPC_SWIFT="/tmp/grpc-swift/protoc-gen-grpc-swift"

# Проверка наличия protoc
if ! command -v protoc &> /dev/null; then
    echo "❌ protoc не установлен. Установите через: brew install protobuf"
    exit 1
fi

# Проверка наличия плагинов
if [ ! -f "$PROTOC_GEN_SWIFT" ]; then
    echo "❌ protoc-gen-swift не найден. Запустите: cd /tmp/grpc-swift && make plugins"
    exit 1
fi

if [ ! -f "$PROTOC_GEN_GRPC_SWIFT" ]; then
    echo "❌ protoc-gen-grpc-swift не найден. Запустите: cd /tmp/grpc-swift && make plugins"
    exit 1
fi

# Создание выходной директории
mkdir -p "$OUTPUT_DIR"

echo "🔧 Генерация Swift кода из proto файлов..."
echo "📁 Proto файлы: $PROTO_DIR"
echo "📁 Выходная директория: $OUTPUT_DIR"
echo ""

# Генерация для каждого proto файла
for proto_file in "$PROTO_DIR"/*.proto; do
    if [ -f "$proto_file" ]; then
        filename=$(basename "$proto_file" .proto)
        echo "📄 Обработка: $filename.proto"
        
        protoc \
            --proto_path="$PROTO_DIR" \
            --swift_out="$OUTPUT_DIR" \
            --grpc-swift_out="$OUTPUT_DIR" \
            --plugin=protoc-gen-swift="$PROTOC_GEN_SWIFT" \
            --plugin=protoc-gen-grpc-swift="$PROTOC_GEN_GRPC_SWIFT" \
            "$proto_file" 2>&1 | grep -v "warning" || true
    fi
done

echo ""
echo "✅ Генерация завершена!"
echo "📦 Сгенерированные файлы находятся в: $OUTPUT_DIR"
echo ""
echo "⚠️  ВАЖНО: Используйте grpc-swift версии 1.20.0 в Xcode!"
echo "   Версия 2.x не имеет модуля GRPC, только GRPCCore"
echo ""
echo "Следующие шаги:"
echo "1. В Xcode: Package Dependencies → удалите grpc-swift 2.x"
echo "2. Добавьте: https://github.com/grpc/grpc-swift.git версии 1.20.0"
echo "3. Выберите продукт: ✅ GRPC"
echo "4. Добавьте сгенерированные файлы в Xcode проект"
echo "5. Clean Build Folder (Shift+Cmd+K) → Build (Cmd+B)"
