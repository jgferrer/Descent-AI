//
//  ViewController.swift
//  Descent AI
//
//  Created by Jose Gabriel Ferrer on 15/11/20.
//

import UIKit

class MainMenuController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension UITableView {

    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.tableFooterView = UIView()

    }
}
