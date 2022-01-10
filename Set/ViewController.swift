//
//  ViewController.swift
//  Set
//
//  Created by Sebastian Pfeufer on 28/02/2021.
//

import UIKit

class ViewController: UIViewController {

// MARK: - Declaration of Elements in User Interface
    enum Symbol: String, CaseIterable {
        case circle = "●", triangle = "▲", square = "■", twoCircle = "●●", twoTriangle = "▲▲", twoSquare = "■■", threeCircle = "●●●", threeTriangle = "▲▲▲", threeSquare = "■■■"
    }
    enum Color: String, CaseIterable {
        case blue = "blue", red =  "red", green = "green"
    }
    enum Shade: String, CaseIterable {
        case filled = "filled", striped = "striped", outline = "outlined"
    }
    lazy var choiceCombinations = {() -> [(String, Int, String, String)] in
        var allChoices = [(String, Int, String, String)]()
        for symbol in Symbol.allCases {
            let number = symbol.rawValue.count
            for color in Color.allCases {
                for shading in Shade.allCases {
                    allChoices.append((symbol.rawValue, number, color.rawValue, shading.rawValue))
                }
            }
        }
        return allChoices
    }()

//MARK: - Set-up of outlets and supporting variables
    @IBOutlet var setButtons: [UIButton]!
    @IBOutlet weak var setsCount: UILabel!
    @IBOutlet weak var scoreCount: UILabel!
    @IBOutlet weak var dealButton: UIButton!
    
    lazy var setGame = SetGame()
    var visibleCards = 12
    var endLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 100))

//MARK: - Loading visible cards after starting app
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setGame.newGame(initialNumberOfCards: visibleCards)
        updateViewFromModel()
    }
    
//MARK: - Implementation of actions caused by user
    // actions caused when player clicks on a button
    @IBAction func setButtonPressed(_ sender: UIButton) {
        if sender.currentAttributedTitle != NSAttributedString(string: "") {
            if let selectedCardIndex = setButtons.firstIndex(of: sender) {
                setGame.addToSelectedCards(selectedCardIndex: selectedCardIndex)
            }
        }        
        updateViewFromModel()
    }
    
    // actions caused when player clicks on dealButton
    @IBAction func dealPressed(_ sender: UIButton) {
        if setGame.playingCards.count < setButtons.count {
            setGame.addPlayingCards()
            updateViewFromModel()
        }
        else {
            setGame.replacePlayingCards()
            updateViewFromModel()
        }
    }
    
    // actions caused when player clicks on New Game
    @IBAction func newGamePressed(_ sender: UIButton) {
        visibleCards = 12
        setGame.newGame(initialNumberOfCards: visibleCards)
        updateViewFromModel()
        view.backgroundColor = UIColor.white
        endLabel.removeFromSuperview()
        dealButton.isHidden = false
    }

