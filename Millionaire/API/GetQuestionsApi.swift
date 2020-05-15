//
//  GetQuestionsApi.swift
//  Millionaire
//
//  Created by Stanislav Slipchenko on 14.05.2020.
//  Copyright © 2020 Stanislav Slipchenko. All rights reserved.
//

import Foundation
import Alamofire

enum QuestionDifficulty: String {
    case child = "4"
    case low = "1"
    case medium = "2"
    case hard = "3"
}

class GetQuestionsApi {
    
    var getQuestions: QuestionsApi?
    
    func getQuestions(questionDifficulty difficulty: QuestionDifficulty, completionHandler: @escaping(Bool) -> ()) {
        var question = Question(question: "", answers: [], trueAnswer: "")
        var urlLiteQuestions = URLComponents()
        urlLiteQuestions.scheme = "https"
        urlLiteQuestions.host = "engine.lifeis.porn"
        urlLiteQuestions.path = "/api/millionaire.php"
        urlLiteQuestions.queryItems = [
            URLQueryItem(name: "qType", value: difficulty.rawValue),
            URLQueryItem(name: "count", value: "5"),
        ]
        
        guard let url = urlLiteQuestions.url else {return}
        
        AF.request(url).responseData { response in
            guard let data = response.data else {return completionHandler(false)}
            guard let questionsData = try? JSONDecoder().decode(QuestionsApi.self, from: data) else {return completionHandler(false)}
            
            let items = questionsData.data
            
            for i in 0..<items.count {
                question.question = items[i].question
                question.trueAnswer = items[i].answers.first!
                /// Mix the answers
                var answersSet = Set<String>()
                items[i].answers.map {answersSet.insert($0)}
                
                question.answers.append(contentsOf: answersSet)
                
                switch difficulty {
                case .child:
                    Game.shared.questionsArrayChild.append(question)
                case .medium:
                    print("add medium")
                    Game.shared.questionsArrayMedium.append(question)
                case .hard:
                    Game.shared.questionsArrayHard.append(question)
                default:
                    break
                }
                question.answers.removeAll()
            }
        }
        completionHandler(true)
    }
}

