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
    var keys : [Key] // Arrays of keys to be simulated
    private var modifier : Modifier // Modifier that stores the modifer bitmask / CGEventFlags
    // These act as reversible state; similar to a stack with only one capacity
    private var prevKeys : [Key]
    private var prevModifier : Modifier
    public var description: String { // Prefixes the modifier keys before other keys, seperates all with a "+"
        let keysDescription = keys // Gets uppercased keys
            .compactMap({$0.characters?.uppercased()})
            .joined(separator: "+")
        
        let modDescription = modifier.char // modifer.char returns all the keys, separated with a "+"
        // Handling different cases, treating "" to be a psuedo-nil
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
    
    /**
     Default init has empty keys and modifiers
     */
    init() {
        self.keys = []
        self.modifier = Modifier()
        self.prevKeys = self.keys
        self.prevModifier = self.modifier
    }
    
    /**
     Init that takes in an array of keys and a modifier
    */
    init(keys: [Key], modifier: Modifier = Modifier()) {
        self.keys = keys
        // If no Modifier, inits a modifier with an empty mask
        self.modifier = modifier
        self.prevKeys = self.keys
        self.prevModifier = self.modifier
        
    }
    
    /**
     Convenience init for a singular key
     */
    init(key: Key, modifier: Modifier = Modifier()) {
        self.init(keys: [key], modifier: modifier)
    }
    
    /**
     Below are psuedo-SQL queries
    */
    
    /**
     Starts a transaction that can be rollbacked to this current state or commited with changes
     Also assigns current keys and modifiers to be empty so that the user may input a new key bindings
     */
    mutating func startTransaction() {
        prevKeys = keys
        keys = []
        prevModifier = modifier
        modifier = Modifier()
    }
    
    /**
     Psuedo commit, designing the current state as the next state to be rollbacked to
     */
    mutating func commit() {
        prevKeys = keys
        prevModifier = modifier
    }
    
    /**
     Rollbacks to the previously commited state or the point where transaction is started
     */
    mutating func rollback() {
        keys = prevKeys
        modifier = prevModifier
    }
    
    /**
     Takes in an NSEvent, adding ONLY the keys pressed excluding modifiers
     */
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
    
    /**
     Takes in a bitmask to add to modifiers
     */
    @discardableResult
    mutating func add(bitmask: UInt64) -> Bool {
        modifier = modifier.or(bitmask: bitmask)
        return prevModifier == modifier
    }
    
    /**
     Reports if there has been changes since hte start of transaciton or the last commit
     */
    func didUpdate(onButton sender: NSButton) -> Bool {
        return keys != prevKeys
    }
    
    /**
     Simulate currently recorded keys and modifiers to be pressed
     */
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
