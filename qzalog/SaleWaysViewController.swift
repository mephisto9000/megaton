//
//  SaleWaysViewController.swift
//  qzalog
//
//  Created by Marat Mustakayev on 12/19/16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

import UIKit

class SaleWaysViewController: UIViewController {

    @IBOutlet weak var navButton: UIBarButtonItem!
    @IBOutlet weak var nuvButtonIn: UIButton!

    override func viewDidLoad() {
                super.viewDidLoad()

           
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func navClick(_ sender: UIButton) {
       self.navigationController?.popToRootViewController(animated: true)
    }
  
    /* self.navigationController?.popToRootViewController(animated: true)
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
   

}
