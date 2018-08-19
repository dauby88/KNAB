//
//  AddToGivingViewController.swift
//  KNAB
//
//  Created by TQL Mobile on 8/19/18.
//  Copyright © 2018 Dauby Cafe. All rights reserved.
//

import UIKit
import BudgetKit
import EFCountingLabel

class AddToCategoryViewController: UIViewController {

    @IBOutlet weak var amountLabel: EFCountingLabel! {
        didSet {
            amountLabel.text = transferAmount.dollarAmount
        }
    }
    @IBOutlet weak var balanceLabel: EFCountingLabel! {
        didSet {
            balanceLabel.text = "$-.--"
        }
    }
    
    var category: KidsCategory!
    var totalAmount: Milliunits!
    var categoryBalance: Milliunits? {
        didSet {
            DispatchQueue.main.async {
                self.balanceLabel.text = self.categoryBalance?.dollarAmount
            }
        }
    }
    var isLoading = true
    var transferComplete = false
    
    var transferAmount: Milliunits {
        switch category! {
        case .give:
            return totalAmount / 10
        case .spend, .save:
            return totalAmount / 20 * 9
        }
    }
    
    func configure(totalAmount: Milliunits, category: KidsCategory) {
        self.totalAmount = totalAmount
        self.category = category
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCategoryBalance()
    }
    
    func getCategoryBalance() {
        let budgetID = UserDefaults.selectedBudgetID!
        let categoryID = category.selectedID!
        YNAB.getCategory(budgetID: budgetID, categoryID: categoryID) { (result) in
            switch result {
            case .success(let category):
                self.isLoading = false
                self.categoryBalance = category.balance
            case .failure:
                self.showErrorAlert(with: "Unable to load category balance.")
            }
        }
    }

    @IBAction func transferToCategory(_ sender: Any) {
        guard transferComplete == false else {
            return
        }
        guard let balance = categoryBalance else {
            showErrorAlert(with: "Please wait until your balance has loaded.")
            return
        }
        transferComplete = true
        let amountStart = CGFloat(YNAB.convertMilliUnitsToCurrencyAmount(transferAmount, currencyDecimalDigits: 2)!)
        let balanceStart = CGFloat(YNAB.convertMilliUnitsToCurrencyAmount(balance, currencyDecimalDigits: 2)!)
        let balanceEnd = amountStart + balanceStart
        
        amountLabel.attributedFormatBlock = { float in
            let formatter = NumberFormatter()
            let locale = Locale(identifier: "en_US")
            formatter.locale = locale
            formatter.numberStyle = .currency
            formatter.maximumFractionDigits = 2
            let number = float as NSNumber
            let string = formatter.string(from: number)!
            return NSAttributedString(string: string)
        }
        balanceLabel.attributedFormatBlock = { float in
            let formatter = NumberFormatter()
            let locale = Locale(identifier: "en_US")
            formatter.locale = locale
            formatter.numberStyle = .currency
            formatter.maximumFractionDigits = 2
            let number = float as NSNumber
            let string = formatter.string(from: number)!
            return NSAttributedString(string: string)
        }
        
        balanceLabel.completionBlock = {
            var identifier = ""
            switch self.category! {
            case .give:
                identifier = "segueToSavingAmount"
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                    self.performSegue(withIdentifier: identifier, sender: nil)
                })
            case .save:
                identifier = "segueToSpendingAmount"
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                    self.performSegue(withIdentifier: identifier, sender: nil)
                })
            case .spend:
                let budgetID = UserDefaults.selectedBudgetID!
                YNAB.getAccountList(budgetID: budgetID, completion: { (accountResult) in
                    switch accountResult {
                    case .success(let accounts):
                        let accountID = accounts.first?.id
                        let date = DateFormatter.ynab.string(from: Date())
                        let transaction = NewTransaction(accountID: accountID!, date: date, amount: self.totalAmount, payeeID: nil, payeeName: "KNAB Payee", categoryID: nil, memo: nil, status: .uncleared, approved: false, flagColor: nil, importID: nil)
                        let budgetID = UserDefaults.selectedBudgetID!
                        YNAB.createNewTransaction(transaction, budgetID: budgetID, completion: { (result) in
                            switch result {
                            case .success:
                                self.dismiss(animated: true, completion: nil)
                            case .failure:
                                self.showErrorAlert(with: "Failed to post new transaction.")
                            }
                        })
                    case .failure(_):
                        self.showErrorAlert(with: "Failed to get account.")
                    }
                })
            }
            
        }

        amountLabel.countFrom(amountStart, to: 0.00, withDuration: 1.5)
        balanceLabel.countFrom(balanceStart, to: balanceEnd, withDuration: 1.6)
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToSavingAmount" {
            let destination = segue.destination as! AddToCategoryViewController
            destination.configure(totalAmount: totalAmount, category: .save)
        } else if segue.identifier == "segueToSpendingAmount" {
            let destination = segue.destination as! AddToCategoryViewController
            destination.configure(totalAmount: totalAmount, category: .spend)
        }
    }
}
