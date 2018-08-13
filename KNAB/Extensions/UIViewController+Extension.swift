//
//  UIViewController+Extension.swift
//  KNAB
//
//  Created by TQL Mobile on 7/29/18.
//  Copyright © 2018 Dauby Cafe. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showErrorAlert(with message: String?) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
