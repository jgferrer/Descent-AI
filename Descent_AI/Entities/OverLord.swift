//
//  OverLord.swift
//  Descent AI
//
//  Created by Jose Gabriel Ferrer on 15/11/20.
//

import Foundation

struct OverLord {
    var threat = 0
    var conquest_tokens = 0
    
    var fullDeck = [Card]()
    var deck = [Card]()
    var hand = [Card]()
    var discard = [Card]()
    var table = [Card]()
    
    // Constantes
    // Estas variables representan el valor de amenaza que debe tener
    // el señor supremo  para poder jugar una carta del tipo definido
    // Cuanto más bajo, antes usará la carta
    let TRAP_DOOR_CHANCE = 25
    let TRAP_CHEST_CHANCE = 25
    let TRAP_SPACE_CHANCE = 25
    let TRAP_CHANCE = 25
    let EVENT_CHANCE = 25
    let SPAWN_CHANCE = 25
    let POWER_CHANCE = 8
    
    mutating func init_deck(){
        // Inicializar el mazo de cartas del Señor Supremo
        let url = Bundle.main.url(forResource: "cards", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let cards = try! JSONDecoder().decode([Card].self, from: data)
        for card in cards {
            if (card.lang=="es"){
                for _ in 1...card.copies {
                    self.fullDeck.append(card)
                    self.deck.append(card)
                }
            }
        }
    }
    
    mutating func init_hand(){
        self.threat = 0
        draw_card()
        draw_card()
        draw_card()
    }
    
    mutating func draw_card() {
        let number = Int.random(in: 0..<self.deck.count)
        self.hand.append(self.deck[number])
        self.deck.remove(at: number)
        
        // Si hay más de 8 cartas en la mano hay que descartar...
        while(self.hand.count > 8){
            var low = 0, med = 0, high = 0
            for i in 0..<self.hand.count {
                if(self.hand[i].play_cost<5){
                    low+=1
                }
                else if(self.hand[i].play_cost<15){
                    med+=1;
                }
                else{
                    high+=1
                }
            }
            if(high > 1){
                discardCard(count: high, low: 15, high: 30);
            }
            else if(med > 3){
                discardCard(count: med, low: 5, high: 14);
            }
            else if(low > 4){
                discardCard(count: low, low: 1, high: 4);
            }
        }
    }
    
    // Descartar una carta aleatoria que esté dentro del rango de coste de invocación pasado
    mutating func discardCard(count: Int, low: Int, high: Int){
        var temp = Int.random(in: 1...count)
        discardLoop:
        for var i in 0..<self.hand.count-1{
            if(low <= self.hand[i].play_cost && self.hand[i].play_cost <= high){
                if(temp == 1){
                    self.discard.append(self.hand[i])
                    self.threat += self.hand[i].sell_cost
                    self.hand.remove(at: i)
                    break discardLoop
                }
                temp-=1
            }
            i+=1
        }
    }
    
}
