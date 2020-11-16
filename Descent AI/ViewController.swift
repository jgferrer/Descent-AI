//
//  ViewController.swift
//  Descent AI
//
//  Created by Jose Gabriel Ferrer on 15/11/20.
//

import UIKit

class ViewController: UIViewController {
    
    var overLord = OverLord()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        overLord.init_deck()
        overLord.init_hand()
        print(overLord.hand)
    }
}

