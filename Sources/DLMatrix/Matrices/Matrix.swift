//
//  Matrix.swift
//                      _                 _       _
//                   __| |_   _  ___ _ __| | __ _| |__
//                  / _` | | | |/ _ \ '__| |/ _` | '_ \
//                 | (_| | |_| |  __/ |  | | (_| | |_) |
//                  \__,_|\__, |\___|_|  |_|\__,_|_.__/
//                        |_ _/
//
//         Making Population Genetic Software That Doesn't Suck
//
//
//  Created by Rodney Dyer on 6/10/21.
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

import Accelerate
import Foundation

/// The base Matrix Class
///
/// This is the base class for 2-dimensinoal matrix data.  It is defined as a row-major matrix and is configured
///  internally to use the `Accelerate` library for
public class Matrix {
    
    /// The storage for the values in the matrix
    var values: Vector
    
    /// Storage for formatting digits on output
    public var digits: [Int]

    /// The number of rows in the matrix
    public var rows: Int {
        return rowNames.count
    }

    /// The number of columns in the matrix
    public var cols: Int {
        return colNames.count
    }

    /// The Row Cames
    public var rowNames: [String]

    /// The Column Names
    public var colNames: [String]

    /// Grab the diagonal of the matrix
    public var diagonal: Vector {
        get {
            let mn = min(rows, cols)
            var ret = Vector(repeating: .nan, count: mn)
            for i in 0 ..< mn {
                ret[i] = values[(i * cols) + i]
            }
            return ret
        }
        set {
            let mx = min(min(rows, cols), newValue.count)
            for i in 0 ..< mx {
                self[i, i] = newValue[i]
            }
        }
    }

    /// Matrix Trace
    public var trace: Double {
        return diagonal.sum
    }

    /// Grab the sum of the entire matrix
    public var sum: Double {
        return values.sum
    }

    /// Return the sum of the rows
    public var rowSum: Vector {
        let ones = Matrix(cols, 1, 1.0)
        let V = self .* ones
        return V.values
    }

    /// Returns sum of columns
    public var colSum: Vector {
        let ones = Matrix(1, rows, 1.0)
        let V = ones .* self
        return V.values
    }

    /// Returns matrix of rowsums, for colsums take transpose first
    public var rowMatrix: Matrix {
        let v = rowSum
        let X = Matrix(rows, cols)
        for i in 0 ..< rows {
            for j in 0 ..< cols {
                X[i, j] = v[j]
            }
        }
        return X
    }

    /// Returns matrix as covariance type
    public var asCovariance: Matrix {
        let K = Double(rows)
        let D1: Matrix = rowMatrix.transpose
        let D2: Matrix = rowMatrix
        let D: Matrix = (D1 + D2) / K
        let rhs = sum / pow(K, 2.0)
        return (self * -1.0 + D - rhs) * 0.5
    }

    /// Converts from covariance to distance
    public var asDistance: Matrix {
        let K = rows
        let D = Matrix(K, K, 0.0)
        for i in 0 ..< K {
            for j in 0 ..< K {
                D[i, j] = self[i, i] + self[j, j] - self[i, j] * 2.0
            }
        }
        return D
    }

    /// The tanspose of the matrix
    public var transpose: Matrix {
        let ret = Matrix(cols, rows, 0.0)
        vDSP_mtransD(values, 1, &ret.values, 1, vDSP_Length(cols), vDSP_Length(rows))
        return ret
    }

    /// Overload of the subscript operator
    ///
    /// This assumes that the matrix is row-major and starts with 0.
    /// - Parameters:
    ///  - r: The row
    ///  - c: The column
    /// - Returns: The value at the specific index.
    public subscript(_ r: Int, _ c: Int) -> Double {
        get {
            if !areValidIndices(r, c) {
                return .nan
            }
            return values[(r * cols) + c]
        }
        set {
            if areValidIndices(r, c) {
                values[(r * cols) + c] = newValue
            }
        }
    }

    /// Default Intitializer for matrix
    ///
    /// This initializer makes an empty matrix with specified number of rows and columns
    /// - Parameters:
    ///   - r: The number of Rows
    ///   - c: The number of Columns
    ///   - value: The value to populate the matrix with (default=0.0)
    /// - Returns: Matrix of 0 values of size rxc
    public init(_ r: Int, _ c: Int, _ value: Double = 0.0) {
        values = Vector(repeating: value, count: r * c)
        rowNames = Array(repeating: "", count: r)
        colNames = Array(repeating: "", count: c)
        digits = Array(repeating:4, count: c )
    }

