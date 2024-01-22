//
//  SwiftUIView.swift
//  
//
//  Created by Rodney Dyer on 1/22/24.
//

import SwiftUI

struct SwiftUIView: View {
    let matrix: Matrix
    var columns: [GridItem] {
        var ret = [GridItem]()
        
        /// Row Label
        ret.append( GridItem(.flexible() ) )
        
        /// One for each column
        ret.append(contentsOf: Array(repeating: GridItem(.flexible(minimum: 75.0)), count: matrix.rows))
        return ret
    }
    
    var body: some View {
        ScrollView( [.horizontal, .vertical]) {
            LazyVGrid(columns: columns) {
                
                // Header Row
                Text("")
                ForEach( matrix.colNames, id: \.self ){ label in
                    Text("\(label)")
                }
            }
        }
    }
}

#Preview {
    SwiftUIView(matrix: Matrix.DefaultMatrix )
}

