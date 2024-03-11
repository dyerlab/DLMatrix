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
//  Created by Rodney Dyer on 11/5/23.
//

import Foundation
/**
 Node Betweenness Centrality.
 
 For every pair of vertices in a connected graph, there exists at least one shortest path between the vertices such that either the number of edges that the path passes through (for unweighted graphs) or the sum of the weights of the edges (for weighted graphs) is minimized. The betweenness centrality for each vertex is the number of these shortest paths that pass through the vertex.

 - Parameters:
    - A: An adjacency Matrix
 - Returns: A ``Vector`` of node betweeness values, ordered in the same way as the adjacency matrix.
 */
public func Betweenness( A: Matrix ) -> Vector {
    let N = A.rows
    var btwn = Vector(repeating: 0.0, count: N)
    let gMax = A.sum
    let D = Matrix(N,N,0.0)
    
    // Set up the D matrix
    for i in 0 ..< N {
        for j in 0 ..< N {
            if i != j {
                if A[i,j] > 0 {
                    D[i,j] = A[i,j]
                } else {
                    D[i,j] = gMax
                }
            }
        }
    }
    
    // Cycle through the Floyd Warshall and Set btwn
    for k in 0 ..< N {
        for i in 0 ..< N {
            for j in 0 ..< N {
                if i != j && i != k && j != k {
                    let curDist = D[i,j]
                    let newDist = D[i,k] + D[k,j]
                    
                    if curDist < gMax && newDist < gMax {
                        if curDist < newDist {
                            D[i,j] = curDist
                        }
                        else {
                            btwn[k] = btwn[k] + 1.0
                            D[i,j] = newDist
                        }
                    }
                    else if newDist < gMax {
                        D[i,j] = newDist
                    }
                }
            }
        }
    }
    
    btwn = btwn * ((Double(N) - 1.0 ) * ( Double(N) - 2.0 )/2)
    return btwn
}

