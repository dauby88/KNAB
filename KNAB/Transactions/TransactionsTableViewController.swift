//
//  TransactionsTableViewController.swift
//  KNAB
//
//  Created by TQL Mobile on 8/12/18.
//  Copyright © 2018 Dauby Cafe. All rights reserved.
//

import UIKit
import BudgetKit

class TransactionsTableViewController: UITableViewController {

    var category: KidsCategory!
    
    var transactions = [TransactionDetail]()
    
    func configure(category: KidsCategory) {
        self.category = category
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = category.name
        tableView.backgroundColor = category.color
        
        loadTransactions {
            DispatchQueue.main.async {
                let sections = IndexSet(integer: 0)
                self.tableView.reloadSections(sections, with: .automatic)
            }
        }
    }
    
    func loadTransactions(completion: @escaping () -> Void) {
        guard let budgetID = UserDefaults.selectedBudgetID else {
            self.showErrorAlert(with: "A budget has not been selected.")
            completion()
            return
        }
        
        YNAB.getTransactionListForCategory(budgetID: budgetID, categoryID: category.selectedID!) { (result) in
            switch result {
            case .success(let transactions):
                self.transactions = transactions
                completion()
            case .failure(let error):
                self.showErrorAlert(with: error.localizedDescription)
                completion()
            }
        }
    }
    
    @IBAction func reloadTransactions() {
        loadTransactions {
            let sections = IndexSet(integer: 0)
            self.tableView.reloadSections(sections, with: .automatic)
        }
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - TableView
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "budgetSelectionCell")!
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        let transaction = transactions[indexPath.row]
        cell.textLabel?.text = transaction.payeeName
        cell.detailTextLabel?.text = transaction.amount.dollarAmount
        return cell
    }
}
