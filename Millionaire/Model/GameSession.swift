//
//  GameSession.swift
//  Millionaire
//
//  Created by Stanislav Slipchenko on 08.05.2020.
//  Copyright © 2020 Stanislav Slipchenko. All rights reserved.
//

import Foundation

class GameSession: Codable {
    
    var date: Date
    var value: String
    
    init(date: Date, value: String) {
        self.date = date
        self.value = value
    }
}
