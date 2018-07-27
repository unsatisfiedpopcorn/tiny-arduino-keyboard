//
//  ViewController.swift
//  macroKeys
//
//  Created by Chelsea Chia on 5/7/18.
//  Copyright © 2018 Chelsea Chia. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    var keyDict = KeyDict.init()
    
    @IBOutlet weak var keyButton1: NSButton!
    @IBOutlet weak var keyButton2: NSButton!
    @IBOutlet weak var keyButton3: NSButton!
    @IBOutlet weak var keyButton4: NSButton!
    
    lazy var keyButtonCollection = [keyButton1, keyButton2, keyButton3, keyButton4]
    
    @IBAction func keyButton(_ sender: NSButton) {
        // TODO Clear dictionary ONLY if there is a change detected
        if sender.state == NSButton.StateValue.on {
            // Ensures that only one keyButton can be "on" at a time.
            for keyButton in keyButtonCollection.filter({$0 != sender}) {
                keyButton?.state = NSButton.StateValue.off
            }
            
            print("on")
            
        } else if sender.state == NSButton.StateValue.off {
            // TODO: send keys to storage ??
        }
        updateView()
    }
    
    func deactivateButton(_ sender: NSButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        
        NSEvent.addLocalMonitorForEvents(matching: .flagsChanged) {
            self.flagsChanged(with: $0)
            return $0
        }
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            if $0.keyCode == 53 { // ESC is pressed, then rollback currently recorded keys
                for keyButton in self.keyButtonCollection {
                    if keyButton?.state == NSButton.StateValue.on {
                        keyButton?.state = NSButton.StateValue.off
                        self.keyDict.rollback(onButton: keyButton!)
                    }
                }
            } else {
                for keyButton in self.keyButtonCollection {
                    if keyButton?.state == NSButton.StateValue.on {
                        print($0.characters!)
                        // Update Dictionary of key mappings
                        self.keyDict.addKey(loggedBy: keyButton!, loggedKey: $0)
                        // Update view
                    }
                }
            }
            self.updateView()
            self.keyDown(with: $0)
            print(self.keyDict)
            return $0
        }
    }
    
    func updateView() {
        for keyButton in keyButtonCollection {
            keyButton!.title = keyDict.printKeys(ofButton: keyButton!)
        }
    }
}
