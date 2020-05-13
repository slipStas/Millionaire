//
//  MyObservable.swift
//  Millionaire
//
//  Created by Stanislav Slipchenko on 13.05.2020.
//  Copyright © 2020 Stanislav Slipchenko. All rights reserved.
//

import Foundation

class MyObservable: NSObject {
    @objc dynamic var countTrueAnswers: Int
    
    init(countTrueAnswers: Int) {
        self.countTrueAnswers = countTrueAnswers
    }
}
