import Foundation
import GRPC
import NIO

enum GRPCConfig {
    static var serverURL: String {
        if let urlString = Bundle.main.infoDictionary?["GRPC_SERVER_URL"] as? String {
            return urlString
        }
        return "localhost:50051"
    }
    
    static var useTLS: Bool {
        if let useTLS = Bundle.main.infoDictionary?["GRPC_USE_TLS"] as? Bool {
            return useTLS
        }
        return false
    }
    
    static func createChannel() throws -> GRPCChannel {
        let urlString = serverURL
        let components = urlString.components(separatedBy: ":")
        let host = components.first ?? "localhost"
        let port = Int(components.last ?? "50051") ?? 50051
        
        print("🔌 Подключение к gRPC серверу: \(host):\(port)")
        
        let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        
        let configuration = ClientConnection.Configuration(
            target: .hostAndPort(host, port),
            eventLoopGroup: group,
            tls: useTLS ? .init() : nil
        )
        
        return ClientConnection(configuration: configuration)
    }
}

// Примечание: Если используется grpc-swift 2.x и нет модуля GRPC,
// замените import GRPC на import GRPCCore и используйте GRPCCore.ClientConnection
