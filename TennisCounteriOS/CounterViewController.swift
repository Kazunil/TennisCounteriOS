//
//  CounterViewController.swift
//  TennisCounteriOS
//
//  Created by rmounier on 12/09/2017.
//  Copyright © 2017 rmounier. All rights reserved.
//

import UIKit

class CounterViewController: UIViewController {
    
    var playerNames: [String] = ["Bleu", "Rouge"]
    var setsGagnants: Int!
    var lastSet: Int!
    var nbJeuxGagnants: Int!
    
    
    var superTieBreak: Bool = false
    var tieBreak: Bool = false
    var gameComplete: Bool = false
    var currentSet: Int = 0
    var setWon: [Int] = [0,0]
    
    
    
    @IBOutlet weak var gameOver: UILabel!
    @IBOutlet weak var player1Name: UILabel!
    @IBOutlet weak var player2Name: UILabel!
    
    @IBOutlet weak var currentGameScore: UILabel!
    @IBOutlet weak var currentSetScore: UILabel!
    @IBOutlet weak var scoreSet1: UILabel!
    @IBOutlet weak var scoreSet2: UILabel!
    @IBOutlet weak var scoreSet3: UILabel!
    @IBOutlet weak var scoreSet4: UILabel!
    @IBOutlet weak var scoreSet5: UILabel!
    
    var tabSetUIView: [UILabel]!
    @IBAction func redBClick() {
        addPoint(gagnant: 1, perdant: 0)
    }
    
    
    @IBAction func blueBClick() {
        addPoint(gagnant: 0, perdant: 1)
    }
    
    @IBAction func RaZ() {
        currentGameScore.isHidden = false
        currentGameScore.text = "0 - 0"
        currentSetScore.isHidden = false
        currentSetScore.text = "0 - 0"
        
        for label in tabSetUIView {
            label.isHidden = true
        }
        
        gameOver.isHidden = true
        
        setWon = [0,0]
        currentSet = 0
        gameComplete = false
    }
    
    override func viewDidLoad() {
        player1Name.text = playerNames[0]
        player2Name.text = playerNames[1]
        
        tabSetUIView = [scoreSet1, scoreSet2, scoreSet3, scoreSet4, scoreSet5]

        
    }
    
    func addPoint(gagnant: Int, perdant: Int){
        if (!gameComplete){
            if (tieBreak){
                increaseTieBreak(gagnant: gagnant, perdant: perdant, nbPointsGagnants: 7)
            } else if (superTieBreak){
                increaseTieBreak(gagnant: gagnant, perdant: perdant, nbPointsGagnants: 10)
            } else {
                increaseGame(gagnant: gagnant, perdant: perdant)
            }
        }
    }
    
    func increaseGame(gagnant: Int, perdant: Int){
        
        var scoreJeu = currentGameScore.text!.components(separatedBy: " - ")
        
        switch scoreJeu[gagnant].characters.first! {
            case "0":
                scoreJeu[gagnant]="15"
            case "1":
                scoreJeu[gagnant]="30"
            case "3":
                scoreJeu[gagnant]="40"
            case "A":
                finishGame(gagnant: gagnant, perdant: perdant)
                return
            case "4":
                if scoreJeu[perdant] == "40" {
                    scoreJeu[gagnant] = "A"
                } else if scoreJeu[perdant] == "A" {
                    scoreJeu[perdant] = "40"
                } else {
                    finishGame(gagnant: gagnant, perdant: perdant);
                    return
                }
            default: break
        }
        
        currentGameScore.text = "\(scoreJeu[0]) - \(scoreJeu[1])"
    }
    
    func increaseTieBreak(gagnant: Int, perdant: Int, nbPointsGagnants: Int){
        let scoresString = currentGameScore.text!.components(separatedBy: " - ")
        
        var gameScores: [Int] = [Int(scoresString[0])!,Int(scoresString[1])!]
        
        gameScores[gagnant] += 1
        
        if (gameScores[gagnant]>=nbPointsGagnants && gameScores[gagnant]-gameScores[perdant]>=2){
            finishGame(gagnant: gagnant, perdant: perdant)
            superTieBreak=false;
            tieBreak=false;
        } else {
            currentGameScore.text = "\(gameScores[0]) - \(gameScores[1])"
        }
    
    }

    
    func finishGame(gagnant: Int, perdant: Int){
        let scoresString = currentSetScore.text!.components(separatedBy: " - ")
        
        var setScores: [Int] = [Int(scoresString[0])!,Int(scoresString[1])!]
        
        setScores[gagnant] += 1
        
        currentGameScore.text = "0 - 0"
        currentSetScore.text = "\(setScores[0]) - \(setScores[1])"
        
        
        if(setScores[gagnant] == nbJeuxGagnants){
            if (setScores[perdant]<(nbJeuxGagnants-1)){
                finishSet(gagnant: gagnant, perdant: perdant)
            }
            
            else if(setScores[perdant] == nbJeuxGagnants){
                if (currentSet == (setsGagnants-1)*2){
                    switch(lastSet){
                    case 2 : //super tie-break
                        superTieBreak=true;
                        return
                    case 0 : //deux jeux d'écart
                        return
                    default:
                        break
                    }
                }
                tieBreak=true
            }
            
        }
            
        else if(setScores[gagnant] > nbJeuxGagnants){
            if (tieBreak || superTieBreak){
                tieBreak=false
                superTieBreak=false
                finishSet(gagnant: gagnant, perdant: perdant)
            }
            else if(setScores[gagnant]-setScores[perdant]>=2){
             finishSet(gagnant: gagnant, perdant: perdant)
            }
        }

        
    }
    
    
    func finishSet(gagnant: Int, perdant: Int){
        setWon[gagnant] += 1
        
        let setFinished: UILabel = tabSetUIView[currentSet]
        
        setFinished.text=currentSetScore.text!.replacingOccurrences(of: " - ", with: "\n")
        setFinished.isHidden = false
        currentSet += 1;
        
        if (setWon[gagnant] >= setsGagnants){
            gameOver(gagnant: gagnant)
        }
        
        currentSetScore.text = "0 - 0"
        
    }
    
    
    func gameOver(gagnant: Int){
        gameComplete = true
        
        currentSetScore.isHidden = true
        currentGameScore.isHidden = true
        
        gameOver.text = "\(playerNames[gagnant]) a gagné !"
        gameOver.isHidden = false
        
    }

}
