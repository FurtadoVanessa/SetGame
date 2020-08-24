//
//  ViewController.swift
//  SetGame
//
//  Created by Vanessa Furtado on 22/07/20.
//  Copyright © 2020 Vanessa Furtado. All rights reserved.
//

import UIKit
import Cartography

class ViewController: UIViewController {
    
    private let rowCount = 4
    
    private lazy var appController : SetController = {
        var game = SetController()
        return game
    }()
    
    var cardList : [UIButton] = []
    var score : UILabel!
    var deck : UILabel!
    var restart : UIButton!
    var threeMorecards : UIButton!
    
    
    func createBasicLabel(ofSize size : CGFloat) -> UILabel {
        let label = UILabel()
        label.font = label.font.withSize(size)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        createBasicLayout()
        initGame()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateScore), name: NSNotification.Name(rawValue: "scoreNotification"), object: nil)
    }
    
    @objc func updateScore() {
        score.text = "Score: \(appController.score)"
    }
    
    func createBasicLayout() {
    
        score = {
            let score = createBasicLabel(ofSize: CGFloat(18))
            return score
        }()
        
        deck = {
            let deck = createBasicLabel(ofSize: CGFloat(16))
            return deck
        }()
        
        restart = {
            let restart = createBasicButton(withLabel: "Restart")
            restart.addTarget(self, action: #selector(restartGame), for: .touchUpInside)
            return restart
        }()
        
        threeMorecards = {
            let threeMorecards = createBasicButton(withLabel: "+3 cards")
            threeMorecards.addTarget(self, action: #selector(addThreeCards), for: .touchUpInside)
            return threeMorecards
        }()
        
        view.addSubview(deck)
        view.addSubview(threeMorecards)
        view.addSubview(score)
        view.addSubview(restart)
    }
    
    @objc func selectCard(sender : UIButton!){
        if appController.cardSelected(index: sender.tag){
            updateView()
        }
        else{
            deselectButton(sender)
        }
    }
    
    @objc func addThreeCards(sender : UIButton!){
        if appController.addThreeMore() {
            createThreeMoreButton()
            updateView()
        }
    }
    
    @objc func restartGame(sender : UIButton!){
        for button in cardList {
            button.removeFromSuperview()
        }
        cardList.removeAll()
        initGame()
    }
    
    func initGame(){
        setupBasicConstrains2(to: score, and: restart)
        setupBasicConstrains(to: deck, and: threeMorecards)
        appController.initGame()
        deck.text = "\(appController.deck.count) cards left"
        score.text = "Score: \(appController.score)"
        createButtons()
    }
    
    func createBasicButton(withLabel label : String) -> UIButton {
        let button = UIButton()
        button.setTitle(label, for: UIControl.State.normal)
        button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.setTitleColor(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }
    
    func createButtons(){
        let cards = appController.tableCards
        for index in 0..<cards.count {
            createCardLayout(withIndex: index, using: cards)
        }
    }
    
    func createThreeMoreButton() {
        let cards = appController.tableCards
        for index in (cards.count-3)..<cards.count {
            createCardLayout(withIndex: index, using: cards)
        }
    }
    
    func createCardLayout(withIndex index : Int, using cards : [Card]) {
        let card = UIButton()
        card.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        card.layer.cornerRadius = 10
        card.translatesAutoresizingMaskIntoConstraints = false
        card.widthAnchor.constraint(equalToConstant: 80).isActive = true
        card.heightAnchor.constraint(equalToConstant: 80).isActive = true
        card.tag = index
        card.setAttributedTitle(createTitle(to: cards[index]), for: UIControl.State.normal)
        card.setTitle(title, for: UIControl.State.normal)
        card.addTarget(self, action: #selector(selectCard), for: .touchUpInside)
        card.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        view.addSubview(card)
        setupConstrains(to: card, with: index)
        cardList.append(card)
    }

    func createTitle(to card : Card) -> NSAttributedString {
        let symbol = card.getSymbol()
        let attributes : [NSAttributedString.Key : Any] = getFilling(of: card)
        return NSAttributedString(string: symbol, attributes: attributes)
    }
    
    func getFilling(of card : Card) -> [NSAttributedString.Key : Any] {
        let color = getColor(of: card)
        switch card.shading {
        case .outline:
            return [NSAttributedString.Key.strokeWidth : 5, NSAttributedString.Key.foregroundColor : color]
        case .stripped:
            return [NSAttributedString.Key.foregroundColor : color.withAlphaComponent(0.30)]
        case .filled:
            return [NSAttributedString.Key.strokeWidth : -3, NSAttributedString.Key.foregroundColor : color]
        }
    }
    
    func getColor(of card : Card) -> UIColor {
        switch card.color {
        case .black:
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        case .blue:
            return #colorLiteral(red: 0.04352179779, green: 0.5116366427, blue: 1, alpha: 1)
        case .orange:
            return #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        }
    }
    
    
    func updateView(){
        deck.text = "\(appController.deck.count) cards left"
        score.text = "Score: \(appController.score)"
        let cards = appController.tableCards
        for index in 0..<cards.count {
            cardList[index].setAttributedTitle(createTitle(to: cards[index]), for: UIControl.State.normal)
            cardList[index].tag = index
            if appController.selectedCards.contains(cards[index]) {
                selectButton(cardList[index])
            }else{
                deselectButton(cardList[index])
            }
            
        }
        if cardList.count > cards.count {
            for _ in cards.count..<cardList.count {
                cardList.removeLast().removeFromSuperview()
            }
        }
    }
    
    func selectButton(_ button : UIButton){
        button.layer.borderWidth = 3.0
        button.layer.borderColor = UIColor.blue.cgColor
        button.layer.cornerRadius = 8.0
    }
    
    func deselectButton(_ button : UIButton){
        button.layer.borderWidth = 0.0
    }
    
    
    
    
    func setupConstrains(to button: UIButton, with index: Int){
        constrain(button) { button in
            var top = (Int((index) / rowCount) * 87)
            top += 18
            button.top == button.superview!.safeAreaLayoutGuide.top + CGFloat(top)
            var leading = (((index) % rowCount) * 87)
            leading += 25
            button.leading == button.superview!.leading + CGFloat(leading)
        }
    }
    
    func setupBasicConstrains(to label: UILabel, and button: UIButton){
        constrain(label, button) { label, button in
            label.centerX  == label.superview!.centerX
            label.top == label.superview!.safeAreaLayoutGuide.top + 550
            button.centerX == label.centerX
            button.top == label.bottom + 10
        }
    }
    
    func setupBasicConstrains2(to label: UILabel, and button: UIButton){
        constrain(label, button) { label, button in
            label.leading  == label.superview!.leading + 22
            label.top == label.superview!.safeAreaLayoutGuide.top + 590
            button.trailing == button.superview!.trailing - 22
            button.top == button.superview!.safeAreaLayoutGuide.top + 580
        }
    }


}

