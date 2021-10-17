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
    @State private var isBoardDisabled = false
    @State private var alertItem: AlertItem?
    
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
                            // Register human tap and assign to Move[] array
                            if isCircleOccupied(in: moves, forIndex: i) { return }
                            moves[i] = Move(player: .human, boardIndex: i)
                                                                                   
                            //checking for win or draw scenario
                            if checkWinScenario(for: .human, in: moves) {
                                alertItem = AlertContext.humanWin
                                return
                            }
                            
                            if checkDrawScenario(in: moves) {
                                alertItem = AlertContext.draw
                                return
                            }
                            
                            //prevent human from clicking another circle before computers move
                            isBoardDisabled = true
                            
                            // Auto-play computer move and assign to Move[] array
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                let computerPosition = determineComputerMovePosition(in: moves)
                                moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
                                isBoardDisabled = false
                                
                                //checking for win or draw scenario
                                if checkWinScenario(for: .computer, in: moves) {
                                    alertItem = AlertContext.computerWin
                                    return
                                }
                                
                                if checkDrawScenario(in: moves) {
                                    alertItem = AlertContext.draw
                                    return
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
            .padding()
            .disabled(isBoardDisabled)
            .alert(item: $alertItem, content: { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: .default(alertItem.buttonTitle, action: { resetGame() }))
            })
        }
    }
    
    // Check if grid position is taken by player
    func isCircleOccupied(in moves: [Move?], forIndex index: Int)->Bool{
        return moves.contains(where: { $0?.boardIndex == index})
    }
    
    //If Comp can win, take the win
    //If Comp can't win, then block
    //If Comp can't block, then take the middle
    //If Comp can't take middle, take any random spot
    func determineComputerMovePosition(in moves: [Move?]) -> Int {
        //If Comp can win, take the win
        let winPatterns: Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        //Check computers current moves taken
        let computerMoves = moves.compactMap { $0 }.filter { $0.player == .computer }
        let computerPosition = Set(computerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(computerPosition)
            
            if winPositions.count == 1 {
                let isSpotAvailable = !isCircleOccupied(in: moves, forIndex: winPositions.first!)
                if isSpotAvailable { return winPositions.first! }
            }
        }
        
        //If Comp can't win, then block
        let humanMoves = moves.compactMap { $0 }.filter { $0.player == .human }
        let humanPosition = Set(humanMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(humanPosition)
            
            if winPositions.count == 1 {
                let isSpotAvailable = !isCircleOccupied(in: moves, forIndex: winPositions.first!)
                if isSpotAvailable { return winPositions.first! }
            }
        }
        
        //If Comp can't block, then take the middle
        let centerCircle = 4
        if !isCircleOccupied(in: moves, forIndex: centerCircle) {
            return centerCircle
        }
        
        // Easy computer mode - set random position
        var movePosition = Int.random(in: 0..<9)
        
        // Keep setting another random position if already occupied
        while isCircleOccupied(in: moves, forIndex: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        
        return movePosition
    }
    
    func checkWinScenario(for player: Player, in moves: [Move?]) -> Bool {
        let winPatterns: Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        
        // if player has following win pattern then they have won
        // find position of moves for player which we pass in parameter
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        
        //filter set to show only boardIndex for above player
        let playerPosition = Set(playerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns where pattern.isSubset(of: playerPosition){ return true }
        
        return false
    }
    
    func checkDrawScenario(in moves: [Move?]) -> Bool {
        return moves.compactMap { $0 }.count == 9
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
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
