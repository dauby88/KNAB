//
//  IncomeAmountViewController.swift
//  KNAB
//
//  Created by TQL Mobile on 8/19/18.
//  Copyright © 2018 Dauby Cafe. All rights reserved.
//

import UIKit
import BudgetKit

class IncomeAmountViewController: UIViewController {

    @IBOutlet weak var amountLabel: UILabel!
    
    var amount: Milliunits = 5000 {
        didSet {
            amountLabel.text = amount.dollarAmount
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func incrementAmount(_ sender: Any) {
        amount += 500
    }
    
    @IBAction func decrementAmount(_ sender: Any) {
        let newAmount = amount - 500
        let amountIsNegative = newAmount < 0
        amount = amountIsNegative ? 0 : newAmount
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToGivingAmount" {
            let destination = segue.destination as! AddToCategoryViewController
            destination.configure(totalAmount: amount, category: .give)
        }
    }

}
