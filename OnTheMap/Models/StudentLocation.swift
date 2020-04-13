//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Filipe Degrazia on 08/03/20.
//  Copyright © 2020 FilipeDegrazia. All rights reserved.
//

import Foundation

struct StudentLocationResponse: Codable {
  let results: [StudentLocation]
}

struct StudentLocation: Codable {
  let objectId: String?
  let uniqueKey: String
  let firstName: String
  let lastName: String
  let mapString: String
  let mediaURL: String
  let latitude: Double
  let longitude: Double
}
