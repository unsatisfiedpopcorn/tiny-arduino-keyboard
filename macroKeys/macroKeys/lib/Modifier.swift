//
//  Modifier.swift
//  macroKeys
//
//  Created by Chelsea Chia on 24/7/18.
//  Copyright © 2018 Chelsea Chia. All rights reserved.
//

import Foundation

class Modifier {
    let char: String
    let mask: CGEventFlags
    
    init(char: String) {
        self.char = char
        if (char == "left_shift") {
            self.mask = CGEventFlags.maskShift
        } else if (char == "left_control") {
            self.mask = CGEventFlags.maskControl
        } else if (char == "left_option") {
            self.mask = CGEventFlags.maskAlternate
        } else if (char == "left_gui") {
            self.mask = CGEventFlags.maskCommand
        } else {
            self.mask = CGEventFlags(rawValue: 0)
        }
    }
}

