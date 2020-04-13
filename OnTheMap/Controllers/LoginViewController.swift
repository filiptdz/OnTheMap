//
//  ViewController.swift
//  OnTheMap
//
//  Created by Filipe Degrazia on 08/03/20.
//  Copyright © 2020 FilipeDegrazia. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
  enum Input: Int {
    case email, password
  }
  
  var email: String?
  var password: String?
  
  @IBOutlet var inputs: [UITextField]!
  @IBOutlet weak var loginButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loginButton.layer.cornerRadius = 6.0
    for input in inputs {
      input.delegate = self
    }
    
    inputs[0].text = email
    inputs[1].text = password
    
    navigationController?.setNavigationBarHidden(true, animated: true)
  }
  
  func toggleScreenInteraction(_ enable: Bool) {
    for input in inputs {
      input.isUserInteractionEnabled = enable
    }
    loginButton.isEnabled = enable
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let currentText = textField.text ?? ""
    let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
    
    switch Input(rawValue: textField.tag) {
    case .email:
      email = newText
    case .password:
      password = newText
    case .none:
      break
    }
    
    return true
  }
  
  @IBAction func loginPress(_ sender: Any) {
    toggleScreenInteraction(false)
    if let email = email, let password = password {
      APIClient.login(username: email, password: password) { (success, error) in
        self.toggleScreenInteraction(true)
        guard success else {
          let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
          self.present(alert, animated: true)
          return
        }
        
        let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
        self.navigationController?.pushViewController(tabBarController, animated: true)
      }
    } else {
      let alert = UIAlertController(title: "Error", message: "Please Complete all fields before submitting.", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alert, animated: true)
      toggleScreenInteraction(true)
    }
  }
  
  @IBAction func signupPress(_ sender: Any) {
    UIApplication.shared.open(URL(string: "https://auth.udacity.com/sign-up")!, options: [:], completionHandler: nil)
  }
}
