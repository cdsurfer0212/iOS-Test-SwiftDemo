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
        
        // test count label
        countLabel.countToNumber(10000, duration: 2.0) { (countLabel, progress) in
            print(progress)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // test speech recognition
        self.present(SpeechRecognitionViewController(), animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
