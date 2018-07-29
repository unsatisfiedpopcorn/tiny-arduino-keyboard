//
//  Modifier.swift
//  macroKeys
//
//  Created by Chelsea Chia on 24/7/18.
//  Copyright © 2018 Chelsea Chia. All rights reserved.
//
import Foundation
import Cocoa

// TODO: Throw error when non-Modifier bitmasks are initialised
struct Modifier : Codable, Equatable {
    
    var char: String { // Computed variable that is dependent on the bitmask
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
    
    var mask: CGEventFlags { // Convenience variable that converts the rawMask to a CGEventFlags
        get {
            return CGEventFlags.init(rawValue: self.rawMask)
        }
    }
    
    let rawMask: UInt64 // rawMask in binary corresponding to keyboard's modifier's mask
    
    /**
     Overrides equality. Two Modifiers are equal as long as they have the same rawMast / bitmask
    */
    static func == (lhs: Modifier, rhs: Modifier) -> Bool {
        return lhs.rawMask == rhs.rawMask
    }
    
    // Inits with an empty bit mask
    init() {
        self.rawMask = 0
    }
    
    // Sanitizes the incoming bitmask and applies it
    init(withBitmask bitmask: UInt64) {
        let sanitizedMask = bitmask & UInt64(NSEvent.ModifierFlags.deviceIndependentFlagsMask.rawValue)
        self.rawMask = sanitizedMask
    }
    
    // Convenience init that takes in a CGEventFlags
    init(withCGEventFlag flag: CGEventFlags) {
        self.init(withBitmask: flag.rawValue)
    }
    
    /**
     Can be chained
     Applies a bitwise OR and returns the result
    */
    func or(bitmask: UInt64) -> Modifier {
        return Modifier(withBitmask: self.rawMask | bitmask)
    }
    
    /**
     Can be chained
     Applies a bitwise AND and returns the result
     */
    func and(bitmask: UInt64) -> Modifier {
        return Modifier(withBitmask: self.rawMask & bitmask)
    }
}
