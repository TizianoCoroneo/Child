//
//  ChildTests.swift
//  ChildTests
//
//  Created by Tiziano Coroneo on 19/12/2017.
//

import XCTest
@testable import Child
@testable import ChildBrain

class ChildTests: XCTestCase {
    
    var runner: Runner! = Runner()
    
    override func setUp() {
        super.setUp()
        
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
             "/Users/tizianocoroneo/Downloads/Example jsons/DetailReviewResponse.json"],
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
                 "/Users/tizianocoroneo/Downloads/Example jsons/DetailReviewResponse.json",
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
                 "/Users/tizianocoroneo/Downloads/Example jsons/DetailReviewResponse.json",
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
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
