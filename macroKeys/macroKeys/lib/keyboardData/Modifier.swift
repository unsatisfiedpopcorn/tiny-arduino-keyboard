//
//  Modifier.swift
//  macroKeys
//
//  Created by Chelsea Chia on 24/7/18.
//  Copyright © 2018 Chelsea Chia. All rights reserved.
//
import Foundation
import Cocoa

struct Modifier : Codable, Equatable {
    var char: String {
        get {
            let sanitizedMask = self.rawMask
            var charactersArray = [String]()
            
            /**
             Similar to fallthrough switches.
             Appending a character for modifier active
             */
            //Command
            if sanitizedMask & CGEventFlags.maskCommand.rawValue == CGEventFlags.maskCommand.rawValue {
                charactersArray.append("⌘")
            }
            //Shift
            if sanitizedMask & CGEventFlags.maskShift.rawValue == CGEventFlags.maskShift.rawValue {
                charactersArray.append("⇧")
            }
            //Control
            if sanitizedMask & CGEventFlags.maskControl.rawValue == CGEventFlags.maskControl.rawValue {
                charactersArray.append("⌃")
            }
            //Option
            if sanitizedMask & CGEventFlags.maskAlternate.rawValue == CGEventFlags.maskAlternate.rawValue {
                charactersArray.append("⌥")
            }
            return charactersArray.joined(separator: "+")
        }
    }
    var mask: CGEventFlags {
        get {
            return CGEventFlags.init(rawValue: self.rawMask)
        }
    }
    let rawMask: UInt64
    
    static func == (lhs: Modifier, rhs: Modifier) -> Bool {
        return lhs.rawMask == rhs.rawMask
    }
    
    init() {
        self.rawMask = 0
    }
    
//    init(char: String) {
//        self.char = char
//        if (char == "left_shift") {
//            self.rawMask = CGEventFlags.maskShift.rawValue
//        } else if (char == "left_control") {
//            self.rawMask = CGEventFlags.maskControl.rawValue
//        } else if (char == "left_option") {
//            self.rawMask = CGEventFlags.maskAlternate.rawValue
//        } else if (char == "left_gui") {
//            self.rawMask = CGEventFlags.maskCommand.rawValue
//        } else {
//            self.rawMask = CGEventFlags(rawValue: 0).rawValue
//        }
//    }
    
    init(withBitmask bitmask: UInt64) {
        let sanitizedMask = bitmask & UInt64(NSEvent.ModifierFlags.deviceIndependentFlagsMask.rawValue)
//        var charactersArray = [String]()
        self.rawMask = sanitizedMask
    }
    
    init(withCGEventFlag flag: CGEventFlags) {
        self.init(withBitmask: flag.rawValue)
    }
    
    func or(bitmask: UInt64) -> Modifier {
        return Modifier(withBitmask: self.rawMask | bitmask)
    }
    
    func and(bitmask: UInt64) -> Modifier {
        return Modifier(withBitmask: self.rawMask & bitmask)
    }
    
    
}
