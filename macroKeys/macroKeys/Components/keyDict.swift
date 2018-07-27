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
    var keys : [NSButton: [String]] = [:]
    var prevKeys : [NSButton: [String]] = [:]
    
    mutating func addKey(loggedBy sender: NSButton, loggedKey key: NSEvent) {
        var currKeys = self.keys[sender] ?? []
        // Sanity check only add keys with characters
        if let newChar = key.characters, !currKeys.contains(newChar){
            currKeys.append(newChar)
            self.keys[sender] = currKeys
        } else {
            print("No key added")
        }
    }
    
    mutating func updatePrevKeys(onButton sender: NSButton) {
        self.prevKeys[sender] = self.keys[sender]
    }
    
    func didUpdate(onButton sender: NSButton) -> Bool {
        return self.keys[sender] != self.prevKeys[sender]
    }
    
    func printKeys(ofButton sender: NSButton) -> String {
        return keys[sender]?.joined(separator: "+") ?? ""
    }
    
}
