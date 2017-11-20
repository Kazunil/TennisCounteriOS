//
//  InterfaceController.swift
//  TennisCounter Extension
//
//  Created by rmounier on 18/09/2017.
//  Copyright © 2017 rmounier. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController {

    @IBOutlet var blueGameScoreLabel: WKInterfaceLabel!
    @IBOutlet var redGameScoreLabel: WKInterfaceLabel!
    @IBOutlet var currentSetScoreLabel: WKInterfaceLabel!
    @IBOutlet var scoreSet1Label: WKInterfaceLabel!
    @IBOutlet var scoreSet2Label: WKInterfaceLabel!
    @IBOutlet var scoreSet3Label: WKInterfaceLabel!
    @IBOutlet var scoreSet4Label: WKInterfaceLabel!
    @IBOutlet var scoreSet5Label: WKInterfaceLabel!
    
    var setsGagnants: Int!
    var lastSet: Int!
    var nbJeuxGagnants: Int!
    
    var setScoreBlue: Int = 0
    var setScoreRed: Int = 0
    var blueScore: Int = 0
    var redScore: Int = 0
    var playerNames: [String] = ["Bleu", "Rouge"]
    
    
    var superTieBreak: Bool = false
    var tieBreak: Bool = false
    var gameComplete: Bool = false
    var currentSet: Int = 0
    var setWon: [Int] = [0,0]
    
    
    var tabSetUIView: [WKInterfaceLabel]!
    
    var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self as? WCSessionDelegate
                session.activate()
            }
        }
    }
    
    override func didAppear() {
        tabSetUIView = [scoreSet1Label, scoreSet2Label, scoreSet3Label, scoreSet4Label, scoreSet5Label]
    }
    
    @IBAction func redButtonClick() {
        addPoint(gagnant: 1, perdant: 0)
    }
    @IBAction func blueButtonClick() {
        addPoint(gagnant: 0, perdant: 1)
    }
    @IBAction func razButtonClick() {
        
        setGames(blueScoreToSet: 0,redScoreToSet: 0)
        setSet(blueScoreToSet: 0, redScoreToSet: 0)
        
        for label in tabSetUIView {
            label.setText("")
        }
        
        setWon = [0,0]
        currentSet = 0
        gameComplete = false
    }
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if let options = context as? OptionsContext {
            setsGagnants = options.setGagnants
            lastSet = options.dernierSet
            nbJeuxGagnants = options.getNbJeuxGagnants()
            
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
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
        
        var scoreJeu = [blueScore, redScore]
        
        scoreJeu[gagnant] += 1
        
        if scoreJeu[gagnant] == 4 {
            if scoreJeu[perdant]<3 {
                finishGame(gagnant: gagnant, perdant: perdant)
                return
            } else if scoreJeu[perdant] == 4 {
                scoreJeu[gagnant] -= 1
                scoreJeu[perdant] -= 1
            }
        } else if scoreJeu[gagnant] > 4 {
            finishGame(gagnant: gagnant, perdant: perdant)
            return
        }
        
        setGames(blueScoreToSet: scoreJeu[0], redScoreToSet: scoreJeu[1])
        
    }
    
    func increaseTieBreak(gagnant: Int, perdant: Int, nbPointsGagnants: Int){
        
        var gameScores: [Int] = [blueScore, redScore]
        
        gameScores[gagnant] += 1
        
        if (gameScores[gagnant]>=nbPointsGagnants && gameScores[gagnant]-gameScores[perdant]>=2){
            finishGame(gagnant: gagnant, perdant: perdant)
            superTieBreak=false;
            tieBreak=false;
        } else {
            setGames(blueScoreToSet: gameScores[0], redScoreToSet: gameScores[1])
        }
        
    }
    
    
    func finishGame(gagnant: Int, perdant: Int){
        
        var setScores: [Int] = [setScoreBlue, setScoreRed]
        
        setScores[gagnant] += 1
        
        setGames(blueScoreToSet: 0, redScoreToSet: 0)
        
        setSet(blueScoreToSet: setScores[0], redScoreToSet: setScores[1])
        
        if(setScores[gagnant] == nbJeuxGagnants){
            if (setScores[perdant]<(nbJeuxGagnants-1)){
                finishSet(gagnant: gagnant, perdant: perdant)
                
            } else if(setScores[perdant] == nbJeuxGagnants){
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
        
        let setFinished = tabSetUIView[currentSet]
        
        setFinished.setText("\(setScoreBlue)\n\(setScoreRed)")
        currentSet += 1;
        
        if (setWon[gagnant] >= setsGagnants){
            gameOver(gagnant: gagnant)
        
        } else {
            setSet(blueScoreToSet: 0, redScoreToSet: 0)
        }
    }
    
    
    func gameOver(gagnant: Int){
        gameComplete = true
        
        currentSetScoreLabel.setText("\(playerNames[gagnant]) a gagné !")
        blueGameScoreLabel.setText(" ")
        redGameScoreLabel.setText(" ")
        
        
    }
    
    func setGames(blueScoreToSet: Int, redScoreToSet: Int){
        
        blueScore = blueScoreToSet
        redScore = redScoreToSet
        
        if tieBreak {
            blueGameScoreLabel.setText(String(blueScore))
            redGameScoreLabel.setText(String(redScore))
        } else {
            blueGameScoreLabel.setText(getStringForGameScore(gameScore: blueScore))
            redGameScoreLabel.setText(getStringForGameScore(gameScore: redScore))
        }
        
        
    }
    
    func setSet(blueScoreToSet: Int, redScoreToSet: Int){
        
        setScoreBlue = blueScoreToSet
        setScoreRed = redScoreToSet
        
        currentSetScoreLabel.setText("\(setScoreBlue) - \(setScoreRed)")
   
    }
    
    func getStringForGameScore (gameScore: Int) -> String{
        
        switch gameScore {
        case 0:
            return "0"
        case 1:
            return "15"
        case 2:
            return "30"
        case 3:
            return "40"
        case 4:
            return "A"
        default:
            return ""
            
        }
    }

    
    
}
