//
//  ViewController.swift
//  macroKeys
//
//  Created by Chelsea Chia on 5/7/18.
//  Copyright © 2018 Chelsea Chia. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    // UserDefaults.standard.object(forKey: "keyDict") as? KeyDict ??
    var keyDict: KeyDict =  KeyDict.init()
//    {
//        didSet {
//            print("didSet Triggered")
//            UserDefaults.standard.set(keyDict, forKey: "keyDict")
//        }
//    }
    
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
            
            func printModifiers(_ keyEvent : NSEvent) {
//                switch keyEvent.flags {
//
//                }
            }
            
            for keyButton in self.keyButtonCollection.filter({$0!.state == NSButton.StateValue.on}) {
                switch $0.modifierFlags.intersection(.deviceIndependentFlagsMask) {
                case [.shift]:
                    print("shift key is pressed")
                case [.control]:
                    print("control key is pressed")
                case [.option] :
                    print("option key is pressed")
                case [.command]:
                    print("Command key is pressed")
                case [.control, .shift]:
                    print("control-shift keys are pressed")
                case [.option, .shift]:
                    print("option-shift keys are pressed")
                case [.command, .shift]:
                    print("command-shift keys are pressed")
                case [.control, .option]:
                    print("control-option keys are pressed")
                case [.control, .command]:
                    print("control-command keys are pressed")
                case [.option, .command]:
                    print("option-command keys are pressed")
                case [.shift, .control, .option]:
                    print("shift-control-option keys are pressed")
                case [.shift, .control, .command]:
                    print("shift-control-command keys are pressed")
                case [.control, .option, .command]:
                    print("control-option-command keys are pressed")
                case [.shift, .command, .option]:
                    print("shift-command-option keys are pressed")
                case [.shift, .control, .option, .command]:
                    print("shift-control-option-command keys are pressed")
                default:
                    print("no modifier keys are pressed")
                }
                // Update Dictionary of key mappings
                //                    self.keyDict.addKey(loggedBy: keyButton!, loggedKey: $0)
            }
            self.updateView()
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
