//
//  AddLocationMapController.swift
//  OnTheMap
//
//  Created by Filipe Degrazia on 19/03/20.
//  Copyright © 2020 FilipeDegrazia. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AddLocationMapController: UIViewController, MKMapViewDelegate {
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var finishButton: UIButton!
  
  var studentLocation: StudentLocation!
  var location: MKCoordinateRegion!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    mapView.delegate = self
    
    finishButton.layer.cornerRadius = 6.0
    
    if let location = location {
      mapView.setRegion(location, animated: true)
    }
    let pin = MKPointAnnotation()
    pin.coordinate = location.center
    pin.title = studentLocation.mapString
    mapView.addAnnotation(pin)
  }
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard annotation is MKPointAnnotation else { return nil }
    
    let identifier = "pin"
    var pin = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
    
    if pin == nil {
      pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
      pin?.canShowCallout = true
    } else {
      pin!.annotation = annotation
    }
    
    return pin
  }

  @IBAction func submit(_ sender: Any) {
    APIClient.saveLocation(studentLocation: studentLocation) { (success, error) in
      guard success else {
        let alert = UIAlertController(title: "Error", message: "Couldn't find a location for the given address", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
        return
      }
      let viewControllers = self.navigationController!.viewControllers
      self.navigationController?.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
      let tabBarController = viewControllers[viewControllers.count - 3] as! TabBarController
      tabBarController.loadStudentData()
    }
  }
}
