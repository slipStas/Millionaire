//
//  GameSingletone.swift
//  Millionaire
//
//  Created by Stanislav Slipchenko on 08.05.2020.
//  Copyright © 2020 Stanislav Slipchenko. All rights reserved.
//

import Foundation

enum Hints {
    case isHint50Used
    case isFriendCallUsed
    case isHallHelpUsed
}

class HintsUsed {
    var hint: Bool?
    var hintUsed: Hints?
}

public class Game {
    static let shared = Game()
    
    var gameSession : GameSession?
    
    var isHint50Used : HintsUsed?
    var isFriendCallUsed : HintsUsed?
    var isHallHelpUsed : HintsUsed?
    
    var orderOfQuestions: OrderOfQuestions?
    var hintsSettings: HintsSettings?
    
    private init() {}
}
