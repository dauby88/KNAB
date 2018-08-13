//
//  SaveSelectorViewController.swift
//  KNAB
//
//  Created by TQL Mobile on 8/5/18.
//  Copyright © 2018 Dauby Cafe. All rights reserved.
//

import UIKit
import BudgetKit

class SaveSelectorViewController: UITableViewController {
    
    var categories = [BudgetKit.Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories {
            DispatchQueue.main.async {
                self.reloadTableViews()
            }
        }
    }
    
    func loadCategories(completion: @escaping () -> Void) {
        guard let budgetID = UserDefaults.selectedBudgetID else {
            showErrorAlert(with: "There is no budget selected.")
            return
        }
        YNAB.getCategoryList(budgetID: budgetID) { (result) in
            switch result {
            case .success(let categories):
                self.categories = categories
                completion()
            case .failure(let error):
                self.showErrorAlert(with: error.localizedDescription)
                completion()
            }
        }
    }
    
    func reloadTableViews() {
        DispatchQueue.main.async {
            let sections = IndexSet(integer: 0)
            self.tableView.reloadSections(sections, with: .automatic)
        }
    }
    
    @IBAction func reloadCategories() {
        loadCategories {
            self.reloadTableViews()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "saveSelectionCell")!
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = categories[indexPath.row].id
        UserDefaults.selectedSaveCategoryID = id
    }
}
