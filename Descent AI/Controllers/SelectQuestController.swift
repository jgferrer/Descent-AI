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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        return quests.count
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestCell", for: indexPath) as! QuestTableViewCell
        cell.labelQuestName.text = quests[indexPath.row].name
        cell.imgQuest.image = UIImage(named: "quest-icon")
        cell.langQuest.image = UIImage(named: quests[indexPath.row].lang)
        return cell
    }
    
}
