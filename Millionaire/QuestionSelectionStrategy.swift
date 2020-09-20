//
//  QuestionSelectionStrategy.swift
//  Millionaire
//
//  Created by Stanislav Slipchenko on 11.05.2020.
//  Copyright © 2020 Stanislav Slipchenko. All rights reserved.
//

import UIKit

protocol QuestionSelectionStrategy {
    func selectionQuestions(questionArray: [Question], number: Int) -> (Question, Int, [Question])
}

struct SeriesQuestionSelection: QuestionSelectionStrategy {
    func selectionQuestions(questionArray: [Question], number: Int) -> (Question, Int, [Question]) {
        print("number is - \(number)")
        let question = questionArray[number]
        let numberReturn = number + 1
        return (question, numberReturn, questionArray)
    }
}
