//
//  ViewModel.swift
//  HK
//
//  Created by Stefan Adams on 18/04/2017.
//  Copyright © 2017 Stefan Adams. All rights reserved.
//

import Foundation
import HomeKit

class ViewModel {
    
    // MARK: - Configuration
    
    let homeManager = HMHomeManager()
    let accessoryBrowser = HMAccessoryBrowser()
    
    var selectedHome: HMHome?
    var selectedAccessory: HMAccessory?
    
    var accessories: [HMAccessory] = [HMAccessory]()
    var homes: [HMHome] = [HMHome]()
    
    // MARK: - Homes
    
    func addHome(with name: String) {
        homeManager.addHome(withName: name) { home, error in
            if error != nil {
                print("Failed to add home")
            } else {
                print("Succesfully added home")
            }
        }
    }
    
    func retrieveHomes(completion: () -> ()) {
        homes = homeManager.homes
        completion()
    }
    
    // MARK: - Accessories
    
    func startSearchingForNewAccessories() {
        accessoryBrowser.startSearchingForNewAccessories()
    }
    
    var canAddAccessory: Bool {
        if selectedAccessory != nil && selectedHome != nil {
            return true
        } else {
            return false
        }
    }
    
    func addAccessory() {
        if selectedAccessory != nil && selectedHome != nil {
            selectedHome?.addAccessory(selectedAccessory!) { error in
                if error != nil {
                    print(error ?? "Failed to add accessory with name: \(self.selectedAccessory?.name ?? "No name")")
                } else {
                    print("Succesfully added accessory")
                }
            }
        }
    }
}
