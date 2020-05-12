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
        switch button.titleLabel?.text {
        case "help50":
            button.isEnabled = Game.shared.isHint50Used?.hint ?? false
        case "callFriend":
            button.isEnabled = Game.shared.isFriendCallUsed?.hint ?? false
        case "hallHelp":
            button.isEnabled = Game.shared.isHallHelpUsed?.hint ?? false
        default:
            break
        }
        //button.isEnabled = Game.shared.isHint50Used?.hint ?? false
    }
    
    func hintOptionsByTap(button: inout UIButton) {
        switch button.titleLabel?.text {
        case "help50":
            button.isEnabled = Game.shared.isHint50Used?.hint ?? false
        case "callFriend":
            button.isEnabled = Game.shared.isFriendCallUsed?.hint ?? false
        case "hallHelp":
            button.isEnabled = Game.shared.isHallHelpUsed?.hint ?? false
        default:
            break
        }
        //button.isEnabled = Game.shared.isHint50Used?.hint ?? false
    }
}

struct OneTimeHintsStrategy: HintOptionsStrategy {
    func hintOptionsViewDidLoad(button: inout UIButton) {
        switch button.titleLabel?.text {
        case "help50":
            button.isEnabled = Game.shared.isHint50Used?.hint ?? false
        case "callFriend":
            button.isEnabled = Game.shared.isFriendCallUsed?.hint ?? false
        case "hallHelp":
            button.isEnabled = Game.shared.isHallHelpUsed?.hint ?? false
        default:
            break
        }
        //button.isEnabled = Game.shared.isHint50Used?.hint ?? false
    }
    
    func hintOptionsByTap(button: inout UIButton) {
        switch button.titleLabel?.text {
        case "help50":
            Game.shared.isHint50Used?.hint = false
        case "callFriend":
            Game.shared.isFriendCallUsed?.hint = false
        case "hallHelp":
            Game.shared.isHallHelpUsed?.hint = false
        default:
            break
        }
        
        //Game.shared.isHint50Used?.hint = false
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