//MARK: - Supporting functions
    func updateViewFromModel() {
        // clearing all buttons before they are set up with their respective symbol(s), color and shading
        for button in setButtons {
            button.isEnabled = true
            button.setAttributedTitle(NSAttributedString(string: ""), for: .normal)
            button.layer.borderWidth = 0.0
            button.layer.borderColor = .none
            button.isHidden = true
        }
        
        // setting up the buttons' respective symbol(s), color and shading
        for card in setGame.playingCards {
            let identifierAsIndex = card.identifier-1
            let buttonTitle = choiceCombinations[identifierAsIndex].0
            let symbolColor = choiceCombinations[identifierAsIndex].2
            let symbolShade = choiceCombinations[identifierAsIndex].3
            var attributes: [NSAttributedString.Key: Any]?
            if symbolColor == "blue" {
                if symbolShade == "filled" {
                    attributes = [.foregroundColor: UIColor.blue, .strokeColor: UIColor.blue]
                }
                else if symbolShade == "striped" {
                    attributes = [.foregroundColor: UIColor.blue.withAlphaComponent(0.25), .strokeWidth: -10.0, .strokeColor: UIColor.blue]
                }
                else if symbolShade == "outlined" {
                    attributes = [.foregroundColor: UIColor.white, .strokeWidth: -10.0, .strokeColor: UIColor.blue]
                }
            }
            else if symbolColor == "red" {
                if symbolShade == "filled" {
                    attributes = [.foregroundColor: UIColor.red, .strokeColor: UIColor.red]
                }
                else if symbolShade == "striped" {
                    attributes = [.foregroundColor: UIColor.red.withAlphaComponent(0.25), .strokeWidth: -10.0, .strokeColor: UIColor.red]
                }
                else if symbolShade == "outlined" {
                    attributes = [.foregroundColor: UIColor.white, .strokeWidth: -10.0, .strokeColor: UIColor.red]
                }
            }
            else if symbolColor == "green" {
                if symbolShade == "filled" {
                    attributes = [.foregroundColor: UIColor.green, .strokeColor: UIColor.green]
                }
                else if symbolShade == "striped" {
                    attributes = [.foregroundColor: UIColor.green.withAlphaComponent(0.25), .strokeWidth: -10.0, .strokeColor: UIColor.green]
                }
                else if symbolShade == "outlined" {
                    attributes = [.foregroundColor: UIColor.white, .strokeWidth: -10.0, .strokeColor: UIColor.green]
                }
            }
            
            // making required buttons visible and putting symbols on buttons
            if let buttonNumber = setGame.playingCards.firstIndex(of: card) {
                let attributedQuote = NSAttributedString(string: buttonTitle, attributes: attributes)
                setButtons[buttonNumber].setAttributedTitle(attributedQuote, for: .normal)
                setButtons[buttonNumber].isHidden = false
                setButtons[buttonNumber].backgroundColor = UIColor.systemGray
                
                // highlighting selected cards
                if setGame.selectedCards.contains(setGame.playingCards[buttonNumber]) {
                    setButtons[buttonNumber].layer.borderWidth = 3.0
                    setButtons[buttonNumber].layer.borderColor = UIColor.yellow.cgColor
                    
                    // highlighting matched cards
                    if setGame.matchedCards.contains(setGame.playingCards[buttonNumber]) {
                        setButtons[buttonNumber].layer.borderWidth = 3.0
                        setButtons[buttonNumber].layer.borderColor = UIColor.green.cgColor
                    }
                }
                else {
                    // buttons that are neither selected nor matched are not highlighted
                    setButtons[buttonNumber].layer.borderWidth = 0.0
                    setButtons[buttonNumber].layer.borderColor = .none
                }
                // checking wether any card should be removed
                if setGame.cardsToBeRemoved.contains(card) {
                    setButtons[buttonNumber].isEnabled = false
                    setButtons[buttonNumber].setAttributedTitle(NSAttributedString(string: ""), for: .normal)
                    setButtons[buttonNumber].backgroundColor = view.backgroundColor
                    setButtons[buttonNumber].layer.borderWidth = 0.0
                    setButtons[buttonNumber].layer.borderColor = .none
                }
            }
            // updating score label and sets label
            scoreCount.text = "Score: \(setGame.score)"
            setsCount.text = "Sets: \(setGame.numberOfSets)"
            
            // If the user manages to find every possible set, the user interface will notify him/her accordingly
            if setGame.numberOfSets == (setGame.cardDeck.count / 3) {
                for button in setButtons {
                    button.isHidden = true
                }
                setsCount.isHidden = true
                scoreCount.isHidden = true
                dealButton.isHidden = true
                view.backgroundColor = UIColor.green
                endLabel.center = CGPoint(x: view.center.x, y: view.center.y)
                endLabel.textAlignment = .center
                endLabel.textColor = UIColor.black
                endLabel.numberOfLines = .max
                endLabel.text = "Congratulations! You've found all \(setGame.numberOfSets) sets! Your score is \(setGame.score)!"
                view.addSubview(endLabel)
            }
        }
    }
}
