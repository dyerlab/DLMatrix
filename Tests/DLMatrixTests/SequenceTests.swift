//
//  dyerlab.org                                          @dyerlab
//                      _                 _       _
//                   __| |_   _  ___ _ __| | __ _| |__
//                  / _` | | | |/ _ \ '__| |/ _` | '_ \
//                 | (_| | |_| |  __/ |  | | (_| | |_) |
//                  \__,_|\__, |\___|_|  |_|\__,_|_.__/
//                        |_ _/
//
//         Making Population Genetic Software That Doesn't Suck
//
//  SequenceTests.swift
//  
//
//  Created by Rodney Dyer on 6/2/22.
//

import XCTest
@testable import DLMatrix

class SequenceTests: XCTestCase {

    func testUniqueExtension() throws {
        let array = ["A","A","B","B","B","C"]
        
        let u = array.unique()
        XCTAssertEqual( u, ["A","B","C"])
        
    }
    
    func testHistogramExtension() throws {
        let array = ["A","A","B","B","B","C"]
        let h = array.histogram()
        
        XCTAssertEqual( h, ["A":2,"B":3,"C":1])
    }

}
