//
//  GameController.swift
//  Descent_AI
//
//  Created by Jose Gabriel Ferrer on 20/11/20.
//

import Foundation
import UIKit
import FontAwesome_swift

class GameController: UIViewController {
    
    var overLord = OverLord()
    var quest: Quest?
    var numberOfHeroes: Int = 0
    
    @IBOutlet weak var lblQuestName: UILabel!
    
    @IBOutlet weak var btnWalk: UIButton!
    @IBOutlet weak var btnDoor: UIButton!
    @IBOutlet weak var btnChest: UIButton!
    @IBOutlet weak var btnEncounter: UIButton!
    @IBOutlet weak var btnEndTurn: UIButton!
    
    @IBOutlet weak var lblHeroMovement: UILabel!
    @IBOutlet weak var lblOpenChest: UILabel!
    @IBOutlet weak var lblOpenDoor: UILabel!
    @IBOutlet weak var lblEncounter: UILabel!
    @IBOutlet weak var lblEndTurn: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overLord.init_deck()
        overLord.init_hand()
        overLord.heroes_count = numberOfHeroes
        
        lblQuestName.text = quest?.name
        lblHeroMovement.text = NSLocalizedString("Hero movement", comment: "User informs that hero moves")
        lblOpenChest.text = NSLocalizedString("Open chest", comment: "Hero open chest")
        lblOpenDoor.text = NSLocalizedString("Open door", comment: "Hero open door")
        lblEncounter.text = NSLocalizedString("Encounter", comment: "Encounter (Token ?)")
        lblEndTurn.text = NSLocalizedString("End turn", comment: "End turn")
        
        btnWalk.titleLabel?.font = UIFont.fontAwesome(ofSize: 45, style: .solid)
        btnWalk.setTitle(String.fontAwesomeIcon(name: .walking), for: .normal)
        btnDoor.titleLabel?.font = UIFont.fontAwesome(ofSize: 45, style: .solid)
        btnDoor.setTitle(String.fontAwesomeIcon(name: .dungeon), for: .normal)
        btnChest.titleLabel?.font = UIFont.fontAwesome(ofSize: 45, style: .solid)
        btnChest.setTitle(String.fontAwesomeIcon(name: .box), for: .normal)
        btnEncounter.titleLabel?.font = UIFont.fontAwesome(ofSize: 45, style: .regular)
        btnEncounter.setTitle(String.fontAwesomeIcon(name: .questionCircle), for: .normal)
        btnEndTurn.titleLabel?.font = UIFont.fontAwesome(ofSize: 45, style: .solid)
        btnEndTurn.setTitle(String.fontAwesomeIcon(name: .arrowCircleRight), for: .normal)
        
    }
    @IBAction func btnVolver(_ sender: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectQuestController") as? SelectQuestController {
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false, completion: nil)
        }
    }
    @IBAction func EndTurn(_ sender: UIButton) {
        overLord.overlord_turn()
    }
}

