//
//  Response+ErrorCode.swift
//  Viivio
//
//  Created by Kent Nguyen on 12/4/19.
//  Copyright © 2019 Poeta Digital. All rights reserved.
//

import UIKit
import Moya

enum ServiceError: Error {
    case jsonFormatError
    case serverResponseError(message:String)
    case badRequest(message:String)
    case tokenExpired
    case unAuthorized
}

extension ServiceError:LocalizedError{
    var errorDescription: String? {
        get{
            switch self {
            case .jsonFormatError:
                return "Wrong json format. Please check your data again."
            case .serverResponseError(let message):
                return message
            case .badRequest(let message):
                return message
            case .tokenExpired:
                return ""
            case .unAuthorized:
                return ""
            }
        }
    }
}

extension Response{
    
    private func filterUZAuthenCode(statusCodes: [Int]) throws -> Any? {
        do {
            let json = try self.mapJSON(failsOnEmptyData: true) as! [String:Any]
            guard self.statusCode == 200 else{
                throw ServiceError.serverResponseError(message: (json["message"] as? String) ?? "")
            }
            return json
        }
        catch (_){
            throw ServiceError.jsonFormatError
        }
    }
    
    public func filterSeverErrorCode() throws -> Any? {
        return try filterUZAuthenCode(statusCodes: [401,400])
    }
}
