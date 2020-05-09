//
//  Helper.swift
//  Millionaire
//
//  Created by Stanislav Slipchenko on 09.05.2020.
//  Copyright © 2020 Stanislav Slipchenko. All rights reserved.
//

import UIKit

extension UILabel {
    var optimalHeight : CGFloat {
        get {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: CGFloat.greatestFiniteMagnitude - 15))
            label.numberOfLines = 0
            label.lineBreakMode = self.lineBreakMode
            label.font = self.font
            label.text = self.text
            
            label.sizeToFit()
            
            return label.frame.height
        }
    }
}
