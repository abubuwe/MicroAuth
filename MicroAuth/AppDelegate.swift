//
//  AppDelegate.swift
//  MicroAuth
//
//  Created by Damon Falck on 06/03/2021.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusItem: NSStatusItem?
    var authView: AuthView?
    @IBOutlet weak var menu: NSMenu?
    @IBOutlet weak var firstMenuItem: NSMenuItem?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // All relevant code in awakeFromNib
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Create status bar item and menu
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem?.button?.image = NSImage(named: "Icon")
        
        // Add menu (designed in IB)
        if let menu = menu {
            statusItem?.menu = menu
        }
        
        // Add instance of custom view to top of menu
        authView = AuthView(frame: NSRect(x: 0.0, y: 0.0, width: 250.0, height: 170.0))
        if let item = firstMenuItem {
            item.view = authView
        }
    }

}

