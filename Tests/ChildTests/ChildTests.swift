//
//  ChildTests.swift
//  ChildTests
//
//  Created by Tiziano Coroneo on 19/12/2017.
//

import XCTest
@testable import ChildBrain

class ChildTests: XCTestCase {
    
    var runner: Runner! = Runner { _ in }
    
    var smallJsonPath: String! = nil
    var bigJsonPath: String! = nil
    
    override func setUp() {
        super.setUp()
        
        let manager = FileManager.default
        
        let smallJsonName = "TestJSONModel.json"
        let bigJsonName = "TestJSONModel.json"
        
        let jsonFolderPath: URL = URL(string: NSTemporaryDirectory())!
        
        smallJsonPath = jsonFolderPath.appendingPathComponent(smallJsonName).absoluteString
        
        bigJsonPath = jsonFolderPath.appendingPathComponent(bigJsonName).absoluteString
        
        manager.createFile(
            atPath: smallJsonPath,
            contents: smallJsonTest1.data(using: .utf8)!,
            attributes: nil)
        
        manager.createFile(
            atPath: bigJsonPath,
            contents: bigJsonTest.data(using: .utf8)!,
            attributes: nil)
        
        runner = Runner { _ in }
    }
    
    override func tearDown() {
        super.tearDown()
        runner = nil
    }
    
    func testBasicInterpet() {
        generate("BasicInterpet", options: [
            "child",
            "-i",
            smallJsonPath
        ]) { string in
            XCTAssert(string
                .contains("init?(json: [String: Any]) {"))
        }
    }
    
    func testCodableInterpet() {
        generate("CodableInterpet", options: [
            "child",
            "-i",
            smallJsonPath,
            "--codable"
        ]) { string in
            XCTAssert(string
                .contains(": Codable"))
        }
    }
    
    func testExtendedCodableInterpet() {
        generate("ExtendedCodableInterpet", options: [
            "child",
            "-i",
            smallJsonPath,
            "--extended-codable"
        ]) { string in
            XCTAssert(string
                .contains("init?(json: [String: Any]) {"))
            XCTAssert(string
                .contains(": Codable"))
        }
    }
    
    func testBigJson() {
        generate("BigJson", options: [
            "child",
            "-i",
            bigJsonPath,
            "--extended-codable"
        ]) { string in
            XCTAssert(string
                .contains("init?(json: [String: Any]) {"))
            XCTAssert(string
                .contains(": Codable"))
        }
    }
    
    func testTCJSONCodable() {
        generate("TCJSONCodable", options: [
            "child",
            "-i",
            bigJsonPath,
            "--tcjson"
        ]) { string in
            XCTAssert(string
                .contains(": TCJSONCodable"))
        }
    }
    
    func testExtendedTCJSONCodable() {
        generate("ExtendedTCJSONCodable", options: [
            "child",
            "-i",
            bigJsonPath,
            "--tcjson",
            "--extended-codable"
        ]) { string in
            XCTAssert(string
                .contains("init?(json: [String: Any]) {"))
            XCTAssert(string
                .contains(": TCJSONCodable"))
        }
    }
    
    func testFinalClassTCJSON() {
        generate("FinalClassTCJSON", options: [
            "child",
            "-i",
            bigJsonPath,
            "--tcjson",
            "--model-type",
            "class"
        ]) { string in
            XCTAssert(string
                .contains("final "))
            XCTAssert(string
                .contains(": TCJSONCodable"))
        }
    }
    
//    func testRealmJson() {
//        do {
//            print("\n\n-----\n\n")
//            defer { print("\n\n-----\n\n") }
//
//            var out: XCTAttachment? = nil
//
//            try runner.run(
//                ["child",
//                 "-i",
//                 bigJsonPath,
//                 "--realm"],
//                diagnostic: { print($0) }) {
//                    out = XCTAttachment.init(string: $0)
//                    out?.lifetime = .keepAlways
//                    out?.name = "Realm JSON.txt"
//                    self.add(out!)
//            }
//
//            XCTAssertNotNil(out)
//        } catch {
//            XCTFail(error.localizedDescription)
//        }
//    }

    fileprivate func generate(_ title: String, options: [String], _ tests: (String) -> ()) {
        do {
            var outputString: String? = nil
            
            try runner.runCommandLine(options) { outputString = $0 }
            
            XCTAssertNotNil(outputString)
            
            guard let string = outputString else { return }
            
            tests(string)
            
            let out = XCTAttachment.init(string: string)
            out.lifetime = .keepAlways
            out.name = title + ".txt"
            self.add(out)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
