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
            Game.shared.defaults.setValue(0, forKey: "difficulty")
        case 1:
            Game.shared.defaults.setValue(1, forKey: "difficulty")
        case 2:
            Game.shared.defaults.setValue(2, forKey: "difficulty")
        default:
            break
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hintsSegmetnControl.selectedSegmentIndex = Game.shared.defaults.integer(forKey: "difficulty")
    }
}
