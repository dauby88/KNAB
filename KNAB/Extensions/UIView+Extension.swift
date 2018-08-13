//
//  UIView+Extension.swift
//  KNAB
//
//  Created by TQL Mobile on 7/29/18.
//  Copyright © 2018 Dauby Cafe. All rights reserved.
//

import UIKit

extension UIView {
    
    // MARK: - IBInspectable Properties
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
}
