//
//  HintOptionsStrategy.swift
//  Millionaire
//
//  Created by Stanislav Slipchenko on 12.05.2020.
//  Copyright © 2020 Stanislav Slipchenko. All rights reserved.
//

import UIKit

protocol HintOptionsStrategy {
    func hintOptionsViewDidLoad(button: UIButton) -> UIButton
    func hintOptionsByTap(button: UIButton) -> UIButton
}

struct NoHintsStrategy: HintOptionsStrategy {
    func hintOptionsViewDidLoad(button: UIButton) -> UIButton {
        let returnedButton = button
        returnedButton.isEnabled = false
        
        return returnedButton
    }
    
    func hintOptionsByTap(button: UIButton) -> UIButton {
        let returnedButton = button
        print("can't tap the disable button")
        
        return returnedButton
    }
}

struct OneTimeHintsStrategy: HintOptionsStrategy {
    
    func hintOptionsViewDidLoad(button: UIButton) -> UIButton {
        let returnedButton = button
        
        guard let isHint50 = Game.shared.isHint50Used?.hint,
            let isFriendHint = Game.shared.isFriendCallUsed?.hint,
            let isHallHint = Game.shared.isHallHelpUsed?.hint else {return returnedButton}

        switch returnedButton.backgroundImage(for: .normal) {
        case UIImage(named: "50_50"):
            returnedButton.isEnabled = !isHint50
        case UIImage(named: "telephone"):
            returnedButton.isEnabled = !isFriendHint
        case UIImage(named: "people"):
            returnedButton.isEnabled = !isHallHint
        default:
            break
        }
        return returnedButton
    }
    
    func hintOptionsByTap(button: UIButton) -> UIButton {
        let returnedButton = button

        switch returnedButton.backgroundImage(for: .normal) {
        case UIImage(named: "50_50"):
            Game.shared.isHint50Used?.hint = false
        case UIImage(named: "telephone"):
            Game.shared.isFriendCallUsed?.hint = false
        case UIImage(named: "people"):
            Game.shared.isHallHelpUsed?.hint = false
        default:
            break
        }
        returnedButton.isEnabled = false
        return returnedButton
    }
}

struct InfinitelyHintsStrategy: HintOptionsStrategy {
    func hintOptionsViewDidLoad(button: UIButton) -> UIButton {
        let returnedButton = button
        returnedButton.isEnabled = true
        
        return returnedButton
    }
    
    func hintOptionsByTap(button: UIButton) -> UIButton {
        let returnedButton = button
        returnedButton.isEnabled = false
        
        return returnedButton
    }
}


