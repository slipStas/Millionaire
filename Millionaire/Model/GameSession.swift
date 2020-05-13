//
//  GameSession.swift
//  Millionaire
//
//  Created by Stanislav Slipchenko on 08.05.2020.
//  Copyright © 2020 Stanislav Slipchenko. All rights reserved.
//

import Foundation

class GameSession: Codable {
    
    @objc dynamic var date: Date
    @objc dynamic var value: Int 
    
    init(date: Date, value: Int) {
        self.date = date
        self.value = value
    }
}
