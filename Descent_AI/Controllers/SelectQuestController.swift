//
//  SelectQuestController.swift
//  Descent AI
//
//  Created by Jose Gabriel Ferrer on 16/11/20.
//

import UIKit

class SelectQuestController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var overLord = OverLord()
    var quests = [Quest]()
    var all_quests = [Quest]()
    var selected_quest: Quest?
    
    @IBOutlet weak var questDescription: UITextView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var questsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overLord.init_deck()
        overLord.init_hand()
        
        playButton.isEnabled = false;
        
        if let myURLs = getAllQuests() {
            for url in myURLs{
                let data = try! Data(contentsOf: url)
                let quest = try! JSONDecoder().decode(Quest.self, from: data)
                all_quests.append(quest)
                quests.append(quest)
            }
        }
    }
    
    func getAllQuests()->[URL]? {
        guard let fURL = Bundle.main.urls(forResourcesWithExtension: "json", subdirectory: "Quests") else { return nil }
        return fURL
    }
    
    //MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.layer.borderColor = UIColor.gray.cgColor
        tableView.layer.borderWidth = 1.0
        return quests.count
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestCell", for: indexPath) as! QuestTableViewCell
        cell.labelQuestName.text = quests[indexPath.row].name
        cell.labelExtraInfoQuest.text = NSLocalizedString("Duration: ", comment: "Quest Estimated Duration") + quests[indexPath.row].estimated_duration + NSLocalizedString(" - Heroes: ", comment: "Number of Heroes") + quests[indexPath.row].recomended_players
        cell.imgQuest.image = UIImage(named: "quest-icon")
        if (quests[indexPath.row].lang != "") {
            cell.langQuest.image = UIImage(named: quests[indexPath.row].lang)
        }
        else {
            cell.langQuest.image = UIImage(named: "en")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected_quest = quests[indexPath.row]
        questDescription.text = selected_quest!.sceneback + "\n\n" + selected_quest!.missgoal
        playButton.isEnabled = true;
    }
    
    @IBAction func showAllQuests(_ sender: UIButton) {
        quests = all_quests
        questDescription.text = ""
        playButton.isEnabled = false
        self.questsTableView.reloadData()
    }
    
    @IBAction func showESQuests(_ sender: UIButton) {
        quests.removeAll()
        questDescription.text = ""
        playButton.isEnabled = false
        for quest in all_quests {
            if (quest.lang == "es") {
                quests.append(quest)
            }
        }
        self.questsTableView.reloadData()
    }
    
    @IBAction func showENQuests(_ sender: UIButton) {
        quests.removeAll()
        questDescription.text = ""
        playButton.isEnabled = false
        for quest in all_quests {
            if (quest.lang == "en") {
                quests.append(quest)
            }
        }
        self.questsTableView.reloadData()
    }
    
    @IBAction func playButton(_ sender: UIButton) {
        showInputDialog(title: NSLocalizedString("Number of Heroes", comment: "Number of Heroes"),
                        subtitle: NSLocalizedString("Please enter the number of Heroes (1-4)", comment: "Number of Heroes Subtitle"),
                        actionTitle: NSLocalizedString("Play!", comment: "Play Button"),
                        cancelTitle: NSLocalizedString("Cancel", comment: "Cancel Button"),
                        inputPlaceholder: NSLocalizedString("Heroes (1-4)", comment: "Heroes placeholder"),
                        inputKeyboardType: .numberPad, actionHandler:
                            { (input:String?) in
                                if (input != "") {
                                    if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameController") as? GameController {
                                        vc.quest = self.selected_quest
                                        vc.modalPresentationStyle = .fullScreen
                                        self.present(vc, animated: false, completion: nil)
                                    }
                                }
                            })
    }
    
    @objc func textFieldDidChange(textField:UITextField)
     {
        if let intValue = Int(textField.text!) {
            if(intValue<1 || intValue>4){
                textField.text = ""
            }
        } else {
            textField.text = ""
        }
     }
    
    func showInputDialog(title:String? = nil,
                         subtitle:String? = nil,
                         actionTitle:String? = "Play!",
                         cancelTitle:String? = "Cancel",
                         inputPlaceholder:String? = nil,
                         inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {

        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
            textField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))

        self.present(alert, animated: true, completion: nil)
    }
}
