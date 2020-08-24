//
//  SetControllerTests.swift
//  SetGameTests
//
//  Created by Douglas castilho on 23/08/20.
//  Copyright © 2020 Vanessa Furtado. All rights reserved.
//
@testable import SetGame
import XCTest

class SetControllerTests: XCTestCase {

    var controller : SetController!
    
    override func setUp() {
        super.setUp()
        controller = SetController()
        
    }
    
    override func tearDown() {
        super.tearDown()
        controller = nil
    }
    
    func test_deck_has_created() throws {
        
        controller.initGame()
        
        let deckSize = controller.deck.count
        
        XCTAssertTrue(deckSize == 69)
        
    }
    
    func test_table_has_created() throws {
        controller.initGame()
        
        let tableSize = controller.tableCards.count
        
        XCTAssertTrue(tableSize == 12)
    }
    
    func test_three_more_cards() throws {
        controller.initGame()
        
       XCTAssertTrue(controller.addThreeMore())
        
    }
    
    func test_can_select_button() throws {
        controller.initGame()
        
        XCTAssertTrue(controller.canSelectButton(index: 0))
    }
    
    
    

}
