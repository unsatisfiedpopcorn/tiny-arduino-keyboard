//
//  Key.swift
//  macroKeys
//
//  Created by Chelsea Chia on 22/7/18.
//  Copyright © 2018 Chelsea Chia. All rights reserved.
//

// TODO: let characters be a computed variable based on the keycode (ignoring all modifiers including Shift)
import Foundation
import Cocoa

struct Key : Codable, Equatable {
    let keycode: CGKeyCode
    let characters: String?
    
    /**
     This equality checker disregards characters
     $ and 4 are both the same key
     */
    static func == (lhs: Key, rhs: Key) -> Bool {
        return lhs.keycode == rhs.keycode
    }
    
    /**
     Initialises with a CGKeycode and a given char
     */
    init(keycode: CGKeyCode, char: String) {
        self.keycode = keycode
        self.characters = char
    }
    
    /**
     Initialises with an NSEvent, extracting all the required keycode and characters
     */
    init(withEvent keyEvent: NSEvent) {
        self.keycode = keyEvent.keyCode
        self.characters = keyEvent.charactersIgnoringModifiers
    }
}
