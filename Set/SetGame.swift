//
//  SetGame.swift
//  Set
//
//  Created by Sebastian Pfeufer on 28/02/2021.
//

import Foundation

struct SetGame {

// MARK: - Declaration of Variables
    private(set) var cardDeck = [Card]() // all cards in the deck
    private(set) var playingCards = [Card]() // cards that are currently played with
    private(set) var selectedCards = [Card]() // cards selected by the user and to be checked if they are a match
    private(set) var matchedCards = [Card]() // cards that are matched
    private(set) var cardsToBeRemoved = [Card]() // cards that will be removed from playingCards but not replaced by cards from cardDeck
    private(set) var score = 0
    private(set) var numberOfSets = 0
    private var nextPlayingCardIndex = 0 // tracks which card is next to be added to playingCards
    
// MARK: - Functions caused by User Interaction
    mutating func newGame(initialNumberOfCards: Int) {
        cardDeck.shuffle()
        nextPlayingCardIndex = 0
        setupPlayingCards(cardsInPlay: initialNumberOfCards)
        selectedCards = []
        matchedCards = []
        cardsToBeRemoved = []
        score = 0
        numberOfSets = 0
    }
    
    // action caused when a card is selected
    mutating func addToSelectedCards(selectedCardIndex: Int) {
        // if there are already 3 cards selected by the user and they are a match, replace or remove them
        proceedWithMatchedCards()
        
        // the selected card will be de-selected, if it is already selected
        if selectedCards.contains(playingCards[selectedCardIndex]) {
            if let index = selectedCards.firstIndex(of: playingCards[selectedCardIndex]) {
                selectedCards.remove(at: index)
            }
        }
        // the selected card will be added to all selected cards - if 3 cards selected, we check if they are a match
        else {
            selectedCards.append(playingCards[selectedCardIndex])
            if selectedCards.count == 3 {
                checkSelectedCards()
            }
        }
    }
    
    // action caused when more cards are requested (case 1: additional cards can be added to the game)
    mutating func addPlayingCards() {
        // the selected matched cards will be replaced or removed - if there are no selected matched cards, new cards will be added
        if selectedCards.count == 3 && matchedCards.contains(selectedCards[0]) && matchedCards.contains(selectedCards[1]) && matchedCards.contains(selectedCards[2]) {
            proceedWithMatchedCards()
        }
        // 3 new cards will be added to the game
        else {
            for _ in 1...3 {
                if nextPlayingCardIndex < 81 {
                    playingCards.append(cardDeck[nextPlayingCardIndex])
                    nextPlayingCardIndex += 1
                }
            }
        }
    }
    
    // action caused when more cards are requested (case 2: no additional Cards can be added to the game)
    mutating func replacePlayingCards() {
        // the selected matched cards will be replaced or removed
        proceedWithMatchedCards()
    }
    
// MARK: - Supporting functions
    // sets up the game in its initial version by copying cards from cardDeck into playingCards
    private mutating func setupPlayingCards(cardsInPlay: Int) {
        playingCards = []
        for cardNumber in 0...cardsInPlay-1 {
            playingCards.append(cardDeck[cardNumber])
            nextPlayingCardIndex += 1
        }
    }
    
    // manages how to deal with matched cards
    private mutating func proceedWithMatchedCards() {
        if selectedCards.count == 3 {
            // if all cards from cardDeck have been played or are currently played and are a match, the selected 3 cards will be removed from the game
            if nextPlayingCardIndex > 80 && matchedCards.contains(selectedCards[0]) && matchedCards.contains(selectedCards[1]) && matchedCards.contains(selectedCards[2]) {
                removeMatchedCards(card1: selectedCards[0], card2: selectedCards[1], card3: selectedCards[2])
            }
            // if not all cards from cardDeck have been played or are currently played and are a match, the selected 3 cards will be replaced by new cards
            else {
                if matchedCards.contains(selectedCards[0]) && matchedCards.contains(selectedCards[1]) && matchedCards.contains(selectedCards[2]) {
                    insertNewCardsForMatchedCards(card1: selectedCards[0], card2: selectedCards[1], card3: selectedCards[2])
                }
            }
            selectedCards = []
        }
    }
    
    // checks for a match whenever 3 cards are selected
    private mutating func checkSelectedCards() {
        let card1 = selectedCards[0]
        let card2 = selectedCards[1]
        let card3 = selectedCards[2]
        
        // examining every selected card's feature variants according to the set rules and manages the credit given to the player
        if ((card1.feature1 != card2.feature1) && (card1.feature1 != card3.feature1) && (card2.feature1 != card3.feature1)) || ((card1.feature1 == card2.feature1) && (card1.feature1 == card3.feature1) && (card2.feature1 == card3.feature1)) {
            if ((card1.feature2 != card2.feature2) && (card1.feature2 != card3.feature2) && (card2.feature2 != card3.feature2)) || ((card1.feature2 == card2.feature2) && (card1.feature2 == card3.feature2) && (card2.feature2 == card3.feature2)) {
                if ((card1.feature3 != card2.feature3) && (card1.feature3 != card3.feature3) && (card2.feature3 != card3.feature3)) || ((card1.feature3 == card2.feature3) && (card1.feature3 == card3.feature3) && (card2.feature3 == card3.feature3)) {
                    if (card1.feature4 != card2.feature4) && (card1.feature4 != card3.feature4) && (card2.feature4 != card3.feature4) || ((card1.feature4 == card2.feature4) && (card1.feature4 == card3.feature4) && (card2.feature4 == card3.feature4)) {
                        matchedCards.append(card1)
                        matchedCards.append(card2)
                        matchedCards.append(card3)
                        score += 3
                        numberOfSets += 1
                    }
                    else {
                        score -= 1
                    }
                }
                else {
                    score -= 1
                }
            }
            else {
                score -= 1
            }
        }
        else {
            score -= 1
        }
    }
    
    // whenever cards are matched, they are either replaced or removed (case 1: matched cards are replaced with cards from cardDeck)
    private mutating func insertNewCardsForMatchedCards(card1: Card, card2: Card, card3: Card) {
        if nextPlayingCardIndex < 81 {
            if let index1 = playingCards.firstIndex(of: card1) {
                playingCards[index1] = cardDeck[nextPlayingCardIndex]
                nextPlayingCardIndex += 1
            }
            if let index2 = playingCards.firstIndex(of: card2) {
                playingCards[index2] = cardDeck[nextPlayingCardIndex]
                nextPlayingCardIndex += 1
            }
            if let index3 = playingCards.firstIndex(of: card3) {
                playingCards[index3] = cardDeck[nextPlayingCardIndex]
                nextPlayingCardIndex += 1
            }
        }
    }
    
    // whenever cards are matched, they are either replaced or removed (case 2: matched cards will be removed when there are no cards to replace them with)
    private mutating func removeMatchedCards(card1: Card, card2: Card, card3: Card) {
            cardsToBeRemoved.append(card1)
            cardsToBeRemoved.append(card2)
            cardsToBeRemoved.append(card3)
    }

// MARK: - Initialisation of SetGame
    init() {
        for f1 in 1...3 {
            for f2 in 1...3 {
                for f3 in 1...3 {
                    for f4 in 1...3 {
                        let card = Card(feature1: Card.Variant(rawValue: f1)!, feature2: Card.Variant(rawValue: f2)!, feature3: Card.Variant(rawValue: f3)!, feature4: Card.Variant(rawValue: f4)!)
                        cardDeck.append(card)
                    }
                }
            }
        }
    }
}
