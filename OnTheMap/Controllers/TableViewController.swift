//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Filipe Degrazia on 17/03/20.
//  Copyright © 2020 FilipeDegrazia. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, StudentLocationUpdate, UITableViewDataSource, UITableViewDelegate {
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
  }
  
  func update() {
    if let tableView = tableView {
      tableView.reloadData()
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      if let studentLocations = StudentInformation.shared.studentLocations {
        return studentLocations.count
      }
    }
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let currentItem = StudentInformation.shared.studentLocations![indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "studentLocationCell", for: indexPath)
    cell.textLabel!.text = "\(currentItem.firstName) \(currentItem.lastName)"
    cell.detailTextLabel!.text = currentItem.mediaURL
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    func showErrorModal() {
      let alert = UIAlertController(title: "Error", message: "User location doesn't contain a valid URL", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alert, animated: true)
    }
    
    if let userLocations = StudentInformation.shared.studentLocations, let url = URL(string: userLocations[indexPath.row].mediaURL) {
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
