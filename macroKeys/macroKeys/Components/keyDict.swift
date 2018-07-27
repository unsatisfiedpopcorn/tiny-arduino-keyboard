//
//  keyDict.swift
//  macroKeys
//
//  Created by Jeffery on 27/7/18.
//  Copyright © 2018 Chelsea Chia. All rights reserved.
//

import Foundation
import Cocoa

struct KeyDict {
    var keys : [NSButton: [NSEvent]] = [:]
    var prevKeys : [NSButton: [NSEvent]] = [:]
    
    mutating func addKey(loggedBy sender: NSButton, loggedKey key: NSEvent) {
        var currKeys : [NSEvent] = self.keys[sender] ?? []
        /**
         Currently only allows keys with characters to be recorded.
         Keys with the same keycodes will not be recorded.
         */
        if let _ = key.characters, !currKeys.contains(where: {$0.keyCode == key.keyCode}) {
            currKeys.append(key)
            self.keys[sender] = currKeys
        } else {
            print("No key added")
        }
    }
    
    mutating func startTransaction(onButton sender: NSButton) {
        self.prevKeys[sender] = self.keys[sender]
        self.keys[sender] = nil
    }
    
    mutating func commit(onButton sender: NSButton) {
        self.prevKeys[sender] = self.keys[sender]
    }
    
    mutating func rollback(onButton sender: NSButton) {
        self.keys[sender] = self.prevKeys[sender]
    }
    
    func didUpdate(onButton sender: NSButton) -> Bool {
        return self.keys[sender] != self.prevKeys[sender]
    }
    
    
    func printKeys(ofButton sender: NSButton) -> String {
        guard let arrKeys = keys[sender], arrKeys != [] else {
            return "No Mappings Found"
        }
        
        return arrKeys
                    .compactMap({$0.characters?.uppercased()})
                    .joined(separator: "+")
    }
    
}
