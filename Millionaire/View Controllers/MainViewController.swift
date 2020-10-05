//
//  MainViewController.swift
//  Millionaire
//
//  Created by Stanislav Slipchenko on 07.05.2020.
//  Copyright © 2020 Stanislav Slipchenko. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet weak var serverStatusLabel: UILabel!
    
    let getQuestions = GetQuestionsApi()
    var isDataLoad = false
    
    @IBAction func refreshQuestions(_ sender: Any) {
        MockDatabase.shared.questionsArrayLow.removeAll()
        MockDatabase.shared.questionsArrayMedium.removeAll()
        MockDatabase.shared.questionsArrayHard.removeAll()
        isDataLoad = false
        loadQuestions()
    }
    @IBAction func startGameTap(_ sender: Any) {
        if MockDatabase.shared.questionsArrayLow.count > 0 {
            let storyBoard : UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "GameVC") as! GameViewController
            self.present(newViewController, animated: true, completion: nil)
        }
    }
    
    func loadQuestions() {
        DispatchQueue.global(qos: .userInteractive).async {
            self.getQuestions.getQuestions(questionDifficulty: QuestionDifficulty.low) { (state)  in
                DispatchQueue.main.async {
                    if state {
                        print("add 5 questions")
                        self.serverStatusLabel.text = "Server is enable ✅"
                        self.serverStatusLabel.textColor = .green
                        self.isDataLoad = state
                    } else {
                        self.serverStatusLabel.text = "Server is disable ❌"
                        self.serverStatusLabel.textColor = .gray
                        self.isDataLoad = state
                        print("Error with data from server")
                        MockDatabase.shared.addQuestions()
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadQuestions()
    }
}
