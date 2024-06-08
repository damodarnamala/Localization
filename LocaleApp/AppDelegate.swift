//
//  AppDelegate.swift
//  Locale
//
//  Created by Damodar Namala on 08/06/24.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let screenSize = NSScreen.main?.frame ?? NSRect(x: 0, y: 0, width: 800, height: 600)
        self.window = NSWindow(contentRect: NSRect(x: screenSize.midX - 400, y: screenSize.midY - 300, width: 800, height: 600),
                          styleMask: [.titled, .closable, .resizable, .fullSizeContentView],
                          backing: .buffered,
                          defer: false)
        window.center()
        window.title = "Locale App"
        let viewController = LocaleView.create()
        window.contentViewController = viewController
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

