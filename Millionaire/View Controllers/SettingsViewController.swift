//
//  SettingsViewController.swift
//  Millionaire
//
//  Created by Stanislav Slipchenko on 11.05.2020.
//  Copyright © 2020 Stanislav Slipchenko. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var hintsSegmetnControl: UISegmentedControl!
    
    @IBAction func hintsSelected(_ sender: Any) {
        switch hintsSegmetnControl.selectedSegmentIndex {
        case 0:
            Game.shared.hintsSettings = .noHints
        case 1:
            Game.shared.hintsSettings = .oneTime
        case 2:
            Game.shared.hintsSettings = .infinitely
        default:
            break
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hintsSegmetnControl.selectedSegmentIndex = Game.shared.hintsSettings?.rawValue ?? 0
    }
}
