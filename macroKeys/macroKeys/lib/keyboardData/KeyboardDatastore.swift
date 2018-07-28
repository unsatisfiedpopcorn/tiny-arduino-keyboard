////
////  KeyboardDatastore.swift
////  macroKeys
////
////  Created by Jeffery on 28/7/18.
////  Copyright © 2018 Chelsea Chia. All rights reserved.
////
//
//import Foundation
//import Cocoa
//
//// TODO: Recognise modifier keys
//struct KeyboardDatastore {
//    var keys : [KeyboardData] = []
//    var prevKeys : [KeyboardData] = []
//    
//    mutating func addKey(loggedBy sender: NSButton, loggedKey key: NSEvent) {
//        var currKeys : [NSEvent] = self.keys[sender] ?? []
//        /**
//         Currently only allows keys with characters to be recorded.
//         Keys with the same keycodes will not be recorded.
//         */
//        if let _ = key.characters, !currKeys.contains(where: {$0.keyCode == key.keyCode}) {
//            currKeys.append(key)
//            self.keys[sender] = currKeys
//        } else {
//            print("No key added")
//        }
//    }
//    
//    mutating func startTransaction(onButton sender: NSButton) {
//    }
//    
//    mutating func commit(onButton sender: NSButton) {
//    }
//    
//    mutating func rollback(onButton sender: NSButton) {
//    }
//    
//    func printKeys(ofButton sender: NSButton) -> String {
//    }
//    
//}
