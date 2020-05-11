//
//  GameSingletone.swift
//  Millionaire
//
//  Created by Stanislav Slipchenko on 08.05.2020.
//  Copyright © 2020 Stanislav Slipchenko. All rights reserved.
//

import Foundation

public class Game {
    static let shared = Game()
    
    var gameSession : GameSession?
    
    var orderOfQuestions: OrderOfQuestions?
    var hintsSettings: HintsSettings?
    
    private init() {}
}
