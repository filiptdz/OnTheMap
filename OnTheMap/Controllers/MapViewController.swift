//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Filipe Degrazia on 17/03/20.
//  Copyright © 2020 FilipeDegrazia. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, StudentLocationUpdate, MKMapViewDelegate {
  @IBOutlet weak var mapView: MKMapView!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    mapView.delegate = self
  }
  
  func update() {
    mapView.removeAnnotations(mapView.annotations)
    for studentLocation in StudentInformation.shared.studentLocations! {
      let pin = MKPointAnnotation()
      pin.title = "\(studentLocation.firstName) \(studentLocation.lastName)"
      pin.subtitle = studentLocation.mediaURL
      pin.coordinate = CLLocationCoordinate2D(latitude: studentLocation.latitude, longitude: studentLocation.longitude)
      mapView.addAnnotation(pin)
    }
  }
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard annotation is MKPointAnnotation else { return nil }
    
    let identifier = "pin"
    var pin = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
    
    if pin == nil {
      pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
      pin?.canShowCallout = true
      pin?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    } else {
      pin!.annotation = annotation
    }
    
    return pin
  }
  
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    func showErrorModal() {
      let alert = UIAlertController(title: "Error", message: "User location doesn't contain a valid URL", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alert, animated: true)
    }
    
    if let link = view.annotation?.subtitle!, let url = URL(string: link) {
      UIApplication.shared.open(url, options: [:]) { success in
        if !success {
          showErrorModal()
        }
      }
    } else {
      showErrorModal()
    }
  }
}
