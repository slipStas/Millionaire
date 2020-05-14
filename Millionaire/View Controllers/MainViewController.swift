//
//  MainViewController.swift
//  Millionaire
//
//  Created by Stanislav Slipchenko on 07.05.2020.
//  Copyright © 2020 Stanislav Slipchenko. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    let getQuestions = GetQuestionsApi()
    var isDataLoad = false
    var couldGoNextVC = false
    let difficultyArray : [QuestionDifficulty] = [.hard, .medium, .low]
    
    @IBAction func refreshQuestions(_ sender: Any) {
        isDataLoad = false
        couldGoNextVC = false
        loadQuestions()
    }
    
    func loadQuestions() {
        difficultyArray.map { (item) in
            self.getQuestions.getQuestions(questionDifficulty: QuestionDifficulty(rawValue: item.rawValue)!) { (state) in
                if state {
                    self.isDataLoad = state
                } else {
                    self.isDataLoad = state
                    print("Error with data from server")
                    
                }
            }
        }
        couldGoNextVC = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadQuestions()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let identifier = segue.identifier, identifier == "start game", couldGoNextVC {
            if let destinationVC = segue.destination  as? GameViewController {
                let questions = Game.shared.questionsArray
                destinationVC.questions = questions
            }
        }
    }
}
