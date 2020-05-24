//
//  Utilities.swift
//  ChampionsLeagueScore
//
//  Created by Björn Gonzalez on 2020-05-04.
//  Copyright © 2020 Bjorn Gonzalez. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    
    
    
    
    static func styleFilledButton(_ button:UIButton) {
        
      // Filled rounded corner style
      button.backgroundColor = UIColor.init(red: 0.02, green: 0.00, blue: 0.22, alpha: 1.00)
      button.layer.cornerRadius = 25.0
      button.tintColor = UIColor.white
      button.layer.borderColor = UIColor.black.cgColor
      button.layer.shadowColor = UIColor.black.cgColor
      button.layer.shadowOpacity = 1
      button.layer.shadowOffset = CGSize.zero
      button.layer.shadowRadius = 2
    }
      
      static func styleHollowButton(_ button:UIButton) {
          
          // Hollow rounded corner style
          button.layer.borderWidth = 2
          button.layer.borderColor = UIColor.black.cgColor
          button.layer.cornerRadius = 25.0
          button.tintColor = UIColor.black
      }
    
    
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
}
