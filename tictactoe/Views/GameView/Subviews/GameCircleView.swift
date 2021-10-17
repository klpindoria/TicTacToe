//
//  GameCircleView.swift
//  tictactoe
//
//  Created by Ketan Pindoria on 17/10/2021.
//

import SwiftUI

struct GameCircleView: View {
    
    var proxy: GeometryProxy
    
    var body: some View {
        Circle()
            .foregroundColor(.blue).opacity(0.8)
            .frame(width: proxy.size.width/3-15,
                   height: proxy.size.width/3-15)
    }
}
