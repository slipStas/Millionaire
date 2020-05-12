//
//  HintOptionsStrategy.swift
//  Millionaire
//
//  Created by Stanislav Slipchenko on 12.05.2020.
//  Copyright © 2020 Stanislav Slipchenko. All rights reserved.
//

import UIKit

protocol HintOptionsStrategy {
    func hintOptionsByTap(button: inout UIButton)
    func hintOptionsViewDidLoad(button: inout UIButton)
}

struct NoHintsStrategy: HintOptionsStrategy {
    func hintOptionsViewDidLoad(button: inout UIButton) {
        button.isEnabled = Game.shared.isHint50Used
    }
    
    func hintOptionsByTap(button: inout UIButton) {
        button.isEnabled = Game.shared.isHint50Used
    }
}

struct OneTimeHintsStrategy: HintOptionsStrategy {
    func hintOptionsViewDidLoad(button: inout UIButton) {
        button.isEnabled = Game.shared.isHint50Used
    }
    
    func hintOptionsByTap(button: inout UIButton) {
        Game.shared.isHint50Used = false
        button.isEnabled = Game.shared.isHint50Used
    }
}

struct InfinitelyHintsStrategy: HintOptionsStrategy {
    func hintOptionsViewDidLoad(button: inout UIButton) {
        button.isEnabled = true
    }
    
    func hintOptionsByTap(button: inout UIButton) {
        button.isEnabled = false
    }
}


