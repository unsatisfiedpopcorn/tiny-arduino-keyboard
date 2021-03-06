//
//  ArduinoIO.swift
//  macroKeys
//
//  Created by Jeffery on 14/7/18.
//  Copyright © 2018 Chelsea Chia. All rights reserved.
//

import Foundation

class ArduinoIO {
    private let boardType: String
    
    init(boardType: String) {
        self.boardType = boardType
    }
    
    // Method allows class to access shell commands
    @discardableResult
    private static func shell(_ args: String...) -> Int32 {
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = args
        task.launch()
        task.waitUntilExit()
        return task.terminationStatus
    }
    
    // TODO: Takes in an Arduino sketch file then uploads via command line.
    func upload(arduinoSketchFile filepath: String) -> Void {
        ArduinoIO.shell();
    }
    
    // TODO: Flashes 
    func flashAsKeyboard() -> Void {
        
    }
    
}
