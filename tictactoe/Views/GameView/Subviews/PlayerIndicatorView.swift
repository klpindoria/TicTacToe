//
//  PlayerIndicatorView.swift
//  tictactoe
//
//  Created by Ketan Pindoria on 17/10/2021.
//

import SwiftUI

struct PlayerIndicator: View {
    
    var systemImageName: String
    var body: some View {
        Image(systemName: systemImageName)
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundColor(.white)
    }
}
