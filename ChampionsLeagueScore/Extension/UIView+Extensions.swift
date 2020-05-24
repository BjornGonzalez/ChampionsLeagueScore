//
//  UIView+Extensions.swift
//
//  Created by Björn Gonzalez on 2020-02-17.
//  Copyright © 2020 Bjorn Gonzalez. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

extension UIView {
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    }
    
    func setRadiusAndShadow(color: UIColor) {
        layer.cornerRadius = 5
        clipsToBounds = true
        layer.masksToBounds = false
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowColor = color.cgColor
    }
    
    func addCornerRadius() {
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
    
    func showLoading() {
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: self, animated: true)
            hud.label.text = "Loading..."
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self, animated: true)
        }
    }
    
    func showLoadingOnWindow() {
        DispatchQueue.main.async {
            if let window = SystemConstant.appDelegate?.window {
                let hud = MBProgressHUD.showAdded(to: window, animated: true)
                hud.label.text = "Loading..."
            }
        }
    }
    
    func hideLoadingFromWindow() {
        DispatchQueue.main.async {
            if let window = SystemConstant.appDelegate?.window {
                MBProgressHUD.hide(for: window, animated: true)
            }
        }
    }
    
    func roundCornersWith(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
