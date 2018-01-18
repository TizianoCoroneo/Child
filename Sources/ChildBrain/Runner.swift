//
//  Runner.swift
//  ChildPackageDescription
//
//  Created by Tiziano Coroneo on 19/12/2017.
//

import Foundation

public class Runner {
    
    let logger: Logger
    
    public init(withDiagnostic dia: ((String) throws -> ())?) {
        self.logger = Logger(withDiagnostic: dia)
    }
    
    public func runCommandLine(
        _ arguments: [String],
        completion: ((String) -> ())? = nil) throws {
        
        let arguments = Arguments(arguments)
        
        let helpOption = Arguments.Option.Mixed(
            shortKey: "h",
            longKey: "help")
        let versionOption = Arguments.Option.Mixed(
            shortKey: "v",
            longKey: "version")
        let inputFilePathOption = Arguments.Option.Mixed(
            shortKey: "i",
            longKey: "input-file-path")
        
        guard !arguments.containsOption(helpOption) else {
            try logger.print("Create models from a JSON file, even a Child can do it.")
            try logger.printHelp()
            try logger.printVersion()
            return
        }
        
        guard !arguments.containsOption(versionOption) else {
            try logger.printVersion()
            return
        }
        
        guard let inputFilePath = arguments.valueOfOption(inputFilePathOption) else {
            try logger.printUsage()
            try logger.printVersion()
            return
        }
        
        guard
            let jsonString = try fileContent(fromPath: inputFilePath)
            else { return }
        
        guard let fileName = inputFilePath
            .split(separator: "/").last
            .map(String.init)?
            .split(separator: ".").first
            .map(String.init)
            else {
                try logger.print("Impossible to extract the file name. Make sure it doesn't contain any \"/\" character.")
                return
        }
        
        guard let (value, _) = parse(jsonString) else {
            try logger.print("Invalid JSON!")
            return
        }
        
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
        let tcjsonOption = Arguments.Option.Long(key: "tcjson")
        let varOption = Arguments.Option.Long(key: "var")
        let realmOption = Arguments.Option.Long(key: "realm")
        let jsonDictionaryNameOption = Arguments.Option.Long(key: "json-dictionary-name")
        let isPublic = arguments.containsOption(publicOption)
        var modelType = arguments.valueOfOption(modelTypeOption) ?? "struct"
        
        let codable = arguments.containsOption(codableOption)
        let extendedCodable = arguments.containsOption(extendedCodableOption)
        let tcjson = arguments.containsOption(tcjsonOption)
        
        guard !(codable && extendedCodable) else {
            try logger.print("Can't use both --codable and --extended-codable options. Please choose one of them only.")
            return
        }
        
        guard !(codable && tcjson) else {
            try logger.print("Can't use both --codable and --tcjson options. Please choose one of them only.")
            return
        }
        
        var codableType: Meta.CodableType = .standard
        
        if codable || extendedCodable { codableType = .codable }
        if tcjson { codableType = .tcjson }
        
        var declareVariableProperties = Meta.DeclareType.let
        let shouldBeVars = arguments.containsOption(varOption)
        let shouldBeRealms = arguments.containsOption(realmOption)
        
        guard !(shouldBeVars && shouldBeRealms) else {
            try logger.print("Can't use both --var and --realm options. Please choose one of them only.")
            return
        }
        
        if shouldBeVars {
            declareVariableProperties = Meta.DeclareType.var
        } else if shouldBeRealms {
            declareVariableProperties = .realm
            modelType = "class"
        }
        
        guard !shouldBeRealms else {
            try logger.print("Sorry, realm generation not working yet.")
            return
        }
        
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
            codable: codableType,
            extendedCodable: extendedCodable,
            declareVariableProperties: declareVariableProperties,
            jsonDictionaryName: jsonDictionaryName,
            propertyMap: propertyMap,
            arrayObjectMap: arrayObjectMap,
            propertyTypeMap: propertyTypeMap,
            enumProperties: enumProperties
        )
        
        let result = upgradedValue.swiftCode(meta: meta)
        let importStatement = meta.codableType == .tcjson ? "import TCJSON\n\n" : ""
        
        completion?(importStatement + result)
    }
    
    func fileContent(fromPath path: String) throws -> String? {
        
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: path) else {
            try logger.print("File NOT found at `\(path)`!")
            return nil
        }
        
        guard fileManager.isReadableFile(atPath: path) else {
            try logger.print("No permission to read file at `\(path)`!")
            return nil
        }
        
        guard let data = fileManager.contents(atPath: path) else {
            try logger.print("File is empty!")
            return nil
        }
        
        guard let jsonString = String(data: data, encoding: .utf8) else {
            try logger.print("File is NOT encoding with UTF8!")
            return nil
        }
        
        return jsonString
    }
}
