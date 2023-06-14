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
//  MatrixTests.swift
//  Tests macOS
//
//  Created by Rodney Dyer on 6/7/21.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.

import CoreGraphics
import SceneKit
import XCTest

@testable import DLMatrix

class VectorTests: XCTestCase {
    func testInit() throws {
        let v = Vector(repeating: 2.2, count: 4)

        XCTAssertEqual(v.count, 4)
        XCTAssertEqual(v.sum, 8.8)

        XCTAssertEqual(v[1], 2.2)
        XCTAssertEqual(v.magnitude, sqrt(19.36))
        XCTAssertEqual(v.normal, [0.5, 0.5, 0.5, 0.5])

        let v1 = Vector([1.0, 2.0, 3.0])
        XCTAssertEqual(v1.x, 1.0)
        XCTAssertEqual(v1.y, 2.0)

        XCTAssertEqual(v1.asCGPoint, CGPoint(x: 1.0, y: 2.0))

        let v1svn = v1.asSNCVector3
        XCTAssertEqual(v1svn.x, 1.0)
        XCTAssertEqual(v1svn.y, 2.0)
        XCTAssertEqual(v1svn.z, 3.0)

        let v2 = [-2.3, 2.1, 2.8]
        XCTAssertEqual(v2.limitAnnealingMagnitude(temp: 2.2), [-2.2, 2.1, 2.2])
        XCTAssertEqual(Vector.zeros(3), [0.0, 0.0, 0.0])
    }

    func testOperators() throws {
        let x = [1.0, 2.0, 3.0]
        let y = [3.0, 2.0, 1.0]
        let s = 2.0

        XCTAssertEqual(x + s, [3.0, 4.0, 5.0])
        XCTAssertEqual(x - s, [-1.0, 0.0, 1.0])
        XCTAssertEqual(x * s, [2.0, 4.0, 6.0])
        XCTAssertEqual(x / s, [1.0 / 2.0,
                               2.0 / 2.0,
                               3.0 / 2.0])

        XCTAssertEqual(x + y, [4.0, 4.0, 4.0])
        XCTAssertEqual(x - y, [-2.0, 0.0, 2.0])
        XCTAssertEqual(x * y, [3.0, 4.0, 3.0])
        XCTAssertEqual(x / y, [1.0 / 3.0, 2.0 / 2.0, 3.0 / 1.0])

        XCTAssertEqual(x .* y, 10.0)
        XCTAssertEqual(distance(x, y), sqrt((x - y).map { $0 * $0 }.sum))
    }

    func testRSourceConvertable() throws {
        let x = Vector(repeating: 1.0, count: 10)
        XCTAssertEqual(x.count, 10)

        let r = x.toR()
        XCTAssertFalse(r.isEmpty)
        XCTAssertEqual(r, "c(1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0)")
    }
}
