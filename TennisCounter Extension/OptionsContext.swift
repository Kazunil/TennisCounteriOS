//
//  OptionsContext.swift
//  TennisCounteriOS
//
//  Created by rmounier on 30/10/2017.
//  Copyright © 2017 rmounier. All rights reserved.
//

import Foundation

class OptionsContext {
     var setGagnants: Int
     var dernierSet: Int
     private var setEn3Jeux: Bool
    
    init (setGagnants: Int, dernierSet: Int, setEn3Jeux: Bool) {
        self.setGagnants = setGagnants
        self.dernierSet = dernierSet
        self.setEn3Jeux = setEn3Jeux
    }
    
    func getNbJeuxGagnants() -> Int{
        return setEn3Jeux ? 3 : 6
    }

}
