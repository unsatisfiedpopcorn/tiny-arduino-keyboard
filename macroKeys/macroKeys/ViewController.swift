//
//  ViewController.swift
//  macroKeys
//
//  Created by Chelsea Chia on 5/7/18.
//  Copyright © 2018 Chelsea Chia. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var keyButton1: NSButton!
    @IBOutlet weak var keyButton2: NSButton!
    @IBOutlet weak var keyButton3: NSButton!
    @IBOutlet weak var keyButton4: NSButton!
    
    lazy var keyButtonCollection = [keyButton1, keyButton2, keyButton3, keyButton4]
    var keyboardDataCollection = [KeyboardData](repeating: KeyboardData.init(), count: 4) {
        didSet {
            //Update View
            updateView()
            // Saves changes to UserDefaults
            if let encoded = try? JSONEncoder().encode(keyboardDataCollection) {
                UserDefaults.standard.set(encoded, forKey: "SavedBindings")
            }
        }
    }
    
    @IBAction func keyButton(_ sender: NSButton) {
        let buttonIndex = keyButtonCollection.index(of: sender)!
        if sender.state == NSButton.StateValue.on {
            // Starts transaction on the corresponding keyboardData, allowing for rollbacks
            keyboardDataCollection[buttonIndex].startTransaction()
            // Ensures that only one keyButton can be "on" at a time.
            keyButtonCollection
                .enumerated()
                .filter({$0.element != sender})
                .forEach({onCommitDeactivate(index: $0.offset);})
            print("on")
            
        } else if sender.state == NSButton.StateValue.off {
            // Turns off the button and commits transaction
            onCommitDeactivate(index: buttonIndex)
        }
    }
    
    func onCommitDeactivate(index: Int) {
        keyButtonCollection[index]?.state = NSButton.StateValue.off
        keyboardDataCollection[index].commit()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NSEvent.addLocalMonitorForEvents(matching: .flagsChanged) { keyEvent in
            
            self.keyButtonCollection
                .enumerated()
                .filter({$0.element!.state == NSButton.StateValue.on})
                .forEach() {
                    let sanitizedMask = UInt64(keyEvent.modifierFlags.rawValue)
                    self.keyboardDataCollection[$0.offset].add(bitmask: sanitizedMask)
            }
            return keyEvent
        }
        
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { keyEvent in
            // Perform actions on buttons which are on a on state
            self.keyButtonCollection.enumerated()
                .filter({$0.element!.state == NSButton.StateValue.on})
                .forEach() {tuple in
                    if keyEvent.keyCode == 53 { // ESC is pressed, then rollback currently recorded keys
                        tuple.element?.state = NSButton.StateValue.off
                        self.keyboardDataCollection[tuple.offset].rollback()
                    } else if keyEvent.keyCode == 36 { // Enter is pressed, the commit currently recorded keys
                        tuple.element?.state = NSButton.StateValue.off
                        self.keyboardDataCollection[tuple.offset].commit()
                    } else {
                        print(keyEvent.characters!)
                        print(keyEvent.charactersIgnoringModifiers!)
                        // Update Dictionary of key mappings
                        self.keyboardDataCollection[tuple.offset].add(keyEvent: keyEvent)
                    }
            }
            print(self.keyboardDataCollection)
            return keyEvent
        }
        
        // Intercept First Responder
        view.window?.makeFirstResponder(self);
        
        //monitor key events
        NSEvent.addGlobalMonitorForEvents(matching: .keyDown) {
            self.keyDown(with: $0)
        }
    }
    
    func updateView() {
        keyButtonCollection
            .enumerated()
            .forEach({$0.element?.title = keyboardDataCollection[$0.offset].description})
    }
    
    
    override func keyDown(with event: NSEvent) {
        let keyPressed = event.keyCode
        //assuming Key and Modifier classes --> refer to lib folder
        //fn20 -> keycode=90
        switch (keyPressed) {
        case 50:
//            executeMapping(mapping: keyboardDataCollection[0])
            print("` key pressed")
        default:
//            label.stringValue = String(event.keyCode)
            print("")
        }
    }
    
    func executeMapping(mapping: KeyboardData) {
        //fetch data stored
        let keys = mapping.keys
        let modifierMask = mapping.mask
        
        let src = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)
        let loc = CGEventTapLocation.cghidEventTap
        
        // key events
        for key in keys {
            let pressKey = CGEvent(keyboardEventSource: src, virtualKey: key.keycode, keyDown: true)
            let releaseKey = CGEvent(keyboardEventSource: src, virtualKey: key.keycode, keyDown: false)
            
            // modifiers mask
            pressKey?.flags = modifierMask
            
            //press key
            pressKey?.post(tap: loc)
            releaseKey?.post(tap: loc)
        }
    }
}
