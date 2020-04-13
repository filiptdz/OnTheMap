//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Filipe Degrazia on 18/03/20.
//  Copyright © 2020 FilipeDegrazia. All rights reserved.
//

import Foundation

class StudentInformation {
  static let shared = StudentInformation()
  
  var studentLocations: [StudentLocation]?
}
