//
//  ViewController.swift
//  RestfulApiCalling
//
//  Created by Lalit Kant on 2/15/17.
//  Copyright © 2017 Lalit Kant. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        
        // Call api with the help of it
        
        ApiCall().methodTocallservice(info: "Any string can be passed") { (response) in
            if (response["Error"] != nil){
                /* have condition for failure */
                return
            }
             /* have condition for Success */
        }
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

