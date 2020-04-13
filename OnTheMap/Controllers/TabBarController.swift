//
//  TabBarController.swift
//  OnTheMap
//
//  Created by Filipe Degrazia on 17/03/20.
//  Copyright © 2020 FilipeDegrazia. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
  @IBOutlet weak var logoutButton: UIBarButtonItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.setNavigationBarHidden(false, animated: true)
    let logoutButtonTextAttributes: [NSAttributedString.Key : Any] = [
      NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.7535467744, blue: 0.9159824252, alpha: 1),
      NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16.0)
    ]
    
    logoutButton.setTitleTextAttributes(logoutButtonTextAttributes, for: .normal)
    
    loadStudentData()
  }
  
  func loadStudentData() {
    APIClient.getStudentData { (studentLocations, error) in
      guard error == nil else {
        let alert = UIAlertController(title: "Error", message: "Could not load student locations. Please check your connection and try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
        return
      }
      StudentInformation.shared.studentLocations = studentLocations
      if let viewControllers = self.viewControllers {
        for vc in viewControllers {
          let viewController = vc as! StudentLocationUpdate
          viewController.update()
        }
      }
    }
  }
  
  @IBAction func onLogout(_ sender: Any) {
    APIClient.logout { (success, error) in
      guard success else { return }
      self.navigationController?.popViewController(animated: true)
    }
  }
  
  @IBAction func onReload(_ sender: Any) {
    loadStudentData()
  }
  
  @IBAction func onAddNew(_ sender: Any) {
    let addNewController = storyboard?.instantiateViewController(withIdentifier: "AddLocationInputController") as! AddLocationInputController
    navigationController?.pushViewController(addNewController, animated: true)
  }
}
