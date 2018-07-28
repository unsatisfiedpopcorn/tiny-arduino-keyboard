//
//  KeyArray.swift
//  macroKeys
//
//  Created by Jeffery on 28/7/18.
//  Copyright © 2018 Chelsea Chia. All rights reserved.
//

import Foundation
import Cocoa

struct KeyboardData : Codable, CustomStringConvertible {
    var mask : CGEventFlags {
        get {
            return self.modifier.mask
        }
    }
    var keys : [Key]
    var modifier : Modifier
    var prevKeys : [Key]
    var prevModifier : Modifier
    public var description: String {
        guard keys != [] else {
            return "No Mappings Found"
        }
        
        return keys
            .compactMap({$0.characters?.uppercased()})
            .joined(separator: "+")        
    }
    
    init() {
        self.keys = []
        self.modifier = Modifier.init()
        self.prevKeys = self.keys
        self.prevModifier = self.modifier
    }
    
    
    init(keys: [Key], modifier: Modifier? = Modifier.init()) {
        self.keys = keys
        // If no Modifier, inits a modifier with an empty mask
        self.modifier = modifier!
        self.prevKeys = self.keys
        self.prevModifier = self.modifier
        
    }
    
    init(key: Key, modifier: Modifier? = Modifier.init()) {
        self.keys = [key]
        // If no Modifier, inits a modifier with an empty mask
        self.modifier = modifier!
        self.prevKeys = self.keys
        self.prevModifier = self.modifier
    }
    
    mutating func startTransaction() {
        self.prevKeys = self.keys
        self.keys = []
    }
    
    mutating func commit() {
        self.prevKeys = self.keys
    }
    
    mutating func rollback() {
        self.keys = self.prevKeys
    }
    
    @discardableResult
    mutating func add(keyEvent: NSEvent) -> Bool {
        // TODO: Support for modifier keys
        var updated = false
        let newKey = Key.init(withEvent: keyEvent)
        
        if keys.contains(newKey) {
            print("No key added")
        } else {
            self.keys.append(Key.init(withEvent: keyEvent))
            updated = true
            print(self.keys)
        }
        return updated
    }
    
    func didUpdate(onButton sender: NSButton) -> Bool {
        return self.keys != self.prevKeys
    }
}