    /// Intitializer for matrix based upon vector of values
    ///
    /// This initializer makes an empty matrix with specified number of rows and columns.  This fills the matrix up **by row**
    ///  and not by columns.  If you want **bycol** then you must manually **transpose** the result.
    /// - Parameters:
    ///   - r: The number of Rows
    ///   - c: The number of Columns
    ///   - values: The value to populate the matrix with (default=0.0)
    /// - Returns: A  matrix of size rxc with values set by the vector you passed to it.
    public init(_ r: Int, _ c: Int, _ vec: Vector) {
        if vec.count == 0 || r * c != vec.count {
            values = [Double]()
        } else {
            values = vec
        }
        rowNames = Array(repeating: "", count: r)
        colNames = Array(repeating: "", count: c)
        digits = Array(repeating:4, count: c )
    }

    /// Intitializer for matrix based upon vector of values
    ///
    /// This initializer makes an empty matrix with specified number of rows and columns based upon a defined sequence.
    /// - Parameters:
    ///   - r: The number of Rows
    ///   - c: The number of Columns
    ///   - seq: A swift sequence to use
    /// - Returns: A  matrix of size rxc whose values are given in the sequence `seq`
    public init(_ r: Int, _ c: Int, _ seq: ClosedRange<Double>) {
        let steps = Double(r * c) - 1.0
        let unit = (seq.upperBound - seq.lowerBound) / steps
        let vec = Array(stride(from: seq.lowerBound,
                               through: seq.upperBound,
                               by: unit))

        values = vec
        rowNames = Array(repeating: "", count: r)
        colNames = Array(repeating: "", count: c)
        digits = Array(repeating:4, count: c )
    }

    /// Intitializer for matrix based upon vector of values
    ///
    /// This initializer makes an empty matrix with specified number of rows and columns.  This fills the matrix up **by row**
    ///  and not by columns.  If you want **bycol** then you must manually **transpose** the result.
    /// - Parameters:
    ///   - r: The number of Rows
    ///   - c: The number of Columns
    ///   - rowNames: A vector of string values for row names
    ///   - colNames: A string vector of names for the columns.
    ///   - values: The value to populate the matrix with (default=0.0)
    /// - Returns: A zero matrix of size rxc with set row and column names.
    public init(_ r: Int, _ c: Int, _ rowNames: [String], _ colNames: [String]) {
        values = Vector(repeating: 0.0, count: r * c)
        self.rowNames = rowNames
        self.colNames = colNames
        digits = Array(repeating:4, count: c )
    }

    /// Grab a row as a vector
    public func getRow(r: Int) -> Vector {
        var ret = Vector(repeating: 0.0, count: cols)
        for c in 0 ..< cols {
            ret[c] = self[r, c]
        }
        return ret
    }

    /// Grab a column as a vector
    public func getCol(c: Int) -> Vector {
        var ret = Vector(repeating: 0.0, count: rows)
        for r in 0 ..< rows {
            ret[r] = self[r, c]
        }
        return ret
    }

    
    /// Returns value formatted with the specific number of digits for printing externally
    public func formattedValue(r: Int, c: Int) -> String {
        return self[r,c].formatted(.number.precision(.fractionLength( digits[c] )))
    }
    
    
    /// An internal function to check the indices to see if they will work properly
    internal func areValidIndices(_ r: Int, _ c: Int) -> Bool {
        return r >= 0 && c >= 0 && r < rows && c < cols
    }
}

// MARK: - Protocols

extension Matrix: Equatable {
    /// Equality Operator overload
    /// - Parameters:
    ///   - lhs: The left matrix
    ///   - rhs: The right matrix
    /// - Returns: Returns a `Bool` indicating element-wise equality and shape of the two matrices
    public static func == (lhs: Matrix, rhs: Matrix) -> Bool {
        return lhs.values == rhs.values &&
            lhs.rows == rhs.rows &&
            lhs.cols == rhs.cols &&
            lhs.rowNames == rhs.rowNames &&
            lhs.colNames == rhs.colNames
    }
}

// MARK: - Conforms to the Printing Protocol

extension Matrix: CustomStringConvertible {
    
