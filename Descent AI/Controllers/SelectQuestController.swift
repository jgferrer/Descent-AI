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
        
        if let myURLs = getAllQuests() {
            for url in myURLs{
                let data = try! Data(contentsOf: url)
                let quest = try! JSONDecoder().decode(Quest.self, from: data)
                //print(String(decoding: data, as: UTF8.self))
                print(quest.name)
                for chest in quest.chests{
                    if chest.type == ChestType.Cooper.rawValue {
                        print(chest.type, " - ", chest.num, " ", chest.content)
                    }
                    if chest.type == ChestType.Silver.rawValue {
                        print(chest.type, " - ", chest.num, " ", chest.content)
                    }
                }
            }
        }
    }
    
    func getAllQuests()->[URL]? {
        guard let fURL = Bundle.main.urls(forResourcesWithExtension: "json", subdirectory: "Quests") else { return nil }
        return fURL
    }
}
