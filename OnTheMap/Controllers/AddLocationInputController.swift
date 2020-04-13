//
//  AddLocationInputController.swift
//  OnTheMap
//
//  Created by Filipe Degrazia on 19/03/20.
//  Copyright © 2020 FilipeDegrazia. All rights reserved.
//

import UIKit
import MapKit

class AddLocationInputController: UIViewController {
  @IBOutlet weak var locationTextField: UITextField!
  @IBOutlet weak var mediaURLTextField: UITextField!
  
  @IBOutlet weak var findLocationButton: UIButton!
  @IBOutlet weak var cancelButton: UIBarButtonItem!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    findLocationButton.layer.cornerRadius = 6.0
    
    let cancelButtonTextAttributes: [NSAttributedString.Key : Any] = [
      NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.7535467744, blue: 0.9159824252, alpha: 1),
      NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16.0)
    ]
    cancelButton.setTitleTextAttributes(cancelButtonTextAttributes, for: .normal)
  }
  
  func toggleScreenInteraction(_ enable: Bool) {
    locationTextField.isUserInteractionEnabled = enable
    mediaURLTextField.isUserInteractionEnabled = enable
    findLocationButton.isEnabled = enable
    enable ? activityIndicator.stopAnimating() : activityIndicator.startAnimating()
  }
  
  @IBAction func submit(_ sender: Any) {
    toggleScreenInteraction(false)
    if let locationTextFieldText = locationTextField.text, let mediaURLTextFieldText = mediaURLTextField.text {
      let request = MKLocalSearch.Request()
      request.naturalLanguageQuery = locationTextFieldText
      let search = MKLocalSearch(request: request)
      search.start { (response, error) in
        guard error == nil else {
          let alert = UIAlertController(title: "Error", message: "Couldn't find a location for the given address.", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
          self.present(alert, animated: true)
          self.toggleScreenInteraction(true)
          return
        }
        
        APIClient.getUserData { (userData, error) in
          guard let userData = userData else {
            let alert = UIAlertController(title: "Error", message: "Couldn't find currently logged in user.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            self.toggleScreenInteraction(true)
            return
          }
          
          let mapController = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationMapController") as! AddLocationMapController
          mapController.location = response?.boundingRegion
          let locationCoordinates = response!.boundingRegion.center
          mapController.studentLocation = StudentLocation(objectId: nil, uniqueKey: UUID().uuidString, firstName: userData.firstName, lastName: userData.lastName, mapString: locationTextFieldText, mediaURL: mediaURLTextFieldText, latitude: locationCoordinates.latitude, longitude: locationCoordinates.longitude)
          self.navigationController?.pushViewController(mapController, animated: true)
          self.toggleScreenInteraction(true)
        }
      }
    } else {
      let alert = UIAlertController(title: "Error", message: "Complete all the required fields before submitting.", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alert, animated: true)
      toggleScreenInteraction(true)
    }
  }
  
  @IBAction func cancel(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
}
