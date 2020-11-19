//
//  Chest.swift
//  Descent AI
//
//  Created by Jose Gabriel Ferrer on 18/11/20.
//

import Foundation

struct Chest: Decodable, Encodable {
    let type: String;
    let num: Int;
    let content: String;
}
