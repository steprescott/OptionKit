//
//  OptionKitTests.swift
//  OptionKitTests
//
//  Created by Salazar, Alexandros on 9/24/14.
//  Copyright (c) 2014 nomothetis. All rights reserved.
//

import Cocoa
import XCTest
import OptionKit

class OptionKitTests: XCTestCase {
    
    func testParserWithNoOption() {
        let parser = OptionParser()
        parser.parse(["--hello"]).map {opts in
            XCTFail("Empty parser should process no options; instead processed: \(opts)")
        }
    }
    
    func testParserWithNoParameterShortOption() {
        let optionDescription = OptionDefinition(trigger:.Short("h"), numberOfParameters:0)
        let parser = OptionParser(flags:[optionDescription])
        let expectedOption = Option(definition:optionDescription)
        
        var params = ["h"]
        switch parser.parse(params) {
        case .Success(let opts):
            XCTAssertEqual(0, opts.value.count, "Nothing should have been parsed.")
        case .Failure(let opts):
            XCTFail("Parsing should have succeeded for parser: \(parser), options: \(opts)")
        }
        
        params = ["-h"]
        switch parser.parse(params) {
        case .Success(let opts):
            XCTAssertEqual(1, opts.value.count, "Nothing should have been parsed.")
            XCTAssertEqual(opts.value.last!, expectedOption, "Incorrect option parsed.")
        case .Failure(let err):
            XCTFail("Parsing should have succeeded for parser: \(parser), options: \(params)")
        }
        
        params = ["-i"]
        switch parser.parse(params) {
        case .Success(let opts):
            XCTFail("Parsing should not have succeeded for parser: \(parser), options:\(params)")
        case .Failure(let err):
            XCTAssert(true, "Success!")
        }
        
        params = ["-h", "--bad-option"]
        switch parser.parse(params) {
        case .Success(let opts):
            XCTFail("Parsing should not have succeeded for parser: \(parser), options:\(params)")
        case .Failure(let err):
            XCTAssert(true, "Success!")
        }
        
        params = ["-h", "-n"]
        switch parser.parse(params) {
        case .Success(let opts):
            XCTFail("Parsing should not have succeeded for parser: \(parser), options:\(params)")
        case .Failure(let err):
            XCTAssert(true, "Success!")
        }
        
        // Check that order doesn't matter.
        params = ["-h", "lastIsBest"]
        switch parser.parse(params) {
        case .Success(let opts):
            XCTAssertEqual(1, opts.value.count, "Parser \(parser) should have parsed \(params)")
            XCTAssertEqual(opts.value.last!, expectedOption, "Incorrect option parsed.")
        case .Failure(let err):
            XCTAssert(true, "Success!")
        }
        
        params = ["firstRules", "-h"]
        switch parser.parse(params) {
        case .Success(let opts):
            XCTAssertEqual(1, opts.value.count, "Parser \(parser) should have parsed \(params)")
            XCTAssertEqual(opts.value.last!, expectedOption, "Incorrect option parsed.")
        case .Failure(let err):
            XCTAssert(true, "Success!")
        }
        
        params = ["sandwiches", "-h", "rock"]
        switch parser.parse(params) {
        case .Success(let opts):
            XCTAssertEqual(1, opts.value.count, "Parser \(parser) should have parsed \(params)")
            XCTAssertEqual(opts.value.last!, expectedOption, "Incorrect option parsed.")
        case .Failure(let err):
            XCTAssert(true, "Success!")
        }
        
    }
    
}
