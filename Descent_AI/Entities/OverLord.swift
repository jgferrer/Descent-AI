//
//  OverLord.swift
//  Descent AI
//
//  Created by Jose Gabriel Ferrer on 15/11/20.
//

import Foundation

struct OverLord {
    var threat = 0
    var threat_power = 0
    var threat_spawn = 0
    var threat_trap = 0
    
    var heroes_count = 4
    var conquest_tokens = 0
    
    var fullDeck = [Card]()     // Todas las cartas de Overlord
    var deck = [Card]()         // Las cartas que quedan en el mazo
    var hand = [Card]()         // Las cartas que tiene el Overlord en la mano (se usa para colocar en su respectivo hueco)
    var discard = [Card]()      // La pila de descartes
    var table = [Card]()        // Las cartas que hay sobre la mesa:
                                //      Trampas a la espera de ser activadas
                                //      Generaciones a la espera de tener linea de visión
                                //      Poderes activados
    
    // Los huecos en los que se pondrán cartas.
    // El de Poder sólo podrá tener 1 carta, si ya hay una carta deberemos descartar por amenaza la que hayamos robado
    // El de Generación podrá tener hasta 3 cartas, la cuarta sería descartada por amenaza
    // El de Trampa sólo podrá tener 1 carta, si ya hay una carta deberemos descartar por amenaza la que hayamos robado
    var power_pile = [Card]()
    var spawn_pile = [Card]()
    var trap_pile = [Card]()
    
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
    }
    
    mutating func overlord_turn(){
        var playedCards = [Card]()
        
        // 1. Robar amenaza (tantas fichas como héroes en juego) y se ponen en el Contador Amenaza (ContadorAmenaza += NumeroHeroes)
        self.threat += self.heroes_count
        
        // 2. Robar 2 cartas y se colocan en los Espacios correspondientes
        draw_card()
        draw_card()
        // Si la carta Evil Genius (id: 11) está en juego robará una carta adicional
        if (self.table.contains(where: {$0.id == 11})){
            draw_card()
        }
        
        // 3. Repartir Contador Amenaza en los Espacios Carta en partes iguales, las que sobren se quedan en el Contador Amenaza.
        if (self.threat >= 3){
            let threat_tmp = Int(self.threat / 3)
            self.threat_power += threat_tmp
            self.threat_spawn += threat_tmp
            self.threat_trap += threat_tmp
            self.threat -= threat_tmp*3
        }
        
        // 4. Para cada Espacio, si podemos pagar el valor de la carta, la invocamos
        //      --- PODER ---
        if (power_pile.count>0 && power_pile[0].play_cost <= threat_power){
            print ("Juego la carta: ", power_pile[0].name)
            playedCards.append(power_pile[0])
            self.threat_power -= self.power_pile[0].play_cost
            self.table.append(power_pile[0])
            self.power_pile.remove(at: 0)
        }
        
        //      --- GENERACION ---
        spawnLoop:
        for card in spawn_pile {
            if (card.play_cost <= threat_spawn){
                print ("Juego la carta: ", card.name)
                playedCards.append(card)
                self.threat_spawn -= card.play_cost
                self.table.append(card)
                spawn_pile.remove(at: spawn_pile.firstIndex(where: {$0.id == card.id})!)
                break spawnLoop
            }
        }
        
        //      --- TRAMPA ---
        // Si la carta Trapmaster (id: 24) está en juego hay que restar 1 a play_cost
        let trapMaster = (self.table.contains(where: {$0.id == 24}) ? 1 : 0)
        if (trap_pile.count>0 && (trap_pile[0].play_cost - trapMaster) <= threat_trap){
            print ("Juego la carta: ", trap_pile[0].name)
            playedCards.append(trap_pile[0])
            self.threat_trap -= self.trap_pile[0].play_cost
            self.table.append(trap_pile[0])
            self.trap_pile.remove(at: 0)
        }
        
        if (playedCards.count > 0){
            let userInfo = ["cards": playedCards]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "playCard"), object: nil, userInfo: userInfo)
        }
        
    }
    
    mutating func draw_card() {
        // En primer lugar miramos si hay cartas disponibles para robar.
        // Si no las hay debemos usar los descartes y hacer un nuevo mazo
        if (self.deck.count<1){
            self.deck = self.discard
            self.discard.removeAll()
        }
        
        let number = Int.random(in: 0..<self.deck.count)
        self.hand.append(self.deck[number])
        self.deck.remove(at: number)
        
        // Colocar carta en su pila correspondiente o descartar por amenza?
        if (self.hand[0].type==CardType.power.rawValue && power_pile.count == 0)
        {
            self.power_pile.append(self.hand[0])
        }
        else if(self.hand[0].type==CardType.spawn.rawValue && spawn_pile.count <= 2)
        {
            self.spawn_pile.append(self.hand[0])
        }
        else if ((self.hand[0].type==CardType.trap.rawValue ||
                        self.hand[0].type==CardType.trap_chest.rawValue ||
                        self.hand[0].type==CardType.trap_door.rawValue)
                    && trap_pile.count == 0)
        {
            self.trap_pile.append(self.hand[0])
        }
        else
        {
            if (self.heroes_count == 4 || self.hand[0].sell_cost<=2){
	            self.threat += self.hand[0].sell_cost
            }
            else {
	            if (self.heroes_count == 3){
		            self.threat += self.hand[0].sell_cost-1
	            } 
	            else {
		            self.threat += self.hand[0].sell_cost-2
	            }
            }
            self.discard.append(self.hand[0])
        }
        self.hand.remove(at: 0)
    }
}
