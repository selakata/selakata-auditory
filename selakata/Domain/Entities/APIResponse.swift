import Foundation

struct APIResponse<T: Codable>: Codable {
    let data: T
    let meta: Metadata?
}

struct Metadata: Codable {
    let currentPage: Int
    let from: Int
    let to: Int
    let lastPage: Int
    let perPage: Int
    let total: Int
}
