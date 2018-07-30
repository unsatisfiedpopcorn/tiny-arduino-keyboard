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
    var keyboardDataCollection = { () -> [KeyboardData] in  // Uses IIFE to load UserDefaults, if nil then does a fresh init
        if let data = UserDefaults.standard.data(forKey: "SavedBindings") , let decodedData = try? JSONDecoder().decode([KeyboardData].self, from: data) {
            return decodedData
        } else {
            return [KeyboardData](repeating: KeyboardData.init(), count: 4)
        }
        }() { // This didSet belongs to keyboardDataCollection
        didSet {
            //Update View
            updateView()
            // Saves changes to UserDefaults
            if let encoded = try? JSONEncoder().encode(keyboardDataCollection) {
                UserDefaults.standard.set(encoded, forKey: "SavedBindings")
            }
        }
    }
    
    //Monitor for connected USB devices
    let watch = DeviceWatcher()

    
    /*
     Updates the view by repopulating the button.title with its corresponding keyboardData
     */
    func updateView() {
        keyButtonCollection
            .enumerated()
            .forEach({
                let button = $0.element!
                let index = $0.offset
                let keyboardDataDescription = keyboardDataCollection[index].description
                /**
                 If keyboardData is empty, display "Press to record"
                 Else diplay the current keyboardData
                 */
                button.title = (button.state == NSButton.StateValue.off &&
                    keyboardDataDescription == "") ?
                        "   Press to record" : "   " + keyboardDataDescription
            })
    }
    
    /**
     Triggers actions on the toggling of states
     From off to on, keyButton will start a transaction to record keystrokes
     From on to off, keyButton will commit the transaction
     For rollback, see local monitor that handles an ESC keypress below
     */
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
    
    /**
     Commits the changes to the keyboardData and deactivates the corresponding buttons
     */
    func onCommitDeactivate(index: Int) {
        keyButtonCollection[index]?.state = NSButton.StateValue.off
        keyboardDataCollection[index].commit()
    }
    
    /**
     Sets up local monitors to record keystrokes
     Sets up global monitors to rebind the keys
     Updates view on load
     Checks for accessibilty and prompts the user if there's no access given
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // options is declared to issue a prompt requesting for accessibility if not given
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String : true]
        // This function checks for accessiblity returns true if there is access else false
        // As a side effect it will spawn a window on no access
        AXIsProcessTrustedWithOptions(options)
        
        // Captures Modifier keys to UI to store for remapping
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
        /**
         if ESC is pressed : rollback currently recorded keys
         else if Enter is pressed: commit currently recorded keys
         else: Captures keys to UI to store for remapping
         */
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { keyEvent in
            
            // Perform actions on buttons which are on a "on" state
            self.keyButtonCollection
                .enumerated()
                .filter({$0.element!.state == NSButton.StateValue.on})
                .forEach() { (tuple) in
                    if keyEvent.keyCode == 53 { // ESC is pressed
                        tuple.element?.state = NSButton.StateValue.off
                        self.keyboardDataCollection[tuple.offset].rollback()
                    } else if keyEvent.keyCode == 36 { // Enter is pressed
                        tuple.element?.state = NSButton.StateValue.off
                        self.keyboardDataCollection[tuple.offset].commit()
                    } else {
                        // Update Dictionary of key mappings
                        self.keyboardDataCollection[tuple.offset].add(keyEvent: keyEvent)
                    }
            }
            print(self.keyboardDataCollection)
            return keyEvent
        }
        
        // Monitor global key events for remapping
        NSEvent.addGlobalMonitorForEvents(matching: .keyDown) {
            self.keyDown(with: $0)
        }
        updateView()
    }
    
    override func keyDown(with event: NSEvent) {
        let keyPressed = event.keyCode
        switch (keyPressed) {
        case 64:
            //f17
            keyboardDataCollection[0].executeMapping()
        case 79:
            //f18
            keyboardDataCollection[1].executeMapping()
        case 80:
            //f19
            keyboardDataCollection[2].executeMapping()
        case 90:
            //f20
            keyboardDataCollection[3].executeMapping()
        default:
            //            label.stringValue = String(event.keyCode)
            print("")
        }
    }
}
