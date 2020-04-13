//
//  LoginResponse.swift
//  OnTheMap
//
//  Created by Filipe Degrazia on 08/03/20.
//  Copyright © 2020 FilipeDegrazia. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
  struct Session: Codable {
    let id: String
    let expiration: String
  }
  let session: Session
  struct Account: Codable {
    let registered: Bool
    let key: String
  }
  let account: Account
}
