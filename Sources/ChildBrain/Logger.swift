//
//  Logger.swift
//  Child
//
//  Created by Tiziano Coroneo on 19/01/2018.
//

import Foundation

class Logger {
    
    typealias Diagnostic = ((String) throws -> ())?
    
    private let dia: Diagnostic
    
    init(withDiagnostic dia: Diagnostic) {
        self.dia = dia
    }
    
    func print(_ string: String) throws {
        try dia?(string)
    }
    
    func printVersion() throws {
        try dia?("Version 0.1.0")
        try dia?("Created by Tiziano Coroneo")
        try dia?("Based on Baby - Created by nixzhu with love.")
    }
    
    func printUsage() throws {
        try dia?("""
Usage:
    $ child -i JSONFilePath
    Generates standard model files, providing a value initializer and a dictionary initializer.

    $ child -i JSONFilePath --codable
    Generates Swift 4 Codable's model files, providing a value initializer and a data (utf8) initializer.

    $ child -i JSONFilePath --extended-codable
    Generates Swift 4 Codable's model files, providing a value initializer, a data (utf8) initializer and also the old dictionary initializer.

    $ child -i JSONFilePath --var
    Generates model files with all properties as `var`s instead of `let`s.

    $ child -i JSONFilePath --realm
    Generates model files with all properties as "@objc dynamic var" instead of `let`s.

    $ child -i JSONFilePath --model-name Name
    Change the generated model file name with "Name". It changes also the class name.

    $ child -i JSONFilePath --tcjson
    Generates Swift 4 Codable's model files that inherits from my TCJSONCodable utility protocol. These model are meant to be used with another of my GitHub repos: [TCJSON](https://github.com/TizianoCoroneo/TCJSON).

    $ child -i JSONFilePath --tcjson --extended-codable
    Generates normal TCJSON model files and adds the legacy dictionary initializer.
""")
    }
    
    func printHelp() throws {
        try dia?("-i, --input-file-path JSONFilePath")
        try dia?("--public")
        try dia?("--model-type ModelType")
        try dia?("--model-name ModelName")
        try dia?("--codable")
        try dia?("--extended-codable")
        try dia?("--tcjson")
        try dia?("--var")
        try dia?("--realm")
        try dia?("--json-dictionary-name JSONDictionaryName")
        try dia?("--property-map \"foo: bar, not_used: _\"")
        try dia?("--array-object-map \"skills: Skill, itemlist: Item\"")
        try dia?("--property-type-map \"id: UInt64\"")
        try dia?("--enum-properties \"type, gender[male, female, other: unknown]\"")
        try dia?("-h, --help")
        try dia?("-v, --version")
    }
    
}
