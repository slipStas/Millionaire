//
//  QuestionSelectionStrategy.swift
//  Millionaire
//
//  Created by Stanislav Slipchenko on 11.05.2020.
//  Copyright © 2020 Stanislav Slipchenko. All rights reserved.
//

import UIKit

protocol QuestionSelectionStrategy {
    func selectionQuestions(questionArray: inout [Question], number: inout Int) -> (Question, Int?)
}

struct SeriesQuestionSelection: QuestionSelectionStrategy {
    func selectionQuestions(questionArray: inout [Question], number: inout Int) -> (Question, Int?) {
        let question = questionArray[number]
        number += 1
        return (question, number)
    }
}

struct RandomQuestionSelection: QuestionSelectionStrategy {
    func selectionQuestions(questionArray: inout [Question], number: inout Int) -> (Question, Int?) {
        let newNumber = Int.random(in: 0...questionArray.count - 1)
        let question = questionArray[newNumber]
        questionArray.remove(at: newNumber)
        return (question, nil)
    }
}
