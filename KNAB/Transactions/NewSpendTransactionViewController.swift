//
//  NewSpendTransactionViewController.swift
//  KNAB
//
//  Created by TQL Mobile on 8/19/18.
//  Copyright © 2018 Dauby Cafe. All rights reserved.
//

import UIKit
import BudgetKit

class NewSpendTransactionViewController: UIViewController {
    
    @IBOutlet weak var amountLabel: UILabel!

    var category: KidsCategory!
    var amount: Milliunits = 5000 {
        didSet {
            amountLabel.text = amount.dollarAmount
        }
    }
    
    func configure(category: KidsCategory) {
        self.category = category
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func incrementAmount(_ sender: Any) {
        amount += 500
    }
    
    @IBAction func decrementAmount(_ sender: Any) {
        let newAmount = amount - 500
        let amountIsNegative = newAmount < 0
        amount = amountIsNegative ? 0 : newAmount
    }
    
    @IBAction func submitTransaction(_ sender: Any) {
        let budgetID = UserDefaults.selectedBudgetID!
        YNAB.getAccountList(budgetID: budgetID, completion: { (accountResult) in
            switch accountResult {
            case .success(let accounts):
                let accountID = accounts.first!.id
                let date = DateFormatter.yyyyMMdd.string(from: Date())
                let categoryID = self.category.selectedID!
                
                let transaction = NewTransaction(accountID: accountID, date: date, amount: self.amount, payeeID: nil, payeeName: "KNAB Payee", categoryID: categoryID, memo: nil, status: .uncleared, approved: true, flagColor: nil, importID: nil)
                
                let budgetID = UserDefaults.selectedBudgetID!
                YNAB.createNewTransaction(transaction, budgetID: budgetID, completion: { (result) in
                    switch result {
                    case .success:
                        self.dismiss(animated: true, completion: nil)
                    case .failure:
                        let alert = UIAlertController(title: "Error", message: "Failed to post new transaction.", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
                            self.dismiss(animated: true, completion: nil)
                        })
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                })
            case .failure(_):
                self.showErrorAlert(with: "Failed to get account.")
            }
        })
    }
}
