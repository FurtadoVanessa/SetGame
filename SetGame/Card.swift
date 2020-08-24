//
//  Card.swift
//  SetGame
//
//  Created by Vanessa Furtado on 22/07/20.
//  Copyright © 2020 Vanessa Furtado. All rights reserved.
//

import Foundation


struct Card : Equatable{
    
    var symbol : SymbolEnum
    var color : ColorEnum
    var shading : ShadingEnum
    var numberOfSymbols : Int
    
    
    init(_ number : Int, ofSymbol symbol : SymbolEnum, withColor color : ColorEnum, andShading shade : ShadingEnum ){
        numberOfSymbols = number
        self.symbol = symbol
        self.color = color
        shading = shade
        
    }
    
    func toString() -> String {
        return ("Symbol \(self.symbol) \(self.numberOfSymbols) times with color \(self.color) and shading \(self.shading)")
    }
    
    func getSymbol() -> String {
        var symbol : String
        switch self.symbol {
            case .circle:
                symbol =  "●"
            case .triangle:
                symbol =  "◆"
            case .square:
                symbol =  "■"
        }
        switch self.numberOfSymbols {
            case 2:
                symbol += symbol
            case 3:
                symbol += symbol + symbol
            default:
                symbol += ""
        }
        return symbol
    }


}
