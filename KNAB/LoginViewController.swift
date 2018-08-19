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
    
    var finishedLogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if finishedLogin {
            let segueIdentifier: String = {
                let budgetIsSelected = UserDefaults.selectedBudgetID != nil
                let categoriesAreSelected = UserDefaults.selectedSpendCategoryID != nil && UserDefaults.selectedSaveCategoryID != nil  && UserDefaults.selectedGiveCategoryID != nil
                
                if budgetIsSelected {
                    if categoriesAreSelected {
                        return "segueToBudgets"
                    } else {
                        return "segueToCategorySelector"
                    }
                } else {
                    return "segueToBudgetSelector"
                }
            }()
            
            performSegue(withIdentifier: segueIdentifier, sender: nil)
        }
    }

    @IBAction func login(_ sender: Any) {

        let authenticated: () -> Void = {
            self.finishedLogin = true
        }
        
        let failed: (Error) -> Void = { error in
            self.showErrorAlert(with: "Login Failed. Please try again.")
        }
        
        YNAB.login(clientID: clientID, redirectURI: redirectURI, state: state, authenticated: authenticated, failed: failed)
    }
}
