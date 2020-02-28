//
//  main.swift
//  AlternateCommandLineWar
//
//  Created by Gordon, Russell on 2020-02-12.
//  Copyright © 2020 Gordon, Russell. All rights reserved.
//

import Foundation

class BeggarThyNeighbor {
    
    /// Declare all the vaiables
    
    // The deck of cards
    var deck : Deck
    
    // The hands of each player
    var playerHand : Hand
    var computerHand : Hand
    
    // The place where players put card down
    var middle : Hand
    
    // Status of the players
    var offense : Hand
    var defense : Hand
    
    // Statistics of the game
    var chances : Int = 0
    var rounds : Int = 0
    var numberOfShowdown : Int = 0
    var GameIsOver = false
    
    // Initializing all the variables
    init() {
        
        // Initialize the deck
        self.deck = Deck()
        
        // Initialize the each player and the bounty
        playerHand = Hand(description: "player")
        computerHand = Hand(description: "computer")
        middle = Hand(description: "middle bounty")
        
        // Deal out the cards
        if let newCards = self.deck.randomlyDealOut(thisManyCards: 26) {
            self.playerHand.cards = newCards
        }
        
        if let newCards = self.deck.randomlyDealOut(thisManyCards: 26) {
            self.computerHand.cards = newCards
        }
        
        // Set the middle empty
        self.middle.cards = []
        
        // Assign who is offense and defense
        offense = playerHand
        defense = computerHand
        
        // Play the game
        play()
    }
    
    // Check if the card triggers showdown
    func doesTriggerShowDown(card: Card) -> Int {
        // Different number of chances when a different card is shown
        switch middle.cards.last!.rank {
            
            // One chance when a jack is dealt
        case.jack:
            chances = 1
            return(chances)
            
            // Two chances when a queen is dealt
        case.queen:
            chances = 2
            return(chances)
            
            // Three chances when a king is dealt
        case.king:
            chances = 3
            return(chances)
            
            // Four chances when a ace is dealt
        case.ace:
            chances = 4
            return(chances)
            
            // Return a default value when other card is dealt
        default: return(-1)
        }
    }
    
    // When a face card is dealt
    func showDown(from: Hand, against: Hand) {
        
        // Record the number of showdowns
        numberOfShowdown += 1
        
        // Reported who triggered the showndown and how many chances the defense have
        print("\(middle.cards.last!.simpleDescription()) from \(offense.description) activate showndown against \(defense.description)")
        print("\(defense.description) has \(chances) chance(s)")
        print("- - - - - - - - - - - - - - - - - - -")
        
        // Keep dealing cards as long as they still have chances
        while chances != 0 {
            
            if defense.cards.count > 0 {
                
                // Show the card that is dealt by defense
                print("\(defense.description) deals the top card of \(defense.topCard!.simpleDescription())")
                
                // Add it to middle bounty
                middle.cards.append(defense.dealTopCard()!)
                
                chances -= 1
                
                // Check if the card is a face card
                if doesTriggerShowDown(card: middle.cards.last!) != -1 {
                    // Switch on offense if a face card is dealt
                    switchWhoIsOnOffense()
                    showDown(from: offense, against: defense)
                } else if chances == 0 {
                    // Report the winner of the showdown and add the bounty to the winner
                    print("The winner of the showdown is \(offense.description)")
        
                    // Remove all the cards in the bounty and appended to offense
                    offense.cards.append(contentsOf: middle.cards)
                    middle.cards.removeAll()
                }
            } else {
                // Offense wins if the defense has no card
                chances = 0
                annouceWinner(Winner: offense.description)
                GameIsOver = true
            }
        }
    }
    
    
    // Play Beggar Thy Neighbour
    func play() {
        
        // Game is about to start
        print("==========")
        print("Game start")
        print("==========")
        
        // Keep playing when game is not over
        while offense.cards.count > 0 && GameIsOver == false {
            
            // Track the number of rounds
            rounds += 1
            
            // Report on the number of rounds and current status
            print("--------------------------------")
            print("Now starting round \(rounds)...")
            playerHand.status(verbose: false)
            computerHand.status(verbose: false)
            middle.status(verbose: false)
            
            // Card of the offense dealt
            print("\(offense.description) deals the top card of \(offense.topCard!.simpleDescription())")
            middle.cards.append(offense.dealTopCard()!)
            
            // Check if the card is a face card
            if doesTriggerShowDown(card: middle.cards.last!) != -1 {
                showDown(from: offense, against: defense)
            // Check if the offense still have card
            } else if offense.cards.count == 0 {
                annouceWinner(Winner: defense.description)
            } else {
                // Switch on offense
                switchWhoIsOnOffense()
            }
        }
    }
    
    // Annouce the winner
    func annouceWinner(Winner: String) {
        // Report the results and data
        print("=================================")
        print("The winner of the game is \(Winner)")
        print("- - - - - - - - - - - - - - - - -")
        print("Total number of rounds played: \(rounds)")
        print("Total number of showdown triggered: \(numberOfShowdown)")
        GameIsOver = true
    }
    
    // Switch the offense and defense position
    func switchWhoIsOnOffense() {
        if offense === playerHand {
            offense = computerHand
            defense = playerHand
        } else {
            offense = playerHand
            defense = computerHand
        }
    }
}

// Creates an instance of a class -- to play the game
BeggarThyNeighbor()
