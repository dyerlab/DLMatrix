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
//  Betweeness.swift
//
//  Created by Rodney Dyer on 2024-03-11.
//

import Foundation

/**
 Degree centrality is a measure of the number of edges on each node.

 - Parameters:
    - A: An adjacency Matrix
 - Returns: A ``Vector`` with the edge count for each node
 */
public func Degree( A: Matrix ) -> Vector {
    return A.rowSum
}
