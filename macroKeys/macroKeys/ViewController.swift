//
//  ViewController.swift
//  macroKeys
//
//  Created by Chelsea Chia on 5/7/18.
//  Copyright © 2018 Chelsea Chia. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    var keyDict = KeyDict.init() {
        didSet {
            // Add update
        }
    }
    
    @IBOutlet weak var keyButton1: NSButton!
    @IBOutlet weak var keyButton2: NSButton!
    @IBOutlet weak var keyButton3: NSButton!
    @IBOutlet weak var keyButton4: NSButton!
    
    lazy var keyButtonCollection = [keyButton1, keyButton2, keyButton3, keyButton4]
    
    @IBAction func keyButton(_ sender: NSButton) {
        if sender.state == NSButton.StateValue.on {
            keyDict.startTransaction(onButton: sender)
            // Ensures that only one keyButton can be "on" at a time.
            for keyButton in keyButtonCollection.filter({$0 != sender}) {
                onCommitDeactivate(button: keyButton!)
            }
            print("on")
            
        } else if sender.state == NSButton.StateValue.off {
            onCommitDeactivate(button: sender)
        }
        updateView()
    }
    
    func onCommitDeactivate(button sender: NSButton) {
        sender.state = NSButton.StateValue.off
        keyDict.commit(onButton: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        
        NSEvent.addLocalMonitorForEvents(matching: .flagsChanged) {
            self.flagsChanged(with: $0)
            return $0
        }
        
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            for keyButton in self.keyButtonCollection.filter({$0!.state == NSButton.StateValue.on}) {
                if $0.keyCode == 53 { // ESC is pressed, then rollback currently recorded keys
                    keyButton?.state = NSButton.StateValue.off
                    self.keyDict.rollback(onButton: keyButton!)
                } else if $0.keyCode == 36 { // Enter is pressed, the commit currently recorded keys
                    keyButton?.state = NSButton.StateValue.off
                    self.keyDict.commit(onButton: keyButton!)
                } else {
                    print($0.characters!)
                    // Update Dictionary of key mappings
                    self.keyDict.addKey(loggedBy: keyButton!, loggedKey: $0)
                }
            }
            self.updateView()
            self.keyDown(with: $0)
            print(self.keyDict)
            return $0
        }
    }
    
    func updateView() {
        keyButtonCollection
            .forEach({$0?.title = keyDict.printKeys(ofButton: $0!)})
    }
}
