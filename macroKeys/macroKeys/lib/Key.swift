//
//  File.swift
//  macroKeys
//
//  Created by Chelsea Chia on 22/7/18.
//  Copyright © 2018 Chelsea Chia. All rights reserved.
//

import Foundation

class Key {
    let keycode: CGKeyCode
    let char: String
    
    init(keycode: CGKeyCode, char: String) {
        self.keycode = keycode
        self.char = char
    }
}
