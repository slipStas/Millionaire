//
//  GameSceneDelegate.swift
//  Millionaire
//
//  Created by Stanislav Slipchenko on 08.05.2020.
//  Copyright © 2020 Stanislav Slipchenko. All rights reserved.
//

import UIKit

protocol GameSceneDelegate: AnyObject {
    func didEndGame(result: Int)
}
