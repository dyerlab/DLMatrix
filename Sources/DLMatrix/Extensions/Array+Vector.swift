//
//  File.swift
//  
//
//  Created by Rodney Dyer on 11/2/22.
//

import Foundation


extension Array where Element == Vector {
    
    public var centoid: Vector? {
        
        if self.isEmpty {
            return nil
        }
        let N: Int = self.first?.count ?? 0
        if N == 0 { return nil }
        var ret = Vector(repeating: 0.0, count: N)

        
        for item in self {
            for idx in 0 ..< item.count {
                ret[idx] += item[idx]
            }
        }
        
        for idx in 0 ..< ret.count {
            ret[idx] /= Double( N )
        }
        return ret
    }
    
}
