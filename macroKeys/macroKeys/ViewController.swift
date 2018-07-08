//
//  ViewController.swift
//  macroKeys
//
//  Created by Chelsea Chia on 5/7/18.
//  Copyright © 2018 Chelsea Chia. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBOutlet weak var keyText: NSTextField!
    @IBOutlet weak var buttonClick: NSButton!
    @IBOutlet weak var label: NSTextField!

    @IBAction func onButtonClick(_ sender: Any) {
        var name = keyText.stringValue
        if name.isEmpty {
            name = "empty"
        }
        label.stringValue = name
        
        buttonHelper(input: name)

    }
    
}


func buttonHelper(input: String) {
    let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] //documents folder in app sandbox
    let sketchDirUrl = documentUrl.appendingPathComponent("tester")

    //=== create working_sketch folder ===
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
    var text = "extern char keys[];"

    //write to file
    let headerUrl = sketchDirUrl.appendingPathComponent(headerFile)
    do {
        try text.write(to: headerUrl, atomically: false, encoding: .utf8)
    } catch {
        print("error in wirint header")
    }
    
    text = "char keys[] = " + keystrokes + ";"

    let cUrl = sketchDirUrl.appendingPathComponent(cFile)
    do {
        try text.write(to: cUrl, atomically: false, encoding: .utf8)
    } catch {/* error handling here */}
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


