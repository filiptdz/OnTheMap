//
//  UserData.swift
//  OnTheMap
//
//  Created by Filipe Degrazia on 19/03/20.
//  Copyright © 2020 FilipeDegrazia. All rights reserved.
//

import Foundation

struct UserData: Codable {
  let lastName: String
  let firstName: String
  
  enum CodingKeys: String, CodingKey {
    case lastName = "last_name"
    case firstName = "first_name"
  }
}
