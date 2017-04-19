//
//  StandardButton.swift
//  HK
//
//  Created by Stefan Adams on 19/04/2017.
//  Copyright © 2017 Stefan Adams. All rights reserved.
//

import Foundation
import UIKit

class StandardButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = self.bounds.height/2
        self.backgroundColor = UIColor(red:0.36, green:0.57, blue:0.79, alpha:1.00)
        self.setTitleColor(.white, for: .normal)
    }
    
}
