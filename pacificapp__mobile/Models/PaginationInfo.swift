import Foundation

struct PaginationInfo: Codable {
    let count: Int32
    let page: Int32
    let pageSize: Int32
    let totalPages: Int32
    let hasNext: Bool
    let hasPrevious: Bool
    
    enum CodingKeys: String, CodingKey {
        case count
        case page
        case pageSize
        case totalPages
        case hasNext
        case hasPrevious
    }
}
