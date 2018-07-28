//
//  Modifier.swift
//  macroKeys
//
//  Created by Chelsea Chia on 24/7/18.
//  Copyright © 2018 Chelsea Chia. All rights reserved.
//
import Foundation

struct Modifier : Codable, Equatable {
    var char: String
    var mask: CGEventFlags {
        get {
            return CGEventFlags.init(rawValue: self.rawMask)
        }
    }
    var rawMask: UInt64
    
    static func == (lhs: Modifier, rhs: Modifier) -> Bool {
        return lhs.rawMask == rhs.rawMask
    }
    
    init() {
        self.char = ""
        self.rawMask = 0
    }
    
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
