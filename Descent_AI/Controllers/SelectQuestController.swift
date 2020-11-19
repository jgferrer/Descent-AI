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
    @IBOutlet weak var questDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overLord.init_deck()
        overLord.init_hand()
        
        if let myURLs = getAllQuests() {
            for url in myURLs{
                let data = try! Data(contentsOf: url)
                let quest = try! JSONDecoder().decode(Quest.self, from: data)
                quests.append(quest)
            }
        }
    }
    
    func getAllQuests()->[URL]? {
        guard let fURL = Bundle.main.urls(forResourcesWithExtension: "json", subdirectory: "Quests") else { return nil }
        return fURL
    }
    
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
        let selectedQuest = quests[indexPath.row]
        questDescription.text = selectedQuest.sceneback + "\n\n" + selectedQuest.missgoal
    }
    
}
