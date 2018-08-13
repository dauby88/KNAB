//
//  NewTransactionViewController.swift
//  KNAB
//
//  Created by TQL Mobile on 8/7/18.
//  Copyright © 2018 Dauby Cafe. All rights reserved.
//

import UIKit

protocol NewTransactionViewControllerDelegate: class {
    func transactionViewControllerCancelled()
    func transactionViewControllerSubmittedTransaction()
}

class NewTransactionViewController: UIViewController {

    weak var delegate: NewTransactionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.transactionViewControllerCancelled()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
