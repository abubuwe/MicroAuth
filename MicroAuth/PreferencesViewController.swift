//
//  PreferencesViewController.swift
//  MicroAuth
//
//  Created by Damon Falck on 06/03/2021.
//

import Cocoa

class PreferencesViewController: NSViewController {

    @IBOutlet weak var secretField: NSTextField!
    @IBOutlet weak var shortcutButton: NSButton!
    @IBOutlet weak var clearButton: NSButton!
    var shortcut: KeyboardShortcut?
    var listening = false {
        didSet {
            if listening {
                DispatchQueue.main.async { [weak self] in
                    self?.shortcutButton.highlight(true)
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.shortcutButton.highlight(false)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get current secret from settings
        secretField.placeholderString = "Secret"
        if let secret = UserDefaults.standard.string(forKey: "secret") {
            secretField.stringValue = secret
        }
        
        // Get current keyboard shortcut from settings and show on button
        if let data = UserDefaults.standard.data(forKey: "shortcut"), let shortcut = try? JSONDecoder().decode(KeyboardShortcut.self, from: data) {
            self.shortcut = shortcut
        }
        if let shortcut = self.shortcut {
            shortcutButton.title = shortcut.description
            clearButton.isEnabled = true
        } else {
            shortcutButton.title = "Set shortcut"
            clearButton.isEnabled = false
        }
    }

    @IBAction func applySettings(_ sender: Any) {
        // Save secret
        if secretField.stringValue == "" {
            UserDefaults.standard.removeObject(forKey: "secret")
        } else {
            UserDefaults.standard.set(secretField.stringValue, forKey: "secret")
        }
        
        // Save keyboard shortcut
        if let shortcut = self.shortcut, let data = try? JSONEncoder().encode(shortcut) {
            UserDefaults.standard.set(data, forKey: "shortcut")
        } else {
            UserDefaults.standard.removeObject(forKey: "shortcut")
        }
        
        dismissPreferences(self)
    }
    
    @IBAction func dismissPreferences(_ sender: Any) {
        self.view.window?.performClose(self)
    }
    
    // Listen for new shortcut to save
    @IBAction func setShortcut(_ sender: Any) {
        listening = true
        view.window?.makeFirstResponder(nil)
    }
    
    // Clear current set shortcut
    @IBAction func clearShortcut(_ sender: Any) {
        shortcut = nil
        shortcutButton.title = "Set shortcut"
        clearButton.isEnabled = false
    }
    
    // New shortcut input
    func updateShortcut(_ event: NSEvent) {
        listening = false
        if let characters = event.charactersIgnoringModifiers {
            let newShortcut = KeyboardShortcut(
                function: event.modifierFlags.contains(.function),
                control: event.modifierFlags.contains(.control),
                command: event.modifierFlags.contains(.command),
                shift: event.modifierFlags.contains(.shift),
                option: event.modifierFlags.contains(.option),
                capsLock: event.modifierFlags.contains(.capsLock),
                carbonFlags: event.modifierFlags.carbonFlags,
                characters: characters,
                keyCode: UInt32(event.keyCode))
            self.shortcut = newShortcut
            shortcutButton.title = shortcut!.description
            clearButton.isEnabled = true
        }
    }
    
}

