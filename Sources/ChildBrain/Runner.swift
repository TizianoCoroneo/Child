//
//  Runner.swift
//  ChildPackageDescription
//
//  Created by Tiziano Coroneo on 19/12/2017.
//

import Foundation

public class Runner {
    
    public init() {}
    
    public func run(
        _ arguments: [String],
        diagnostic dia: ((String) -> ())? = nil,
        completion: ((String) -> ())? = nil) throws {
        
        let arguments = Arguments(arguments)
        let helpOption = Arguments.Option.Mixed(shortKey: "h", longKey: "help")
        
        func printVersion() {
            dia?("Version 0.29.0")
            dia?("Created by nixzhu with love.")
        }
        
        func printUsage() {
            dia?("Usage: $ baby -i JSONFilePath")
        }
        
        func printHelp() {
            dia?("-i, --input-file-path JSONFilePath")
            dia?("--public")
            dia?("--model-type ModelType")
            dia?("--model-name ModelName")
            dia?("--codable")
            dia?("--extended-codable")
            dia?("--var")
            dia?("--json-dictionary-name JSONDictionaryName")
            dia?("--property-map \"foo: bar, not_used: _\"")
            dia?("--array-object-map \"skills: Skill, itemlist: Item\"")
            dia?("--property-type-map \"id: UInt64\"")
            dia?("--enum-properties \"type, gender[male, female, other: unknown]\"")
            dia?("-h, --help")
            dia?("-v, --version")
        }
        
        if arguments.containsOption(helpOption) {
            dia?("Create models from a JSON file, even a Baby can do it.")
            printHelp()
            printVersion()
            return
        }
        
        let versionOption = Arguments.Option.Mixed(shortKey: "v", longKey: "version")
        if arguments.containsOption(versionOption) {
            printVersion()
            return
        }
        
        let inputFilePathOption = Arguments.Option.Mixed(shortKey: "i", longKey: "input-file-path")
        guard let inputFilePath = arguments.valueOfOption(inputFilePathOption) else {
            printUsage()
            printVersion()
            return
        }
        
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: inputFilePath) else {
            dia?("File NOT found at `\(inputFilePath)`!")
            return
        }
        
        guard fileManager.isReadableFile(atPath: inputFilePath) else {
            dia?("No permission to read file at `\(inputFilePath)`!")
            return
        }
        
        guard let data = fileManager.contents(atPath: inputFilePath) else {
            dia?("File is empty!")
            return
        }
        
        guard let jsonString = String(data: data, encoding: .utf8) else {
            dia?("File is NOT encoding with UTF8!")
            return
        }
        
        guard let fileName = inputFilePath
            .split(separator: "/").last
            .map(String.init)?
            .split(separator: ".").first
            .map(String.init)
            else {
                dia?("Impossible to extract the file name. Make sure it doesn't contain any \"/\" character.")
                return
        }
        
        if let (value, _) = parse(jsonString) {
            let modelNameOption = Arguments.Option.Long(key: "model-name")
            let modelName = arguments.valueOfOption(modelNameOption) ?? fileName
            let propertyMapOption = Arguments.Option.Long(key: "property-map")
            let propertyMapString = arguments.valueOfOption(propertyMapOption) ?? ""
            let propertyMap = map(of: propertyMapString)
            let arrayObjectMapOption = Arguments.Option.Long(key: "array-object-map")
            let arrayObjectMapString = arguments.valueOfOption(arrayObjectMapOption) ?? ""
            let arrayObjectMap = map(of: arrayObjectMapString)
            var removedKeySet: Set<String> = []
            for (key, value) in propertyMap {
                if value.isEmpty || value == "_" {
                    removedKeySet.insert(key)
                }
            }
            let upgradedValue = value.upgraded(newName: modelName, arrayObjectMap: arrayObjectMap, removedKeySet: removedKeySet)
            let publicOption = Arguments.Option.Long(key: "public")
            let modelTypeOption = Arguments.Option.Long(key: "model-type")
            let codableOption = Arguments.Option.Long(key: "codable")
            let extendedCodableOption = Arguments.Option.Long(key: "extended-codable")
            let varOption = Arguments.Option.Long(key: "var")
            let jsonDictionaryNameOption = Arguments.Option.Long(key: "json-dictionary-name")
            let isPublic = arguments.containsOption(publicOption)
            let modelType = arguments.valueOfOption(modelTypeOption) ?? "struct"
            let codable = arguments.containsOption(codableOption)
            let extendedCodable = arguments.containsOption(extendedCodableOption)
            let declareVariableProperties = arguments.containsOption(varOption)
            let jsonDictionaryName = arguments.valueOfOption(jsonDictionaryNameOption) ?? "[String: Any]"
            let propertyTypeMapOption = Arguments.Option.Long(key: "property-type-map")
            let propertyTypeMapString = arguments.valueOfOption(propertyTypeMapOption) ?? ""
            let propertyTypeMap = map(of: propertyTypeMapString)
            let enumPropertiesOption = Arguments.Option.Long(key: "enum-properties")
            let enumPropertiesString = arguments.valueOfOption(enumPropertiesOption) ?? ""
            let enumProperties: [Meta.EnumProperty] = list(of: enumPropertiesString).map({ .init(name: $0, cases: $1) })
            let meta = Meta(
                isPublic: isPublic,
                modelType: modelType,
                codable: codable,
                extendedCodable: extendedCodable,
                declareVariableProperties: declareVariableProperties,
                jsonDictionaryName: jsonDictionaryName,
                propertyMap: propertyMap,
                arrayObjectMap: arrayObjectMap,
                propertyTypeMap: propertyTypeMap,
                enumProperties: enumProperties
            )
            completion?(upgradedValue.swiftCode(meta: meta))
        } else {
            dia?("Invalid JSON!")
        }
    }
}
