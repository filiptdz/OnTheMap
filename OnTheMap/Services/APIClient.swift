//
//  APIClient.swift
//  OnTheMap
//
//  Created by Filipe Degrazia on 08/03/20.
//  Copyright © 2020 FilipeDegrazia. All rights reserved.
//

import Foundation

class APIClient {
  static var Auth: LoginResponse?
  
  enum Endpoints {
    static let baseURL = "https://onthemap-api.udacity.com/v1"
    
    case getStudentLocation
    case postStudentLocation
    case session
    case getPublicUserData
    
    var stringValue: String {
      switch self {
      case .getStudentLocation: return Endpoints.baseURL + "/StudentLocation" + "?limit=100&order=-updatedAt"
      case .postStudentLocation: return Endpoints.baseURL + "/StudentLocation"
      case .session: return Endpoints.baseURL + "/session"
      case .getPublicUserData: return Endpoints.baseURL + "/users/\(Auth!.session.id)"
      }
    }
    
    var url: URL {
      return URL(string: stringValue)!
    }
  }
  
  class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
    var request = URLRequest(url: Endpoints.session.url)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.httpMethod = "POST"
    request.httpBody = try! JSONEncoder().encode(LoginRequest(username: username, password: password))
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
      guard let data = data else {
        DispatchQueue.main.async {
          completion(false, error)
        }
        return
      }
      do {
        let objectData = try JSONDecoder().decode(LoginResponse.self, from: data.subdata(in: 5..<data.count))
        Auth = objectData
        DispatchQueue.main.async {
          completion(true, nil)
        }
      } catch {
        let errorData = try? JSONDecoder().decode(LoginErrorData.self, from: data.subdata(in: 5..<data.count))
        if let errorData = errorData {
          DispatchQueue.main.async {
            var error: LoginError
            switch errorData.status {
            case 403: error = LoginError.invalidCredentials
            default: error = LoginError.invalidCredentials
            }
            
            completion(false, error)
          }
        } else {
          DispatchQueue.main.async {
            completion(false, error)
          }
        }
      }
    }
    task.resume()
  }
  
  class func logout(completion: @escaping (Bool, Error?) -> Void) {
    var request = URLRequest(url: Endpoints.session.url)
    request.httpMethod = "DELETE"
    var xsrfCookie: HTTPCookie? = nil
    let sharedCookieStorage = HTTPCookieStorage.shared
    for cookie in sharedCookieStorage.cookies! {
      if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
    }
    if let xsrfCookie = xsrfCookie {
      request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
    }
    let session = URLSession.shared
    let task = session.dataTask(with: request) { data, response, error in
      if error != nil {
        DispatchQueue.main.async {
          completion(false, error)
        }
        return
      }
      Auth = nil
      DispatchQueue.main.async {
        completion(true, nil)
      }
    }
    task.resume()
  }
  
  class func getStudentData(completion: @escaping ([StudentLocation], Error?) -> Void) {
    let task = URLSession.shared.dataTask(with: Endpoints.getStudentLocation.url) { data, response, error in
      guard error == nil else {
        DispatchQueue.main.async {
          completion([], error)
        }
        return
      }
      do {
        let objectData = try JSONDecoder().decode(StudentLocationResponse.self, from: data!)
        DispatchQueue.main.async {
          completion(objectData.results, nil)
        }
      } catch {
        DispatchQueue.main.async {
          completion([], error)
        }
      }
    }
    task.resume()
  }
  
  class func saveLocation(studentLocation: StudentLocation, completion: @escaping (Bool, Error?) -> Void) {
    var request = URLRequest(url: Endpoints.postStudentLocation.url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try! JSONEncoder().encode(studentLocation)
    let session = URLSession.shared
    let task = session.dataTask(with: request) { data, response, error in
      guard error == nil else {
        DispatchQueue.main.async {
          completion(false, error)
        }
        return
      }
      DispatchQueue.main.async {
        completion(true, nil)
      }
    }
    task.resume()
  }
  
  class func getUserData(completion: @escaping (UserData?, Error?) -> Void) {
    let request = URLRequest(url: Endpoints.getPublicUserData.url)
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      guard error == nil else {
        DispatchQueue.main.async {
          completion(nil, error)
        }
        return
      }
      do {
        let newData = data?.subdata(in: 5..<data!.count)
        print(String(data: newData!, encoding: .utf8)!)
        let objectData = try JSONDecoder().decode(UserData.self, from: newData!)
        DispatchQueue.main.async {
          completion(objectData, nil)
        }
      } catch {
        DispatchQueue.main.async {
          completion(nil, error)
        }
      }
    }
    task.resume()
  }
}
