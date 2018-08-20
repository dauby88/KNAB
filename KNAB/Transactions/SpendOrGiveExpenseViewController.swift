//
//  SpendOrGiveExpenseViewController.swift
//  KNAB
//
//  Created by TQL Mobile on 8/19/18.
//  Copyright © 2018 Dauby Cafe. All rights reserved.
//

import UIKit

class SpendOrGiveExpenseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! NewSpendTransactionViewController
        if segue.identifier == "segueFromSpendingExpense" {
            destination.configure(category: .spend)
        } else if segue.identifier == "segueFromGivingExpense" {
            destination.configure(category: .give)
        }
    }
}
