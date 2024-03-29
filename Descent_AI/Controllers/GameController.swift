//
//  GameController.swift
//  Descent_AI
//
//  Created by Jose Gabriel Ferrer on 20/11/20.
//

import Foundation
import UIKit
import FontAwesome_swift
import EzPopup

class GameController: UIViewController {
    
    var overLord = OverLord()
    var quest: Quest?
    var numberOfHeroes: Int = 0
    var turn: Int = 0
    var playedCards = [Card]()
    
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
    
    @IBOutlet weak var txtGameEvents: UITextView!
    @IBOutlet weak var imgMap: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playCard),
                                               name: NSNotification.Name(rawValue: "playCard"),
                                               object: nil)
        
        overLord.heroes_count = numberOfHeroes
        overLord.init_deck()
        overLord.init_hand()
        
        txtGameEvents.text = ""
        
        lblQuestName.text = quest?.name
        
        let url = Bundle.main.url(forResource: "La_cueva_perdida#1", withExtension: "jpg", subdirectory: "Quests")
        let data = try? Data(contentsOf: url!)
        imgMap.image = UIImage(data: data!)
    
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
        self.turn = self.turn + 1
        txtGameEvents.text = txtGameEvents.text + "\nTURNO: " + "\(self.turn)"
        overLord.overlord_turn()
        let bottom = NSMakeRange(txtGameEvents.text.count - 1, 1)
        txtGameEvents.scrollRangeToVisible(bottom)
    }
    
    @objc func playCard(_ notification: Notification) {
        if let playedCards = notification.userInfo?["cards"] as? [Card]
        {
            self.playedCards = playedCards
            showCards()
        }
    }
    
    func showCards(){
        guard let card = playedCards.first else { return }
        playedCards.remove(at: playedCards.firstIndex(where: {$0.id == card.id})!)
        //showCard(card: card)
        showCard2(card: card)
    }
    
    func showCard2(card: Card){
        if let contentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "showCardVC") as? ShowCardController {
            contentVC.card = card
            let showCardVC = PopupViewController(contentController: contentVC, popupWidth: 400, popupHeight: 550)
            showCardVC.backgroundAlpha = 0.3
            showCardVC.backgroundColor = .black
            showCardVC.canTapOutsideToDismiss = true
            showCardVC.cornerRadius = 10
            showCardVC.shadowEnabled = true
            present(showCardVC, animated: true)
        }
    }
    
    func showCard(card: Card){
        let showAlert = UIAlertController(title: "Carta jugada", message: nil, preferredStyle: .alert)
        let imageView = UIImageView(frame: CGRect(x: 10, y: 50, width: 250, height: 400))
        
        let url = Bundle.main.url(forResource: "#" + "\(card.id)", withExtension: "png", subdirectory: "Cards/es")
        let data = try? Data(contentsOf: url!)
        imageView.image = UIImage(data: data!)
        showAlert.view.addSubview(imageView)
        
        let height:NSLayoutConstraint = NSLayoutConstraint(item: showAlert.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 500)
        showAlert.view.addConstraint(height)
        
        showAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.showCards()
        }))
        showAlert.addAction(UIAlertAction(title: "Can't play", style: .default, handler: { action in
            self.showCards()
        }))
        
        self.present(showAlert, animated: true, completion: nil)
        txtGameEvents.text = txtGameEvents.text + "\nCarta jugada: " + card.name
        let bottom = NSMakeRange(txtGameEvents.text.count - 1, 1)
        txtGameEvents.scrollRangeToVisible(bottom)
    }
}
