//
//  Tool.swift
//  alc-plug-fix
//
//  Created by Zaid Rahawi on 9/14/18.
//  Copyright © 2018 Zaid Rahawi. All rights reserved.
//

import Foundation

protocol Tool {
    var path: URL { get }
    func run(withArguments arguments: [String], outputHandler: (String) -> Void)
}

extension Tool {
    func run(withArguments arguments: [String], outputHandler: (String) -> Void) {
        let task = Foundation.Process()
        let pipe = Pipe()
        task.launchPath = path.path
        task.standardOutput = pipe
        task.arguments = arguments
        let outputFile = pipe.fileHandleForReading
        task.launch()
        if let outputString = String(data: outputFile.availableData, encoding: .utf8) {
            outputHandler(outputString)
        }
    }
}
