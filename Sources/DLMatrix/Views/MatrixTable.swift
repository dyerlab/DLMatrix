//
//  SwiftUIView.swift
//
//
//  Created by Rodney Dyer on 1/22/24.
//

import SwiftUI

struct SwiftUIView: View {
    let matrix: Matrix
    var numDigits: Int = 1
    
    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            Grid {
                
                GridRow {
                    Text("")
                    ForEach( 0 ..< matrix.cols, id: \.self){ col in
                        Text("\(matrix.colNames[col])")
                            .bold()
                            .gridColumnAlignment(.trailing)
                    }
                }
                
                
                ForEach( 0 ..< matrix.rows, id: \.self ){ row in
                    GridRow {
                        Text("\(matrix.rowNames[row])")
                            .bold()
                        ForEach( 0 ..< matrix.cols, id: \.self){ col in
                            Text(String(format: "%0.\(numDigits)f", matrix[row,col]))
                                .gridColumnAlignment(.trailing)
                        }
                    }
                }
            }
            .padding()
        }
    }
}


#Preview {
    SwiftUIView(matrix: Matrix.DefaultMatrixLarge )
}


