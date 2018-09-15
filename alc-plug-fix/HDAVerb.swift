//
//  HDAVerb.swift
//  alc-plug-fix
//
//  Created by Zaid Rahawi on 9/14/18.
//  Copyright © 2018 Zaid Rahawi. All rights reserved.
//

import Foundation

class HDAVerb: Tool {
    struct Command: Codable {
        var comment: String?
        var verb: String
        var node: Int
        var value: Int
        var onPlug: Bool
        var onUnplug: Bool
        
        enum CodingKeys: String, CodingKey {
            case comment = "Comment"
            case verb = "Verb"
            case node = "Node"
            case value = "Value"
            case onPlug = "On Plug"
            case onUnplug = "On Unplug"
        }
    }
    
    let path: URL
    
    init(path: String) {
        self.path = URL(fileURLWithPath: path)
    }
    
    static let main = HDAVerb(path: "/usr/bin/hda-verb")
    
    func perform(command: Command, outputHandler: (String) -> Void) {
        run(withArguments: ["\(command.node)", "\(command.verb)", "\(command.value)"], outputHandler: outputHandler)
    }
    
    static func commands(forConfigFileAt url: URL) throws -> [Command] {
        let data = try Data(contentsOf: url)
        let decoder = PropertyListDecoder()
        let commands = try decoder.decode([Command].self, from: data)
        return commands
    }
}
