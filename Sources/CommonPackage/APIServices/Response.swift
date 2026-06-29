//
//  File.swift
//
//
//  Created by Tan Vo on 04/05/2023.
//

import Foundation

public struct Pagination: Decodable {
    public let currentPage: Int?
    public let perPage: Int?
    public let total: Int?
    public let totalPage: Int?

    public init(currentPage: Int?, perPage: Int?, total: Int?, totalPage: Int?) {
        self.currentPage = currentPage
        self.perPage = perPage
        self.total = total
        self.totalPage = totalPage
    }

    public var canLoadMore: Bool {
        return (currentPage ?? 0) < (totalPage ?? 0)
    }

    public var nextPage: Int? {
        guard let current = currentPage else {
            return nil
        }
        return current + 1
    }
}

public struct Response<T: Decodable>: Decodable {
    public let message: String?
    public let code: Int
    public let data: T?
}

public struct ResponseList<K: Decodable>: Decodable {
    public let list: [K]?
    public let pagination: Pagination?

    public init(list: [K]?, pagination: Pagination?) {
        self.list = list
        self.pagination = pagination
    }
}

extension Response {
    public var error: APIError? {
        return code == 200 ? nil : APIError(code: code, messageResponse: message)
    }
}
