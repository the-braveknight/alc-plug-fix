//
//  ALCPlugFix.swift
//  alc-plug-fix
//
//  Created by Zaid Rahawi on 9/14/18.
//  Copyright © 2018 Zaid Rahawi. All rights reserved.
//

import Foundation

class ALCPlugFix: OutputDeviceListenerDelegate {
    private let listener = OutputDeviceListener()
    let hdaVerbCommands: [HDAVerb.Command]
        
    init(configFileUrl: URL) throws {
        self.hdaVerbCommands = try HDAVerb.commands(forConfigFileAt: configFileUrl)
        listener.delegate = self
        print("Parsed \(hdaVerbCommands.count) verb commands.")
    }
    
    func start() {
        print("Starting ALCPlugFix...")
        listener.startListening()
    }
    
    func outputDeviceListener(_ outputDeviceListener: OutputDeviceListener, outputDeviceDidChangeTo newOutputDevice: OutputDevice) {
        switch newOutputDevice {
        case .speakers:
            hdaVerbCommands.filter { $0.onUnplug }.forEach { command in
                HDAVerb.main.perform(command: command) { output in
                    if let comment = command.comment {
                        print("Performing command: \(comment)")
                    }
                }
            }
        case .headphones:
            hdaVerbCommands.filter { $0.onPlug }.forEach { command in
                HDAVerb.main.perform(command: command) { output in
                    if let comment = command.comment {
                        print("Performing command: \(comment)")
                    }
                }
            }
        case .other:
            break
        }
    }
}
