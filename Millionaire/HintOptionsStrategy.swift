//
//  HintOptionsStrategy.swift
//  Millionaire
//
//  Created by Stanislav Slipchenko on 12.05.2020.
//  Copyright © 2020 Stanislav Slipchenko. All rights reserved.
//

import UIKit

protocol HintOptionsStrategy {
    func hintOptionsViewDidLoad(button: inout UIButton)
    func hintOptionsByTap(button: inout UIButton)
}

struct NoHintsStrategy: HintOptionsStrategy {
    func hintOptionsViewDidLoad(button: inout UIButton) {
        
        button.isEnabled = false
    }
    
    func hintOptionsByTap(button: inout UIButton) {
        print("can't tap the disable button")
    }
}

struct OneTimeHintsStrategy: HintOptionsStrategy {
    
    func hintOptionsViewDidLoad(button: inout UIButton) {
        guard let isHint50 = Game.shared.isHint50Used?.hint,
        let isFriendHint = Game.shared.isFriendCallUsed?.hint,
        let isHallHint = Game.shared.isHallHelpUsed?.hint else {return}

        switch button.backgroundImage(for: .normal) {
        case UIImage(named: "50_50"):
            button.isEnabled = !isHint50
        case UIImage(named: "telephone"):
            button.isEnabled = !isFriendHint
        case UIImage(named: "people"):
            button.isEnabled = !isHallHint
        default:
            break
        }
    }
    
    func hintOptionsByTap(button: inout UIButton) {
        switch button.backgroundImage(for: .normal) {
        case UIImage(named: "50_50"):
            Game.shared.isHint50Used?.hint = false
        case UIImage(named: "telephone"):
            Game.shared.isFriendCallUsed?.hint = false
        case UIImage(named: "people"):
            Game.shared.isHallHelpUsed?.hint = false
        default:
            break
        }
        button.isEnabled = false
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


