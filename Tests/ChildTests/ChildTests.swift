//
//  ChildTests.swift
//  ChildTests
//
//  Created by Tiziano Coroneo on 19/12/2017.
//

import XCTest
@testable import ChildBrain

class ChildTests: XCTestCase {
    
    var runner: Runner! = Runner()
    
    var jsonPath: String! = nil
    
    let jsonTest = """

{
    "result": [
        {
            "id": 1,
            "user_id": 2,
            "date_time": "2017-11-14 16:42:29",
            "summary": "Test Description",
            "ratings": {
                "quality": "5",
                "communication": "2",
                "deadline": "3",
                "professionalism": "4",
                "terms_of_payment": "5",
                "project_description": "3"
            },
            "user": {
                "id": 3,
                "first_name": "test-name",
                "last_name": "test-last-name",
                "profile_img": null
            }
        }
    ]
}

"""
    
    override func setUp() {
        super.setUp()
        
        let manager = FileManager.default
        
        let jsonName = "TestJSONModel.json"
        let jsonFolderPath: URL = URL(string: NSTemporaryDirectory())!
        
        jsonPath = jsonFolderPath.appendingPathComponent(jsonName).absoluteString
        
        if manager.fileExists(
            atPath: jsonPath) {
            guard manager.isWritableFile(atPath: jsonPath) else {
                fatalError("File at \(jsonPath) is not writable")
            }
        }
        
        guard manager.createFile(
            atPath: jsonPath,
            contents: jsonTest.data(using: .utf8)!,
            attributes: nil)
            else {
                
                fatalError("Failed creation of file at: \(jsonPath)")
        }
        
        runner = Runner()
    }
    
    override func tearDown() {
        super.tearDown()
        runner = nil
    }
    
    func testBasicInterpet() {
        do {
            print("\n\n-----\n\n")
            defer { print("\n\n-----\n\n") }
            
            try runner.run(
            ["child",
             "-i",
             jsonPath],
            diagnostic: { print($0) }) {
                let out = XCTAttachment.init(string: $0)
                out.lifetime = .keepAlways
                out.name = "Basic.txt"
                self.add(out)
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testCodableInterpet() {
        do {
            print("\n\n-----\n\n")
            defer { print("\n\n-----\n\n") }
            
            try runner.run(
                ["child",
                 "-i",
                 jsonPath,
                 "--codable"],
                diagnostic: { print($0) }) {
                    let out = XCTAttachment.init(string: $0)
                    out.lifetime = .keepAlways
                    out.name = "Codable.txt"
                    self.add(out)
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testExtendedCodableInterpet() {
        do {
            print("\n\n-----\n\n")
            defer { print("\n\n-----\n\n") }
            
            try runner.run(
                ["child",
                 "-i",
                 jsonPath,
                 "--extended-codable"],
                diagnostic: { print($0) }) {
                    let out = XCTAttachment.init(string: $0)
                    out.lifetime = .keepAlways
                    out.name = "Codable.txt"
                    self.add(out)
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
