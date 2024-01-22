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
//  GeneticStudio
//  Sequence.swift
//
//  Created by Rodney Dyer on 10/27/21.
//  Copyright (c) 2021 Rodney J Dyer.  All Rights Reserved.
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

import Foundation

/// Override to Sequences with Hashable Items
public extension Sequence where Iterator.Element: Hashable {
    /// Returns set of unique items in sequence
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}

/// Extension for array objects to produce a historgram dictionary
public extension Sequence where Element: Hashable {
    
    /// Returns an element count hash of the sequence
    ///
    /// This creates a general 
    func histogram() -> [Element: Int] {
        return reduce(into: [:]) { counts, elem in counts[elem, default: 0] += 1 }
    }
}

