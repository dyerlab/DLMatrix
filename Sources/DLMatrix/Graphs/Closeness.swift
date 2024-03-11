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
//  ClosenessCentrality.swift
//  popgraph
//
//  Created by Rodney Dyer on 11/5/23.
//

import Foundation

public func Closeness( A: Matrix ) -> Vector {
    let N = A.rows
    var ret = Vector( repeating: 0.0, count: N)
    let D = ShortestPaths(A: A )
    
    for i in 0 ..< N {
        for j in 0 ..< N {
            if !D[i,j].isNaN && i != j {
                ret[i] = D[i,j] + ret[i]
            }
        }
    }
    return ret
}
