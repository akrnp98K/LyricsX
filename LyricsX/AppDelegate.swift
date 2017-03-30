//
//  AppDelegate.swift
//  LyricsX
//
//  Created by 邓翔 on 2017/2/4.
//  Copyright © 2017年 ddddxxx. All rights reserved.
//

import Cocoa
import ServiceManagement
import EasyPreference

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var mediaPlayerHelper = MediaPlayerHelper()
    
    var statusItem: NSStatusItem!
    var menuBarLyrics: MenuBarLyrics!

    dynamic var currentOffset = 0
    
    @IBOutlet weak var statusBarMenu: NSMenu!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)
        menuBarLyrics = MenuBarLyrics()
        
        statusItem.button?.image = #imageLiteral(resourceName: "status_bar_icon")
        statusItem.menu = statusBarMenu
        
        NSRunningApplication.runningApplications(withBundleIdentifier: LyricsXHelperIdentifier).forEach() { $0.terminate() }
        
        if Preference[LaunchAndQuitWithPlayer] {
            if !SMLoginItemSetEnabled(LyricsXHelperIdentifier as CFString, true) {
                print("Failed to enable login item")
            }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        UserDefaults.standard.synchronize()
        if Preference[LaunchAndQuitWithPlayer] {
            let url = Bundle.main.bundleURL.appendingPathComponent("Contents/Library/LoginItems/LyricsXHelper.app")
            NSWorkspace.shared().launchApplication(url.path)
        }
    }

    @IBAction func lyricsOffsetStepAction(_ sender: Any) {
        mediaPlayerHelper.currentLyrics?.offset = currentOffset
        mediaPlayerHelper.currentLyrics?.saveToLocal()
    }
    
    @IBAction func checkUpdateAction(_ sender: Any) {
        let url = URL(string: "https://github.com/XQS6LB3A/LyricsX/releases")!
        NSWorkspace.shared().open(url)
    }
    
}
