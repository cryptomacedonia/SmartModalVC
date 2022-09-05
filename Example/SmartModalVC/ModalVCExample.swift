//
//  ModalVCExample.swift
//  SmartModalVC_Example
//
//  Created by Igor Jovcevski on 5.9.22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import SmartModalVC
class ModalVCExample: UIViewController, VCThatReturnsData {
    var returnValueClosure: ((Any) -> ())?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func option1Action(_ sender: Any) {
        
        returnValueClosure?("option 1")
        
    }
    @IBAction func option2action(_ sender: Any) {
        returnValueClosure?("option 2")
    }
    
    @IBAction func option3Action(_ sender: Any) {
        returnValueClosure?("option 3")
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
