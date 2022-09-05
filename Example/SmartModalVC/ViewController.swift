//
//  ViewController.swift
//  SmartModalVC
//
//  Created by cryptomacedonia on 09/05/2022.
//  Copyright (c) 2022 cryptomacedonia. All rights reserved.
//

import UIKit
import SmartModalVC
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func showSmartModalVC(_ sender: Any) {
        
        
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ModalVCExample") as! ModalVCExample
        
        
        
      try?  self.showDataReturningVC(optionsVC: vc, width: 300, height: 300, originatingView: (sender as! UIButton)) { rez  in
          
          print(rez)
          self.hideSmartVC {
              // now its gone
          }
        }
        
        
        
        
    }
    
}

