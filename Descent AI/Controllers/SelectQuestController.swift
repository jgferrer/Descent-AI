//
//  SelectQuestController.swift
//  Descent AI
//
//  Created by Jose Gabriel Ferrer on 16/11/20.
//

import UIKit

class SelectQuestController: UIViewController {
    
    var overLord = OverLord()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        overLord.init_deck()
        overLord.init_hand()
        print(overLord.hand)
    }
}
