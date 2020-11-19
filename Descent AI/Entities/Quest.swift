//
//  Quest.swift
//  Descent AI
//
//  Created by Jose Gabriel Ferrer on 18/11/20.
//

import Foundation

struct Quest: Decodable, Encodable {
    let quest_id: String;
    let name: String;
    let sceneback: String;
    let missgoal: String;
    let chests: [Chest];
    let lose_text: String;
    let win_text: String;
}
