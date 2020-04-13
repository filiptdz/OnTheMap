//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Filipe Degrazia on 08/03/20.
//  Copyright © 2020 FilipeDegrazia. All rights reserved.
//

import Foundation

struct LoginRequest: Codable {
  struct Udacity: Codable {
    let username: String
    let password: String
  }
  let udacity: Udacity
  
  init(username: String, password: String) {
    self.udacity = Udacity(username: username, password: password)
  }
}
