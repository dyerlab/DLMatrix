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
//  Closeness.swift
//
//  Created by Rodney Dyer on 11/5/23.
//

import Foundation

/**
 Node Closeness Centrality.
 
 Closeness is defined as the reciprocal of the sum of the length of the shortest paths between the node and all other nodes in the graph. Thus, the more central a node is, the closer it is to all other nodes.
 
 - Parameters:
    - A: An adjacency Matrix
 - Returns: A ``Vector`` of node betweeness values, ordered in the same way as the adjacency matrix.
 */
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
