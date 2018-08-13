//
//  LoginViewController.swift
//  KNAB
//
//  Created by TQL Mobile on 7/29/18.
//  Copyright © 2018 Dauby Cafe. All rights reserved.
//

import UIKit
import BudgetKit

class LoginViewController: UIViewController {

    var clientID: String = "f8c0b6a090eb98bd9f5f954d68bffa6dd4324c6e14c7fd5a7208cd8cc9ac655c"
    var redirectURI: String = "com.daubycafe.ynat://oauth2redirect/login"
    var state: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
    }

    @IBAction func login(_ sender: Any) {
        let authenticated: () -> Void = {
            self.performSegue(withIdentifier: "segueToBudgetSelector", sender: nil)
        }
        
        let failed: (Error) -> Void = { error in
            self.showErrorAlert(with: "Login Failed. Please try again.")
        }
        
        YNAB.login(clientID: clientID, redirectURI: redirectURI, state: state, authenticated: authenticated, failed: failed)
    }
}
