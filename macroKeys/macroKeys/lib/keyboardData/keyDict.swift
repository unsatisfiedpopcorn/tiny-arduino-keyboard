//
//  keyDict.swift
//  macroKeys
//
//  Created by Jeffery on 27/7/18.
//  Copyright © 2018 Chelsea Chia. All rights reserved.
//

import Foundation
import Cocoa

// TODO: Recognise modifier keys
struct KeyDict {
    var keys : [Int: [NSEvent]] = [:]
    var prevKeys : [Int: [NSEvent]] = [:]
    
    
    
    mutating func addKey(loggedBy sender: NSButton, loggedKey key: NSEvent) {
        var currKeys : [NSEvent] = self.keys[sender.hashValue] ?? []
        /**
         Currently only allows keys with characters to be recorded.
         Keys with the same keycodes will not be recorded.
         */
        if let _ = key.characters, !currKeys.contains(where: {$0.keyCode == key.keyCode}) {
            currKeys.append(key)
            self.keys[sender.hashValue] = currKeys
        } else {
            print("No key added")
        }
    }
    
    mutating func startTransaction(onButton sender: NSButton) {
        self.prevKeys[sender.hashValue] = self.keys[sender.hashValue]
        self.keys[sender.hashValue] = nil
    }
    
    mutating func commit(onButton sender: NSButton) {
        self.prevKeys[sender.hashValue] = self.keys[sender.hashValue]
    }
    
    mutating func rollback(onButton sender: NSButton) {
        self.keys[sender.hashValue] = self.prevKeys[sender.hashValue]
    }
    
    func didUpdate(onButton sender: NSButton) -> Bool {
        return self.keys[sender.hashValue] != self.prevKeys[sender.hashValue]
    }
    
    
    func printKeys(ofButton sender: NSButton) -> String {
        guard let arrKeys = keys[sender.hashValue], arrKeys != [] else {
            return "No Mappings Found"
        }
        
        return arrKeys
                    .compactMap({$0.characters?.uppercased()})
                    .joined(separator: "+")
    }
    
}
