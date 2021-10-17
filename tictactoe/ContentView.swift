//
//  ContentView.swift
//  tictactoe
//
//  Created by Ketan Pindoria on 17/10/2021.
//

import SwiftUI

struct ContentView: View {
    
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    // Create moves array filled with 9 nils - for tracking player selection
    @State private var moves: [Move?] = Array(repeating: nil, count: 9)
    
    //Temp State for testing purposes
    @State private var isHumanTurn = true
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                LazyVGrid(columns: columns, spacing: 5) {
                    ForEach(0..<9) { i in
                        ZStack {
                            Circle()
                                .foregroundColor(.blue).opacity(0.8)
                                .frame(width: geometry.size.width/3-15,
                                       height: geometry.size.width/3-15)
                            // Change image based on player
                            Image(systemName: moves[i]?.indicator ?? "")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                    
                        }
                        // Set X or O on player click & toggle between human & computer
                        .onTapGesture {
                            if isCircleOccupied(in: moves, forIndex: i) { return }
                            moves[i] = Move(player: isHumanTurn ? .human : .computer, boardIndex: i)
                            isHumanTurn.toggle()
                        }
                    }
                }
                Spacer()
            }
            .padding()
        }
    }
    
    // Check if grid position is taken by player
    func isCircleOccupied(in moves: [Move?], forIndex index: Int)->Bool{
        return moves.contains(where: { $0?.boardIndex == index})
    }
    
    func determineComputerMovePosition(in moves: [Move?]) -> Int {
        // Easy computer mode - set random position
        var movePosition = Int.random(in: 0..<9)
        // Keep setting another random position if already occupied
        while isCircleOccupied(in: moves, forIndex: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        
        return movePosition
    }
}

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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
