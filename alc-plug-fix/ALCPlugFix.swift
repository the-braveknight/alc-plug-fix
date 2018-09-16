//
//  ALCPlugFix.swift
//  alc-plug-fix
//
//  Created by Zaid Rahawi on 9/14/18.
//  Copyright © 2018 Zaid Rahawi. All rights reserved.
//

import Foundation

class ALCPlugFix: HeadphonesListenerDelegate {
    private let listener = HeadphonesListener()
    let hdaVerbCommands: [HDAVerb.Command]
        
    init(configFileUrl: URL) throws {
        self.hdaVerbCommands = try HDAVerb.commands(forConfigFileAt: configFileUrl)
        listener.delegate = self
        print("Number of commands: \(hdaVerbCommands.count).")
    }
    
    func start() {
        print("Starting ALCPlugFix...")
        listener.startListening()
    }
    
    func headphonesListener(_ headphonesListener: HeadphonesListener, didPlugHeadphonesAt date: Date) {
        hdaVerbCommands.filter { $0.onPlug }.forEach { command in perform(command: command, at: date) }
    }
    
    func headphonesListener(_ headphonesListener: HeadphonesListener, didUnplugHeadphonesAt date: Date) {
        hdaVerbCommands.filter { $0.onUnplug }.forEach { command in perform(command: command, at: date) }
    }
    
    func perform(command: HDAVerb.Command, at date: Date) {
        HDAVerb.main.perform(command: command) { _ in
            if let comment = command.comment {
                print("\(date) - Performing command: \(comment).")
            }
        }
    }
}
