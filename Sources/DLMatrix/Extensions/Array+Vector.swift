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
//  Created by Rodney Dyer on 11/2/22.
//

import Foundation

/// Extensions for Arrays of vectors
extension Array where Element == Vector {
    
    /// Mean of each element vector
    ///
    /// This function returns the mean value of each component vector.
    public var centoid: Vector? {
        
        if self.isEmpty {
            return nil
        }
        guard let N = self.first?.count else { return nil }
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
