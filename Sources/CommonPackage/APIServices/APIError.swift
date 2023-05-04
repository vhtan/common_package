//
//  File.swift
//  
//
//  Created by Tan Vo on 04/05/2023.
//

import Foundation

public struct APIError: Error {
    public var code: Int?
    public var messageResponse: String?
    public var message: String?
    
    init(code: Int? = nil, messageResponse: String? = nil, message: String? = nil) {
        self.code = code
        self.messageResponse = messageResponse
        self.message = message
    }
    
    public static func defaultError() -> APIError {
        return APIError(code: nil, messageResponse: nil)
    }
}
