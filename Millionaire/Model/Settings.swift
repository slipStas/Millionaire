//
//  Settings.swift
//  Millionaire
//
//  Created by Stanislav Slipchenko on 11.05.2020.
//  Copyright © 2020 Stanislav Slipchenko. All rights reserved.
//

import Foundation

enum Settings {
    enum OrderOfQuestions: Int {
        case inSeries = 0
        case random = 1
    }

    enum HintsSettings: Int {
        case noHints = 0
        case oneTime = 1
        case infinitely = 2
    }
}

