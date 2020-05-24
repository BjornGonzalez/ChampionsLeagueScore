//
//  TextField+Extension.swift
//
//  Created by Björn Gonzalez on 2020-02-17.
//  Copyright © 2020 Bjorn Gonzalez. All rights reserved.
//


import Foundation
import UIKit

extension UITextField {
    func addLeftView() {
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        self.leftView = view
        self.leftViewMode = .always
    }

    
    func isValidEmail() -> Bool {
        let emailRegex: NSString = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: self.text)
    }
    
    func isEmpty() -> Bool {
        let performedString: NSString = (self.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))! as NSString
        return performedString.length == 0 ? true : false
    }
}
