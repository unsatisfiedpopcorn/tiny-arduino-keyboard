//
//  Modifier.swift
//  macroKeys
//
//  Created by Chelsea Chia on 24/7/18.
//  Copyright © 2018 Chelsea Chia. All rights reserved.
//
import Foundation

class Modifier : Codable {
    let char: String
    var mask: CGEventFlags {
        get {
            return CGEventFlags.init(rawValue: self.rawMask)
        }
    }
    let rawMask: UInt64
    
    init(char: String) {
        self.char = char
        if (char == "left_shift") {
            self.rawMask = CGEventFlags.maskShift.rawValue
        } else if (char == "left_control") {
            self.rawMask = CGEventFlags.maskControl.rawValue
        } else if (char == "left_option") {
            self.rawMask = CGEventFlags.maskAlternate.rawValue
        } else if (char == "left_gui") {
            self.rawMask = CGEventFlags.maskCommand.rawValue
        } else {
            self.rawMask = CGEventFlags(rawValue: 0).rawValue
        }
    }
    
}
