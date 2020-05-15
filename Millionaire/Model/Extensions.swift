//
//  Extensions.swift
//  Millionaire
//
//  Created by Stanislav Slipchenko on 15.05.2020.
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

extension UIColor {
    static let myOrange = #colorLiteral(red: 1, green: 0.6481617093, blue: 0.1165351197, alpha: 1)
    static let myGray = #colorLiteral(red: 0.7027831674, green: 0.6986073852, blue: 0.705994308, alpha: 1)
}

extension UIImage {
    static let mainBackgroundImage = #imageLiteral(resourceName: "mainBackground")
    static let falseAnswerBackgroundImage = #imageLiteral(resourceName: "mainBackgroundFalse")
    static let trueAnswerBackgroundImage = #imageLiteral(resourceName: "mainBackgroundTrue")
    static let mainBackgroundOrangeImage = #imageLiteral(resourceName: "mainBackgroundOrange")
    static let hint50Image = #imageLiteral(resourceName: "50_50")
    static let hintPeopleImage = #imageLiteral(resourceName: "people")
    static let hintTelephoneImage = #imageLiteral(resourceName: "telephone")
}
