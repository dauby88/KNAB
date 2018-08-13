//
//  BudgetSelectorViewController.swift
//  KNAB
//
//  Created by TQL Mobile on 7/29/18.
//  Copyright © 2018 Dauby Cafe. All rights reserved.
//

import UIKit
import BudgetKit

class BudgetSelectorViewController: UITableViewController {

    var budgets = [BudgetSummary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBudgets {
            DispatchQueue.main.async {
                let sections = IndexSet(integer: 0)
                self.tableView.reloadSections(sections, with: .automatic)
            }
        }
    }

    func loadBudgets(completion: @escaping () -> Void) {
        YNAB.getBudgetList { (result) in
            switch result {
            case .success(let budgets):
                self.budgets = budgets
                completion()
            case .failure(let error):
                self.showErrorAlert(with: error.localizedDescription)
                completion()
            }
        }
    }
    
    @IBAction func reloadBudgets() {
        loadBudgets {
            self.tableView.reloadData()
        }
    }

    // MARK: - TableView
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return budgets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "budgetSelectionCell")!
        let budget = budgets[indexPath.row]
        cell.textLabel?.text = budget.name
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = budgets[indexPath.row].id
        UserDefaults.selectedBudgetID = id
    }
}
