//
//  ViewController.swift
//  War
//
//  Created by Robert Lent on 3/3/19.
//  Copyright © 2019 Lent Coding. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mainCardView: UIStackView!
    @IBOutlet weak var playerCard: UIImageView!
    @IBOutlet weak var computerCard: UIImageView!
    @IBOutlet weak var warCardView: UIStackView!
    @IBOutlet weak var dealButton: UIButton!
    @IBOutlet weak var playerWarCard: UIImageView!
    @IBOutlet weak var computerWarCard: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var computerNameLabel: UILabel!
    @IBOutlet weak var playerDeckCountLabel: UILabel!
    @IBOutlet weak var computerDeckCountLabel: UILabel!
    @IBOutlet weak var changePlayerNameButton: UIButton!
    @IBOutlet weak var changeComputerNameButton: UIButton!
    
    var playerDeckCount = 0
    var computerDeckCount = 0
    var fullDeck = [[Int]]()
    var playerDeck = [[Int]]()
    var computerDeck = [[Int]]()
    var warDeck = [[Int]]()
    var playerCardRandom = [Int]()
    var computerCardRandom = [Int]()
    var playerWarCardRandom = [Int]()
    var computerWarCardRandom = [Int]()
    var atWar = false
    var playerOne = "Player"
    var playerTwo = "CPU"
    
    let logoImage = UIImage(named: "logo")
    let dealImage = UIImage(named: "dealbutton")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDecks()
    }
    
    func createDecks() {
        // Create full deck of cards
        for i in 0...3 {
            for j in 0...12 {
                fullDeck.append([i, j])
            }
        }
        
        // Create player's deck from random 26 cards in fullDeck
        for _ in 0...25 {
            let card = fullDeck.randomElement()!
            let index = fullDeck.firstIndex(of: card)!
            
            playerDeck.append([fullDeck[index][0], fullDeck[index][1]])
            fullDeck.remove(at: index)
        }
        
        // Create computer's deck from remaining cards in fullDeck
        for _ in 0...25 {
            let card = fullDeck.randomElement()!
            let index = fullDeck.firstIndex(of: card)!
            
            computerDeck.append([fullDeck[index][0], fullDeck[index][1]])
            fullDeck.remove(at: index)
        }
        
        updateDeckCounts()
    }

    func updateDeckCounts() {
        playerDeckCount = playerDeck.count
        computerDeckCount = computerDeck.count
        
        playerDeckCountLabel.text = String(playerDeckCount)
        computerDeckCountLabel.text = String(computerDeckCount)
        
        if playerDeckCount == 0 {
            newGame(win: false)
        }
        
        if computerDeckCount == 0 {
            newGame(win: true)
        }
    }
    
    func updateDecks(whichDeck: String) {
        if whichDeck == "player" && atWar == false {
            playerDeck.append([computerCardRandom[0], computerCardRandom[1]])
            computerDeck.remove(at: computerDeck.firstIndex(of: computerCardRandom)!)
        } else if whichDeck == "player" && atWar == true {
            playerDeck.append([computerWarCardRandom[0], computerWarCardRandom[1]])
            playerDeck.append(contentsOf: warDeck)
            computerDeck.remove(at: computerDeck.firstIndex(of: computerWarCardRandom)!)
            warDeck.removeAll()
        } else if whichDeck == "computer" && atWar == false {
            computerDeck.append([playerCardRandom[0], playerCardRandom[1]])
            playerDeck.remove(at: playerDeck.firstIndex(of: playerCardRandom)!)
        } else if whichDeck == "computer" && atWar == true {
            computerDeck.append([playerWarCardRandom[0], playerWarCardRandom[1]])
            computerDeck.append(contentsOf: warDeck)
            playerDeck.remove(at: playerDeck.firstIndex(of: playerWarCardRandom)!)
            warDeck.removeAll()
        } else if whichDeck == "war" && atWar == false {
            warDeck.append([playerCardRandom[0], playerCardRandom[1]])
            warDeck.append([computerCardRandom[0], computerCardRandom[1]])
            playerDeck.remove(at: playerDeck.firstIndex(of: playerCardRandom)!)
            computerDeck.remove(at: computerDeck.firstIndex(of: computerCardRandom)!)
        } else if whichDeck == "war" && atWar == true {
            warDeck.append([playerWarCardRandom[0], playerWarCardRandom[1]])
            warDeck.append([computerWarCardRandom[0], computerWarCardRandom[1]])
            playerDeck.remove(at: playerDeck.firstIndex(of: playerWarCardRandom)!)
            computerDeck.remove(at: computerDeck.firstIndex(of: computerWarCardRandom)!)
        }
    }
    
    func newGame(win: Bool) {
        let result = (win) ? "won" : "lost"
        let newGameDialog = UIAlertController(title: "You \(result)!", message: "Do you want to start a new game?", preferredStyle: .alert)
        
        newGameDialog.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
            self.fullDeck = [[Int]]()
            self.playerDeck = [[Int]]()
            self.computerDeck = [[Int]]()
            self.warDeck = [[Int]]()
            self.playerCard.image = UIImage(named: "back")
            self.computerCard.image = UIImage(named: "back")
            self.dealButton.setImage(self.dealImage, for: [])
            self.playerDeckCountLabel.textColor = UIColor.white
            self.computerDeckCountLabel.textColor = UIColor.white
            self.changePlayerNameButton.isHidden = false
            self.changeComputerNameButton.isHidden = false
            
            self.createDecks()
        }))
        
        newGameDialog.addAction(UIAlertAction(title: "Quit", style: .cancel) { (action) -> Void in
            exit(0)
        })
        
        self.present(newGameDialog, animated: true, completion: nil)
    }
    
    @IBAction func changePlayerName(_ sender: Any) {
        let alert = UIAlertController(title: "Player One's Name", message: "Enter new name", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.text = self.playerOne
        }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            let name = alert.textFields![0].text?.trimmingCharacters(in: .whitespaces) ?? "Player"
            self.playerOne = (name != "") ? name : self.playerOne
            self.playerNameLabel.text = "\(self.playerOne)'s Cards"
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func changeComputerName(_ sender: Any) {
        let alert = UIAlertController(title: "Player Two's Name", message: "Enter new name", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = self.playerTwo
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            let name = alert.textFields![0].text?.trimmingCharacters(in: .whitespaces) ?? "CPU"
            self.playerTwo = (name != "") ? name : self.playerTwo
            self.computerNameLabel.text = "\(self.playerTwo)'s Cards"
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func deal(_ sender: Any) {
        if !changePlayerNameButton.isHidden {
            changePlayerNameButton.isHidden = true
            changeComputerNameButton.isHidden = true
        }
        
        warCardView.isHidden = (atWar) ? false : true
        
        if warCardView.isHidden {
            playerCardRandom = playerDeck.randomElement()!
            computerCardRandom = computerDeck.randomElement()!
            
            playerCard.image = UIImage(named: "card\(playerCardRandom[0])-\(playerCardRandom[1])")
            computerCard.image = UIImage(named: "card\(computerCardRandom[0])-\(computerCardRandom[1])")
            
            if playerCardRandom[1] > computerCardRandom[1] {
                updateDecks(whichDeck: "player")
                playerDeckCountLabel.textColor = UIColor.green
                computerDeckCountLabel.textColor = UIColor.red
                updateDeckCounts()
            } else if computerCardRandom[1] > playerCardRandom[1] {
                updateDecks(whichDeck: "computer")
                computerDeckCountLabel.textColor = UIColor.green
                playerDeckCountLabel.textColor = UIColor.red
                updateDeckCounts()
            } else {
                if playerDeckCount == 1 {
                    updateDecks(whichDeck: "computer")
                    updateDeckCounts()
                } else if computerDeckCount == 1 {
                    updateDecks(whichDeck: "player")
                    updateDeckCounts()
                } else {
                    updateDecks(whichDeck: "war")
                    playerWarCard.image = UIImage(named: "back")
                    computerWarCard.image = UIImage(named: "back")
                    warCardView.isHidden = false
                    atWar = true
                    dealButton.setImage(logoImage, for: [])
                    playerDeckCountLabel.textColor = UIColor.white
                    computerDeckCountLabel.textColor = UIColor.white
                }
            }
        } else {
            playerWarCardRandom = playerDeck.randomElement()!
            computerWarCardRandom = computerDeck.randomElement()!
            
            playerWarCard.image = UIImage(named: "card\(playerWarCardRandom[0])-\(playerWarCardRandom[1])")
            computerWarCard.image = UIImage(named: "card\(computerWarCardRandom[0])-\(computerWarCardRandom[1])")
            
            if playerWarCardRandom[1] > computerWarCardRandom[1] {
                updateDecks(whichDeck: "player")
                playerDeckCountLabel.textColor = UIColor.green
                computerDeckCountLabel.textColor = UIColor.red
                dealButton.setImage(dealImage, for: [])
                atWar = false
                updateDeckCounts()
            } else if computerWarCardRandom[1] > playerWarCardRandom[1] {
                updateDecks(whichDeck: "computer")
                computerDeckCountLabel.textColor = UIColor.green
                playerDeckCountLabel.textColor = UIColor.red
                dealButton.setImage(dealImage, for: [])
                atWar = false
                updateDeckCounts()
            } else {
                if playerDeckCount == 1 {
                    updateDecks(whichDeck: "computer")
                    updateDeckCounts()
                } else if computerDeckCount == 1 {
                    updateDecks(whichDeck: "player")
                    updateDeckCounts()
                } else {
                    playerCard.image = UIImage(named: "card\(playerWarCardRandom[0])-\(playerWarCardRandom[1])")
                    computerCard.image = UIImage(named: "card\(computerWarCardRandom[0])-\(computerWarCardRandom[1])")
                    playerWarCard.image = UIImage(named: "back")
                    computerWarCard.image = UIImage(named: "back")
                    updateDecks(whichDeck: "war")
                    playerDeckCountLabel.textColor = UIColor.white
                    computerDeckCountLabel.textColor = UIColor.white
                }
            }
        }
    }
}
