//
//  ShowCardController.swift
//  Descent_AI
//
//  Created by Jose Gabriel Ferrer on 21/12/20.
//

import Foundation
import UIKit

class ShowCardController: UIViewController {
    
    var card: Card?
    
    @IBOutlet weak var cardImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = Bundle.main.url(forResource: "#" + "\(card!.id)", withExtension: "png", subdirectory: "Cards/es")
        let data = try? Data(contentsOf: url!)
        cardImage.image = UIImage(data: data!)
    }
    
}
