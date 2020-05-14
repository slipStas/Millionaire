//
//  QuestionsApi.swift
//  Millionaire
//
//  Created by Stanislav Slipchenko on 14.05.2020.
//  Copyright © 2020 Stanislav Slipchenko. All rights reserved.
//

import Foundation

// MARK: - QuestionsApi
class QuestionsApi: Codable {
    let ok: Bool
    let data: [Datum]
    
    init(ok: Bool, data: [Datum]) {
        self.ok = ok
        self.data = data
    }
}

// MARK: - Datum
class Datum: Codable {
    let question: String
    let answers: [String]
    
    init(question: String, answers: [String]) {
        self.question = question
        self.answers = answers
    }
}

