//
//  ViewController.swift
//  SwiftDemo
//
//  Created by Sean Zeng on 7/2/16.
//  Copyright © 2016 Yahoo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var countLabel: CountLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // test count label
        countLabel.countToNumber(10000, duration: 2.0) { (countLabel, progress) in
            print(progress)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
