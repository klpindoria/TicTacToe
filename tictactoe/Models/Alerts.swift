//
//  Alerts.swift
//  tictactoe
//
//  Created by Ketan Pindoria on 17/10/2021.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let humanWin = AlertItem(title: Text("You Won!"),
                                    message: Text("Well done you have won against the computer"),
                                    buttonTitle: Text("Awesome Stuff!"))
    
    static let computerWin = AlertItem(title: Text("You Lost!"),
                                       message: Text("Better luck next time you lost against the computer"),
                                       buttonTitle: Text("Try Again!"))
    
    static let draw = AlertItem(title: Text("It's a Draw!"),
                                message: Text("Seems you have tied with the computer"),
                                buttonTitle: Text("Almost there!"))
}
