//
//  GameViewController.swift
//  Millionaire
//
//  Created by Stanislav Slipchenko on 07.05.2020.
//  Copyright © 2020 Stanislav Slipchenko. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    var questions: [Question] = []
    var answer: String = "" {
        didSet {
            if self.checkAnswer() && questions.count > 0 {
                startGame()
            } else {
                self.stopGame()
            }
        }
    }
    var whatTheQuestion = 0
    var selectedQuestion: Question?
    
    @IBOutlet weak var buttonA: UIButton!
    @IBOutlet weak var buttonB: UIButton!
    @IBOutlet weak var buttonC: UIButton!
    @IBOutlet weak var buttonD: UIButton!
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBAction func pressedButton(_ sender: Any) {
        guard let answer = (sender as AnyObject).titleLabel?.text else {return}
        self.answer = answer
    }
    
    func stopGame() {
        print("stop game")
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func startGame() {
        selectedQuestion = selectionQuestion()
        
        self.questionLabel.text = selectedQuestion?.question
        
        self.buttonA.setTitle(selectedQuestion?.answers[0], for: .normal)
        self.buttonB.setTitle(selectedQuestion?.answers[1], for: .normal)
        self.buttonC.setTitle(selectedQuestion?.answers[2], for: .normal)
        self.buttonD.setTitle(selectedQuestion?.answers[3], for: .normal)
        
    }
    
    func checkAnswer() -> Bool {
        
        let result = self.answer == self.selectedQuestion?.trueAnswer
        
        return result
    }
    
    func selectionQuestion() -> Question {
        let random = arc4random_uniform(UInt32(self.questions.count - 1))
        let question = questions[Int(random)]
        
        questions.remove(at: Int(random))
        
        return question
    }
    
    func addQuestions() {
        let question1 = Question(question: "Как правильно продолжить припев детской песни: Тили-тили...?", answers: ["хали-гали", "трали-вали", "жили-были", "ели-пили"], trueAnswer: "трали-вали")
        let question2 = Question(question: "Что понадобится, чтобы взрыхлить землю на грядке?", answers: ["тяпка", "бабка", "скобка", "тряпка"], trueAnswer: "тяпка")
        let question3 = Question(question: "Как называется экзотическое животное из Южной Америки?", answers: ["пчеложор", "термитоглот", "муравьед", "комаролов"], trueAnswer: "муравьед")
        let question4 = Question(question: "Во что превращается гусеница?", answers: ["в мячик", "в пирамидку", "в машинку", "в куколку"], trueAnswer: "в куколку")
        let question5 = Question(question: "К какой группе музыкальных инструментов относится валторна?", answers: ["струнные", "клавишные", "ударные", "духовые"], trueAnswer: "духовые")
        let question6 = Question(question: "В какой басне Крылова среди действующих лиц есть человек?", answers: ["Лягушка и Вол", "Свинья под Дубом", "Осел и Соловей", "Волк на псарне"], trueAnswer: "Волк на псарне")
        
        questions.append(contentsOf: [question1, question2, question3, question4, question5, question6])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addQuestions()
        startGame()

    }

}
