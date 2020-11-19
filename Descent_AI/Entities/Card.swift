//
//  Card.swift
//  Descent AI
//
//  Created by Jose Gabriel Ferrer on 15/11/20.
//

import Foundation

struct Card: Decodable, Encodable {
    let id: Int;
    let lang: String;
    let play_cost: Int;
    let sell_cost: Int;
    let copies: Int;
    let type: String;
    let name: String;
    let text: String;
}
