//
//  main.swift
//  alc-plug-fix
//
//  Created by Zaid Rahawi on 9/15/18.
//  Copyright © 2018 Zaid Rahawi. All rights reserved.
//

import Foundation
import Utility

let parser = ArgumentParser(commandName: "alc-plug-fix", usage: "alc-plug-fix [--config verb_config.plist]", overview: "alc-plug-fix parses a Property List file for custom HDA verb commands to send on headphones plug/unplug events.")

let configArgument = parser.add(option: "--config", shortName: "-c", kind: String.self, usage: "A Property List (plist) array file that contains custom HDA verb commands.")

// See alc-plug-fix_alc235.plist for example

do {
    let args = Array(CommandLine.arguments.dropFirst())
    let result = try parser.parse(args)
    if let config = result.get(configArgument) {
        let url = URL(fileURLWithPath: config)
        let alcplugfix = try ALCPlugFix(configFileUrl: url)
        alcplugfix.start()
        RunLoop.main.run()
    } else {
        // MARK: Option argument is always optional, hence this check.
        throw ArgumentParserError.expectedArguments(parser, ["--config"])
    }
} catch let error as ArgumentParserError {
    print(error.description)
} catch {
    print(error.localizedDescription)
}
