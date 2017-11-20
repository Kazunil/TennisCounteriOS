//
//  MainViewController.swift
//  TennisCounteriOS
//
//  Created by rmounier on 01/09/2017.
//  Copyright © 2017 rmounier. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, lastSetDelegate {
    
    @IBOutlet weak var troisJeuxGagnants: UISwitch?
    @IBOutlet weak var lastSet: UILabel?
    @IBOutlet weak var setsGagnants: UISegmentedControl?
    @IBOutlet weak var player1: UITextField?
    @IBOutlet weak var player2: UITextField?
    
    
    enum choices: String{
        case deuxJeux = "Victoire à 2 jeux d'écart"
        case tieBreak = "Tie-Break à 6:6"
        case superTieBreak = "Super Tie-Break à 6:6"
    }
    
    static let choicesArray = [choices.deuxJeux, choices.tieBreak, choices.superTieBreak]
    
    var currentChoiceIndex : Int = 0
    
    
    @IBAction func ok(sender: UIButton){
        let vc: CounterViewController = UIStoryboard(name: "Counter", bundle: nil).instantiateInitialViewController() as! CounterViewController
        
        if(player1!.text != nil && player1!.text != ""){
            vc.playerNames[0] = player1!.text!
        }
        
        if(player2!.text != nil && player2!.text != ""){
            vc.playerNames[1] = player2!.text!
        }
        
        vc.setsGagnants = (setsGagnants?.selectedSegmentIndex)! + 1
        
        if troisJeuxGagnants!.isOn {
            vc.nbJeuxGagnants = 3
        } else {
            vc.nbJeuxGagnants = 6
        }
        
        vc.lastSet = currentChoiceIndex
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        troisJeuxGagnants?.setOn(false, animated: false)
        
        lastSet?.text = MainViewController.choicesArray[0].rawValue
        currentChoiceIndex = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination=segue.destination as? LastSetPickerViewController{
            destination.delegate=self
        }
    }
    
    func onReturnChoice(indexChoice: Int) {
        lastSet?.text = MainViewController.choicesArray[indexChoice].rawValue
        currentChoiceIndex = indexChoice
    }
    
}
