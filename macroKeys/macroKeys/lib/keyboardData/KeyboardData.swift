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
      
        let keysDescription = keys
            .compactMap({$0.characters?.uppercased()})
            .joined(separator: "+")
        
        let modDescription = modifier.char
        
        if keysDescription == "" && modDescription == "" {
            return "No Mappings Found"
        } else if modDescription == "" {
            return keysDescription
        } else if keysDescription == "" {
            return modDescription
        } else {
            return "\(modDescription)+\(keysDescription)"
        }
        
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
        prevKeys = keys
        keys = []
        prevModifier = modifier
        modifier = Modifier()
    }
    
    mutating func commit() {
        prevKeys = keys
        prevModifier = modifier
    }
    
    mutating func rollback() {
        keys = prevKeys
        modifier = prevModifier
    }
    
    @discardableResult
    mutating func add(keyEvent: NSEvent) -> Bool {
        let newKey = Key(withEvent: keyEvent)
        
        if keys.contains(newKey) {
            print("No key added")
        } else {
            keys.append(Key(withEvent: keyEvent))
        }
        return keys == prevKeys
    }
    
    @discardableResult
    mutating func add(bitmask: UInt64) -> Bool {
        modifier = modifier.or(bitmask: bitmask)
        return prevModifier == modifier
    }
    
    func didUpdate(onButton sender: NSButton) -> Bool {
        return keys != prevKeys
    }
    
    func executeMapping() {
        let src = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)
        let loc = CGEventTapLocation.cghidEventTap
        
        // key events
        for key in self.keys {
            let pressKey = CGEvent(keyboardEventSource: src, virtualKey: key.keycode, keyDown: true)
            let releaseKey = CGEvent(keyboardEventSource: src, virtualKey: key.keycode, keyDown: false)
            
            // modifiers mask
            pressKey?.flags = self.mask
            
            //press key
            pressKey?.post(tap: loc)
            releaseKey?.post(tap: loc)
        }
    }
}
