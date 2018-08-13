//
//  StartupViewController.swift
//  KNAB
//
//  Created by TQL Mobile on 7/29/18.
//  Copyright © 2018 Dauby Cafe. All rights reserved.
//

import UIKit
import BudgetKit

class StartupViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let identifier = startupSegueIdentifier
        performSegue(withIdentifier: identifier, sender: nil)
    }
    
    var startupSegueIdentifier: String {
        let budgetIsSelected = UserDefaults.selectedBudgetID != nil
        let categoriesAreSelected = UserDefaults.selectedSpendCategoryID != nil && UserDefaults.selectedSaveCategoryID != nil  && UserDefaults.selectedGiveCategoryID != nil
        if YNAB.userIsLoggedIn {
            if budgetIsSelected {
                if categoriesAreSelected {
                    return "segueToBudgets"
                } else {
                    return "segueToCategorySelector"
                }
            } else {
                return "segueToBudgetSelector"
            }
        } else {
            return "segueToLogin"
        }
    }
}
