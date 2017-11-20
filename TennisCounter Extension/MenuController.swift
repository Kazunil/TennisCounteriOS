//
//  MenuController.swift
//  TennisCounteriOS
//
//  Created by rmounier on 26/10/2017.
//  Copyright © 2017 rmounier. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


internal class MenuController : WKInterfaceController {
    
    @IBOutlet var setsGagnantsPicker: WKInterfacePicker!
    @IBOutlet var lastSetPicker: WKInterfacePicker!
    
    var setGagnants: Int = 1
    var dernierSet: Int = 0
    var setEn3Jeux: Bool = false
    
    @IBAction func didChangeSetsEn3Jeux(_ value: Bool) {
        setEn3Jeux = value
    }
    
    @IBAction func didChangeSetsGagnants(_ value: Int) {
        setGagnants = value + 1
    }
    
    @IBAction func didChangeLastSet(_ value: Int) {
        dernierSet = value
    }
    
    @IBAction func goButtonClick() {
        
        let context = OptionsContext(setGagnants: setGagnants, dernierSet: dernierSet, setEn3Jeux: setEn3Jeux)
        
        pushController(withName: "Page2", context: context)
    }
    
    var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self as? WCSessionDelegate
                session.activate()
            }
        }
    }
    
    override func didAppear() {
        
        var setsGagnantsItems = [WKPickerItem]()
        
        for i in 0...2{
            let item = WKPickerItem()
            item.title = String(i+1)
            
            setsGagnantsItems.insert(item, at: i)
        }
        
        setsGagnantsPicker.setItems(setsGagnantsItems)
        
        
        
        var lastSetPickerItems = [WKPickerItem]()
        let tabLastSet = ["2 jeux", "Tie-Break", "super TieBreak"]
        
        for i in 0...2{
            let item = WKPickerItem()
            item.title = tabLastSet[i]
            
            lastSetPickerItems.insert(item, at: i)
        }
        
        lastSetPicker.setItems(lastSetPickerItems)
    }

}
