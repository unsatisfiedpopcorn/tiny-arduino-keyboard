//
//  ViewController.swift
//  macroKeys
//
//  Created by Chelsea Chia on 5/7/18.
//  Copyright © 2018 Chelsea Chia. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var keyText: NSTextField!
    @IBOutlet weak var buttonClick: NSButton!
    @IBOutlet weak var label: NSTextField!
    
    @IBOutlet weak var shiftCheck: NSButton!
    @IBOutlet weak var controlCheck: NSButton!
    @IBOutlet weak var optionCheck: NSButton!
    @IBOutlet weak var commandCheck: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        shiftCheck.state = NSControl.StateValue.off
        controlCheck.state = NSControl.StateValue.off
        optionCheck.state = NSControl.StateValue.off
        commandCheck.state = NSControl.StateValue.off
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


    @IBAction func onButtonClick(_ sender: Any) {
        let key = keyText.stringValue
        if key.isEmpty {
            label.stringValue = "== Please enter key value =="
        } else {
            var modifiers = [String]()
            if (shiftCheck.state == NSControl.StateValue.on) {
                modifiers.append("left_shift")
            }
            if (controlCheck.state == NSControl.StateValue.on) {
                modifiers.append("left_control")
            }
            if (optionCheck.state == NSControl.StateValue.on) {
                modifiers.append("left_alt")
            }
            if (commandCheck.state == NSControl.StateValue.on) {
                modifiers.append("left_gui")
            }
            
            var display = ""
            if (modifiers.isEmpty) {
                display = key
            } else {
                display = modifiers.joined(separator: " + ") + " + " + key
            }
        
            label.stringValue = display
            
            buttonHelper(input: key, modifiers: modifiers)
        }

    }
    
}


func buttonHelper(input: String, modifiers: [String]) {
    let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] //documents folder in app sandbox
    let sketchDirUrl = documentUrl.appendingPathComponent("tester")

    //=== create 'tester' folder ===
    if (!directoryExistsAtPath(sketchDirUrl.path)) {
        do {
            try FileManager.default.createDirectory(atPath: sketchDirUrl.path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            NSLog("Unable to create directory \(error.debugDescription)")
        }
    }

    /*
    //=== copy main sketch over ===
    let sketchFile = "working_sketch.ino"
    let ogSketchUrl = URL(fileURLWithPath: "/Users/chelseachia/Documents/tester/tester.ino")
    let sketchUrl = sketchDirUrl.appendingPathComponent(sketchFile)

    do {
        try FileManager.default.copyItem(atPath: ogSketchUrl.path, toPath: sketchUrl.path)
    } catch {
        print("error in copying main sketch. Error:\(NSError.description)")
    }
    */
    
    //=== write files ===
    let headerFile = "variables.h" //file name
    let cFile = "variables.c"
    
    let keystrokes = "\"" + input + "\""

    //write to header file
    var text = "extern char keys[];\n" + "extern char modifiers[4][20];"
    let headerUrl = sketchDirUrl.appendingPathComponent(headerFile)
    do {
        try text.write(to: headerUrl, atomically: false, encoding: .utf8)
    } catch {
        print("error in writing header. Error:\(NSError.description)")
    }
    
    //write to c file
    let modifierText = "char modifiers[4][20] = {\"" + modifiers.joined(separator: "\", \"") + "\"};"
    text = "char keys[] = " + keystrokes + ";\n"
    text += modifierText
    let cUrl = sketchDirUrl.appendingPathComponent(cFile)
    do {
        try text.write(to: cUrl, atomically: false, encoding: .utf8)
    } catch {
        print("error in writing cfile. Error:\(NSError.description)")
    }
    
}


fileprivate func directoryExistsAtPath(_ path: String) -> Bool {
    var isDirectory = ObjCBool(true)
    let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
    return exists && isDirectory.boolValue
}

fileprivate func fileExistsAtPath(_ path: String) -> Bool {
    var isDirectory = ObjCBool(true)
    let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
    return exists && !isDirectory.boolValue
}


