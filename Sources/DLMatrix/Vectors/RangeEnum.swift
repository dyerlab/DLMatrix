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
//  DLabMatrix
//  RangeEnum.swift
//
//  Created by Rodney Dyer on 6/29/21.
//  Copyright (c) 2021 The Dyer Laboratory.  All Rights Reserved.
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

/// Categories of ranges for random number generation.
public enum RangeEnum: Int, CaseIterable, Comparable {
    
    /// Uniform distribution from 0 to 1
    case uniform_0_1 = 1
    
    /// Uniform distribution from -1 to +1
    case uniform_neg1_1 = 2
    
    /// Normal distribution from 0 to 1
    case normal_0_1 = 3

    /// Static comparison between cases based upon numerical equivalents.
    public static func < (lhs: RangeEnum, rhs: RangeEnum) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
