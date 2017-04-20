//
//  ViewController.swift
//  HK
//
//  Created by Stefan Adams on 18/04/2017.
//  Copyright © 2017 Stefan Adams. All rights reserved.
//

import UIKit
import HomeKit

class ViewController: UIViewController, HMAccessoryBrowserDelegate {

    // MARK: - IBOutlets
    
    @IBOutlet weak var selectedHomeLabel: UILabel!
    @IBOutlet weak var selectedAccessoryLabel: UILabel!
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - ViewModel
    
    let viewModel = ViewModel()
    
    // MARK: - ViewFlow
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.accessoryBrowser.delegate = self
    }
    
    // MARK: - IBActions
    
    @IBAction func retrieveHomes(_ sender: Any) {
        viewModel.retrieveHomes {
            picker.reloadAllComponents()
        }
    }
    
    @IBAction func addHome(_ sender: Any) {
        print("Try adding home...")
        showHomeAlert()
    }
    
    @IBAction func addAccessory(_ sender: Any) {
        print("Try adding accessory...")
        if viewModel.canAddAccessory {
            self.viewModel.addAccessory()
        } else {
            showAccessoryFailureAlert()
        }
    }
    
    @IBAction func startSearching(_ sender: Any) {
        print("Start search...")
        viewModel.startSearchingForNewAccessories()
    }
    
    func accessoryBrowser(_ browser: HMAccessoryBrowser, didFindNewAccessory accessory: HMAccessory) {
        viewModel.accessories.append(accessory)
        tableView.reloadData()
    }
}

// MARK - Alerts
    
extension ViewController {
    func showHomeAlert() {
        let alert = UIAlertController(title: "Add new home", message: "Please fill in a name for your new home.", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Homename..."
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            guard let homeName = textField?.text else { return }
            self.viewModel.addHome(with: homeName)
            self.viewModel.retrieveHomes {
                self.picker.reloadAllComponents()
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(okAction)
        alert.addAction(cancelAction)        
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAccessoryFailureAlert() {
        let alert = UIAlertController(title: "Adding accessory failed", message: "Make sure you selected a home and accessory", preferredStyle: .alert)
        let okAction =  UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - TableView

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.accessories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = viewModel.accessories[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        selectedAccessoryLabel.text = cell?.textLabel?.text
        viewModel.selectedAccessory = viewModel.accessories[indexPath.row]
    }
    
}

// MARK: - PickerView

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.homes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.homes[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedHomeLabel.text = viewModel.homes[row].name
        viewModel.selectedHome = viewModel.homes[row]
    }
}
