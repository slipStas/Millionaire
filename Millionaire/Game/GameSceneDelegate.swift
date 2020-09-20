//
//  GameSceneDelegate.swift
//  Millionaire
//
//  Created by Stanislav Slipchenko on 08.05.2020.
//  Copyright © 2020 Stanislav Slipchenko. All rights reserved.
//

import Foundation

protocol GameSceneDelegate: AnyObject {
    func didEndGame(result: String)
}
