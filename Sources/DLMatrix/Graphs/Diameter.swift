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
//  Diameter.swift
//
//  Created by Rodney Dyer on 2024-03-11.
//

import Foundation

/**
 Returns the "longest" of all shortest paths through the graph.

 - Parameters:
    - A: An adjacency Matrix
 - Returns: The length of the shortest path with the greatest magnitude.
 */
public func Diameter( A: Matrix ) -> Double {
    let S = ShortestPaths(A: A)
    return S.values.max() ?? 0.0
}

