//
//  main.swift
//  alc-plug-fix
//
//  Created by Zaid Rahawi on 9/15/18.
//  Copyright © 2018 Zaid Rahawi. All rights reserved.
//

import Foundation

func showOptions() {
    let message = """
USAGE: alc-plug-fix [--config verb_config.plist]

OPTIONS:
    --config, -c    A Property List (plist) array file that contains custom HDA verb commands
    --help, -h      Display available options
"""
    print(message)
}

for (index, argument) in CommandLine.arguments.enumerated() {
    if (argument == "--config" || argument == "-c") && CommandLine.arguments.indices.contains(index + 1) {
        let configPath = CommandLine.arguments[index + 1]
        let url = URL(fileURLWithPath: configPath)
        do {
            let alcplugfix = try ALCPlugFix(configFileUrl: url)
            alcplugfix.start()
            RunLoop.main.run()
        } catch {
            print("Error: \(error.localizedDescription).")
            exit(1)
        }
        break
    }
}

showOptions()
