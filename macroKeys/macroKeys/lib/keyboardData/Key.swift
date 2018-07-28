//
//  Key.swift
//  macroKeys
//
//  Created by Chelsea Chia on 22/7/18.
//  Copyright © 2018 Chelsea Chia. All rights reserved.
//
import Foundation
import Cocoa

struct Key : Codable, Equatable {
    let keycode: CGKeyCode
    let characters: String?
    
    static func == (lhs: Key, rhs: Key) -> Bool {
        return lhs.keycode == rhs.keycode && lhs.characters == rhs.characters
    }
    
    init(keycode: CGKeyCode, char: String) {
        self.keycode = keycode
        self.characters = char
    }
    
    init(withEvent keyEvent: NSEvent) {
        self.keycode = keyEvent.keyCode
        self.characters = keyEvent.characters
    }
    
}
