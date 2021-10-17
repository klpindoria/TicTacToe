//
//  Move.swift
//  tictactoe
//
//  Created by Ketan Pindoria on 17/10/2021.
//

import Foundation

enum Player {
    case human, computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
}