    /// Dumps matrix to string
    public var description: String {
        var ret = String("Matrix: (\(rows) x \(cols))")
        ret += "\n[\n"

        for r in 0 ..< rows {
            ret += String(" \(rowNames[r]) ")

            for c in 0 ..< cols {
                ret += String(" \(formattedValue(r: r, c: c))")
            }
            ret += "\n"
        }
        ret += "]\n"
        return ret
    }
}

// MARK: - Algebraic Operations

public extension Matrix {
    
    /// Centers all elements of the matrix on colMean
    func center() {
        let µ = colSum / Double(rows)
        for i in 0 ..< rows {
            for j in 0 ..< cols {
                self[i, j] = self[i, j] - µ[j]
            }
        }
    }
    
    
    
    /// Extract submatrices from an existing matrix
    func submatrix(_ r: [Int], _ c: [Int]) -> Matrix {
        let ret = Matrix(r.count, c.count, 0.0)
        for i in 0 ..< r.count {
            for j in 0 ..< c.count {
                ret[i, j] = self[r[i], c[j]]
            }
        }
        return ret
    }
}

public extension Matrix {
    
    /// Default Matrix
    ///
    /// Just a default matrix with some values in it
    static var DefaultMatrix: Matrix {
        let vals = Vector([ 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0 ])
        let X = Matrix(3, 5, vals )
        X.rowNames = ["Row 1", "Row 2", "Row 3"]
        X.colNames = ["Col 1", "Col 2", "Col 3", "Col 4", "Col 5"]
        return X
    }
    
    
    
    /// Identity Matrix
    ///
    /// - Returns: NxN matrix with diagonal of 1 and 0 elsewhere.
    static func Identity( N: Int ) -> Matrix {
        let I = Matrix(N,N,0.0)
        for i in 0 ..< N {
            I[i,i] = 1.0
        }
        return I
    }
    
    /// Design matrix
    ///
    /// Creates a generic design matrix as [
    /// - Parameters:
    ///     - strata: A string vector of strata names
    /// - Returns: An NxK matrix of `[0,1]` values where each column indexes the values in the strata vector for the column associated with that stratum.
    static func DesignMatrix(strata: [String]) -> Matrix {
        let r = strata.count
        let colNames = [String](Set<String>(strata)).sorted()
        let X = Matrix(r, colNames.count, 0.0)

        for i in 0 ..< r {
            if let c = colNames.firstIndex(where: { $0 == strata[i] }) {
                X[i, c] = 1.0
            }
        }
        return X
    }

    /// Idempotent Hypothesis Matrix for Strata
    ///
    /// This matrix creates a N x N idempotent Hat matrix **H** from a vector of strata names.  This H matrix is determined by taking the `DesignMatrix()` object X and transformatin it as $H = X * (X'X)^{-1} * X^{-1}$.
    /// - Parameters:
    ///     - strata: A string vector of strata names
    /// - Returns: An NxN matrix of `[0,1]` values where each column indexes the values in the strata vector for the column associated with that stratum.
    static func IdempotentHatMatrix(strata: [String]) -> Matrix {
        let X = Matrix.DesignMatrix(strata: strata)
        let H = X .* GeneralizedInverse(X.transpose .* X) .* X.transpose
        return H
    }
}

extension Matrix: rSourceConvertible {
    /// This converts the matrix to an R object.  If the matrix has column names then it will be made into a tibble else, it will be made into a matrix.
    public func toR() -> String {
        var ret = [String]()

        let hasColNames = !colNames.compactMap { $0.isEmpty }.allSatisfy { $0 }

        if hasColNames { // Result will be tibble
            ret.append("tibble(")

            // If there are rownames, put them in as Key
            if !rowNames.compactMap({ $0.isEmpty }).allSatisfy({ $0 }) {
                var vals = String("  Key = c(")
                vals += rowNames.map { String("'\($0)'") }.joined(separator: ", ")
                vals += "),"
                ret.append(vals)
            }

            for i in 0 ..< colNames.count {
                let name = colNames[i]
                var vals = String("  \(name) = ")
                vals += getCol(c: i).toR()
                if i < (colNames.count - 1) {
                    vals += ","
                }
                ret.append(vals)
            }

            ret.append(")")
            return ret.joined(separator: "\n")
        } else { // Result is Matrix
            var vals = "matrix( c("
            vals += values.compactMap { String("\($0)") }.joined(separator: ",")
            vals += String("), ncol=\(cols), nrow=\(rows), byrow=TRUE)")
            return vals
        }
    }
}




