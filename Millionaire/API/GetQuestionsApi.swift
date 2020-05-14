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
            guard let data = response.data else {
                completionHandler(false)
                return }
            
            guard let questionsData = try? JSONDecoder().decode(QuestionsApi.self, from: data) else {return completionHandler(false)}
            
            
            let items = questionsData.data
            
            for i in 0..<items.count {
                var question = Question(question: "", answers: [], trueAnswer: "")
                question.question = items[i].question
                print(items[i].question)
                question.trueAnswer = items[i].answers.first!
                
                var answers = Set<String>()
                items[i].answers.map {answers.insert($0)}
                
                question.answers.append(contentsOf: answers)
                Game.shared.questionsArray.insert(question, at: 0)
            }
        }
        completionHandler(true)
    }
}

