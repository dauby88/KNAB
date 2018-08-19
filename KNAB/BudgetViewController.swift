//
//  BudgetViewController.swift
//  KNAB
//
//  Created by TQL Mobile on 8/5/18.
//  Copyright © 2018 Dauby Cafe. All rights reserved.
//

import UIKit
import BudgetKit

class BudgetViewController: UIViewController {

    @IBOutlet weak var spendView: UIView!
    @IBOutlet weak var saveView: UIView!
    @IBOutlet weak var giveView: UIView!
    
    @IBOutlet weak var spendBalanceLabel: UILabel!
    @IBOutlet weak var saveBalanceLabel: UILabel!
    @IBOutlet weak var giveBalanceLabel: UILabel!
    
    let budgetID = UserDefaults.selectedBudgetID!
    
    var spendBalance: Milliunits = 0
    var saveBalance: Milliunits = 0
    var giveBalance: Milliunits = 0
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getCategoryBalances {
            print("Got balances")
        }
    }
    
    func getCategoryBalances(completion: @escaping () -> Void) {
        let group = DispatchGroup()
        group.enter()
        getSpendCategoryBalance {
            group.leave()
        }
        
        group.enter()
        getSaveCategoryBalance {
            group.leave()
        }
        
        group.enter()
        getGiveCategoryBalance {
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.spendBalanceLabel.text = self.spendBalance.dollarAmount
            self.saveBalanceLabel.text = self.saveBalance.dollarAmount
            self.giveBalanceLabel.text = self.giveBalance.dollarAmount
            completion()
        }
    }
    
    func getSpendCategoryBalance(completion: @escaping () -> Void) {
        let categoryID = UserDefaults.selectedSpendCategoryID!
        YNAB.getCategory(budgetID: budgetID, categoryID: categoryID) { (result) in
            switch result {
            case .success(let category):
                self.spendBalance = category.balance
            case .failure:
                print("Failed to get spending balance.")
            }
            completion()
        }
    }
    
    func getSaveCategoryBalance(completion: @escaping () -> Void) {
        let categoryID = UserDefaults.selectedSaveCategoryID!
        YNAB.getCategory(budgetID: budgetID, categoryID: categoryID) { (result) in
            switch result {
            case .success(let category):
                self.saveBalance = category.balance
            case .failure:
                print("Failed to get saving balance.")
            }
            completion()
        }
    }
    
    func getGiveCategoryBalance(completion: @escaping () -> Void) {
        let categoryID = UserDefaults.selectedGiveCategoryID!
        YNAB.getCategory(budgetID: budgetID, categoryID: categoryID) { (result) in
            switch result {
            case .success(let category):
                self.giveBalance = category.balance
            case .failure:
                print("Failed to get giving balance.")
            }
            completion()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToNewTransaction" {
            let navController = segue.destination as! UINavigationController
            let destination = navController.viewControllers[0] as! NewTransactionViewController
            destination.delegate = self
        } else if segue.identifier == "segueToTransactionList" {
            let navController = segue.destination as! UINavigationController
            let destination = navController.viewControllers[0] as! TransactionsTableViewController
            let category = sender as! KidsCategory
            destination.configure(category: category)            
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        YNAB.logout()
    }
    
    @IBAction func showSpendTransactions(_ sender: Any) {
        performSegue(withIdentifier: "segueToTransactionList", sender: KidsCategory.spend)
    }
    
    @IBAction func showGiveTransactions(_ sender: Any) {
        performSegue(withIdentifier: "segueToTransactionList", sender: KidsCategory.give)
    }
    
    @IBAction func showSaveTransactions(_ sender: Any) {
        performSegue(withIdentifier: "segueToTransactionList", sender: KidsCategory.save)
    }
}


extension BudgetViewController: NewTransactionViewControllerDelegate {
    func transactionViewControllerCancelled() {
        dismiss(animated: true, completion: nil)
    }
    
    func transactionViewControllerSubmittedTransaction() {
        dismiss(animated: true) {
            self.getCategoryBalances {}
        }
    }
}
