//
//  SettingsViewController.swift
//  Millionaire
//
//  Created by Stanislav Slipchenko on 11.05.2020.
//  Copyright © 2020 Stanislav Slipchenko. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var questionGenerateStrategySegmentControl: UISegmentedControl!
    
    @IBOutlet weak var hintsSegmetnControl: UISegmentedControl!
    
    @IBAction func questionGenerate(_ sender: Any) {
        switch questionGenerateStrategySegmentControl.selectedSegmentIndex {
        case 0:
            Game.shared.orderOfQuestions = .inSeries
        case 1:
            Game.shared.orderOfQuestions = .random
        default:
            break
        }
    }
    @IBAction func hintsSelected(_ sender: Any) {
        switch hintsSegmetnControl.selectedSegmentIndex {
        case 0:
            Game.shared.hintsSettings = .noHints
            Game.shared.isHint50Used = false
        case 1:
            Game.shared.hintsSettings = .oneTime
            Game.shared.isHint50Used = true
        case 2:
            Game.shared.hintsSettings = .infinitely
            Game.shared.isHint50Used = true
        default:
            break
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        questionGenerateStrategySegmentControl.selectedSegmentIndex = Game.shared.orderOfQuestions?.rawValue ?? 0
        hintsSegmetnControl.selectedSegmentIndex = Game.shared.hintsSettings?.rawValue ?? 0
    }
}