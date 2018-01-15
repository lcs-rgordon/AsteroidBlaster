//
//  AppDelegate.swift
//  AsteroidBlaster
//
//  Created by Russell Gordon on 1/14/18.
//  Copyright © 2018 Russell Gordon. All rights reserved.
//

import Cocoa
import ImagineEngine

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    private var window: GameWindowController!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        // Create scene
        let sceneSize = Size(width: 375, height: 667)
        let gameScene = AsteroidBlasterScene(size: sceneSize)
        
        // Log texture load errors
        gameScene.textureManager.errorMode = .log
        print("Main screen scale: \(Screen.main?.backingScaleFactor ?? 1)")

        // Set up window to present scene
        window = GameWindowController(size: sceneSize, scene: gameScene)
        window.window!.appearance = NSAppearance(named: .vibrantDark)
        window.window!.title = "Asteroid Blaster"
        window.window!.makeKeyAndOrderFront(nil)
        
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
}

