//
//  LoginError.swift
//  OnTheMap
//
//  Created by Filipe Degrazia on 17/03/20.
//  Copyright © 2020 FilipeDegrazia. All rights reserved.
//

import Foundation

struct LoginErrorData: Codable {
  let status: Int
  let error: String
}

enum LoginError: Error {
  case invalidCredentials
  case connectionFailure
}

extension LoginError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .invalidCredentials: return "Account not found or invalid credentials."
    case .connectionFailure: return "Could not connect at the moment. Try again later."
    }
  }
}
