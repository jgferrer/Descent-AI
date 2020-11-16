//
//  Game.swift
//  Descent AI
//
//  Created by Jose Gabriel Ferrer on 15/11/20.
//

import Foundation

struct Game: Decodable, Encodable {
    var players: Int;
    var lang: String;
    var quest: Int;
    var room: [Int];
    var questName: Int;
    var countdown: Int;
    var cdtext: String;
}
