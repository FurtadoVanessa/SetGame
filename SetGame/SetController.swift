//
//  SetController.swift
//  SetGame
//
//  Created by Vanessa Furtado on 22/07/20.
//  Copyright © 2020 Vanessa Furtado. All rights reserved.
//

import Foundation


extension Array where Iterator.Element == Card {
    func getCardValue(toProperty property : String) -> [Int]{
        
        switch property {
        case "shade":
            return self.map( { (card) -> Int in
                return card.shading.rawValue
            } )
        case "color":
            return self.map( { (card) -> Int in
                return card.color.rawValue
            } )
        case "symbol":
            return self.map( { (card) -> Int in
                return card.symbol.rawValue
            } )
        case "count":
            return self.map( { (card) -> Int in
                return card.numberOfSymbols
            } )
        default:
            print("do nothing")
        }
        
        return []
    }
}


class SetController {
    
    
    var deck : [Card] = []
    var symbols : [String] = []
    var selectedCards : [Card] = []
    var tableCards : [Card] = []
    var lastSetWasMatch : Bool = false
    var score = 0

    
    
    func initGame() {
        deck = []
        selectedCards = []
        tableCards = []
        score = 0
        createDeck()
        createTable()
    }
    
    
    private func getSymbols() -> [String] {
        return ["▴","●","■"]
    }
    
    func canSelectButton(index : Int) -> Bool {
        return !selectedCards.contains(tableCards[index])
    }
    
    func deselectButton(index : Int) {
        selectedCards.remove(at: selectedCards.firstIndex(of: tableCards[index])!)
    }
    
    func showSelectedButtons(){
        print("   ----    ")
        for card in selectedCards {
            print(tableCards.firstIndex(of: card)!)
        }
        print("   ----   ")
    }
    
    
    private func createDeck() {
        symbols = getSymbols()
        
        for symbolCount in 1...3 {
            for colorIndex in ColorEnum.allCases {
                for shadingIndex in ShadingEnum.allCases {
                    for symbol in SymbolEnum.allCases {
                        deck.append(Card(symbolCount, ofSymbol: symbol, withColor: colorIndex, andShading: shadingIndex))
                    }
                }
            }
        }
        deck.shuffle()
    }
    
    
    private func createTable() {
        for index in 1...12 {
            tableCards.append(deck.remove(at: index))
        }
    }
    
    func addThreeMore() -> Bool {
        if(tableCards.count < 24) {
            NetworkService.verifyIfHasMatch(in: tableCards) { (result : Result<Int, Error>) in
                switch result {
                case .success(let value) :
                    self.score -= value==1 ? 10 : 0
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue:  "scoreNotification"), object: nil)
                case .failure :
                    print(result)
                }
            }
            addNewCardsOnTable()
            return true
        }
        return false
    }

    
    func cardSelected(index : Int) -> Bool{
        
        if(canSelectButton(index: index)){
            print("yes, button \(index) is selected")
            let card = tableCards[index]
            selectedCards.append(card)
            if(selectedCards.count == 3){
                checkSetMatch()
            }
            return true
        } else {
            print("this button \(index) was selected. Not anymore")
            deselectButton(index: index)
            return false
        }
        
    }
    
    private func checkSetMatch() {
        
        let shade = compare(card: selectedCards.getCardValue(toProperty: "shade"))
        let color = compare(card: selectedCards.getCardValue(toProperty: "color"))
        let symbol = compare(card: selectedCards.getCardValue(toProperty: "symbol"))
        let count = compare(card: selectedCards.getCardValue(toProperty: "count"))
        
        if symbol && count && color && shade {
            print("It's a match")
            score += 6
            let indices = removeCardsFromTable()
            if tableCards.count < 12 {
                addNewCardsOnTable(indices)
            }
        } else {
            score -= 3
            print("Not a match")
        }
        selectedCards.removeAll()
    }
    
    private func removeCardsFromTable() -> [Int] {
        var indices : [Int] = []
        
        for card in selectedCards {
            indices.append(tableCards.firstIndex(of: card)!)
            tableCards.remove(at: tableCards.firstIndex(of: card)!)
        }
        indices.sort()
        
        return indices
    }
    
    
    
    private func compare(card : [Int]) -> Bool {
        print(card)
        return (card[0] == card[1] && card[1] == card[2]) || ((card[0] != card[1])&&(card[0] != card[2])&&(card[1] != card[2]))
    }
    
    private func addNewCardsOnTable(_ indices : [Int]? = nil) {
        if let index = indices {
            for count in index {
                tableCards.insert(deck.removeFirst(), at: count)
            }
        }else {
            for _ in 1...3 {
                tableCards.append(deck.removeFirst())
            }
        }
    }
}
