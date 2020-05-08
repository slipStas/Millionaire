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
                UIView.animate(withDuration: 0.07, delay: 0, options: [.autoreverse, .repeat], animations: {
                    UIView.setAnimationRepeatCount(3)
                    self.pressedButton?.backgroundColor = .green
                }) { _ in
                    self.pressedButton?.backgroundColor = #colorLiteral(red: 1, green: 0.5642306805, blue: 0, alpha: 1)
                    self.startGame()
                }
            } else if self.checkAnswer() && questions.count == 0 {
                UIView.animate(withDuration: 0.07, delay: 0, options: [.autoreverse, .repeat], animations: {
                    UIView.setAnimationRepeatCount(3)
                    self.pressedButton?.backgroundColor = .green
                }) { _ in
                    self.pressedButton?.backgroundColor = #colorLiteral(red: 1, green: 0.5642306805, blue: 0, alpha: 1)
                    print("you are the winner!!!")
                    self.stopGame()
                }
            } else {
               UIView.animate(withDuration: 0.07, delay: 0, options: [.autoreverse, .repeat], animations: {
                    UIView.setAnimationRepeatCount(3)
                    self.pressedButton?.backgroundColor = .red
                }) { _ in
                    self.pressedButton?.backgroundColor = #colorLiteral(red: 1, green: 0.5642306805, blue: 0, alpha: 1)
                    self.stopGame()
                }
            }
        }
    }
    var selectedQuestion: Question?
    var pressedButton: UIButton?
    
    @IBOutlet weak var buttonA: UIButton!
    @IBOutlet weak var buttonB: UIButton!
    @IBOutlet weak var buttonC: UIButton!
    @IBOutlet weak var buttonD: UIButton!
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBAction func pressedButton(_ sender: Any) {
        guard var answer = (sender as AnyObject).titleLabel?.text else {return}
        self.pressedButton = (sender as! UIButton)
        
        var count = 0
        while count < 3 {
            answer.removeFirst()
            count += 1
        }
        self.answer = answer
    }
    
    func stopGame() {
        print("stop game")
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func startGame() {
        selectedQuestion = selectionQuestion()
        
        self.questionLabel.text = selectedQuestion?.question
        
        self.buttonA.setTitle("A. " + (selectedQuestion?.answers[0] ?? "no question"), for: .normal)
        self.buttonB.setTitle("B. " + (selectedQuestion?.answers[1] ?? "no question"), for: .normal)
        self.buttonC.setTitle("C. " + (selectedQuestion?.answers[2] ?? "no question"), for: .normal)
        self.buttonD.setTitle("D. " + (selectedQuestion?.answers[3] ?? "no question"), for: .normal)
        
    }
    
    func checkAnswer() -> Bool {
        let result = self.answer == self.selectedQuestion?.trueAnswer
        
        return result
    }
    
    func selectionQuestion() -> Question {
        let random = arc4random_uniform(UInt32(self.questions.count - 1))
        let question = questions[Int(random)]
        print(random)
        
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
        let question7 = Question(question: "Какой фильм сделал знаменитой песню в исполнении Уитни Хьюстон?", answers: ["Красотка", "Телохранитель", "Форрест Гамп", "Пятый элемент"], trueAnswer: "Телохранитель")
        let question8 = Question(question: "Кому в работе нужны постромки?", answers: ["врачу", "кузнецу", "извозчику", "охотнику"], trueAnswer: "извозчику")
        let question9 = Question(question: "Какой писатель сформулировал Три закона робототехники?", answers: ["Карел Чапек", "Айзек Азимов", "Станислав Лем", "Курт Воннегут"], trueAnswer: "Айзек Азимов")
        let question10 = Question(question: "Какой советский орден был единственным, выпускавшимся не на монетном дворе?", answers: ["орден Александра Невского", "орден «Победа»", "орден Отечественной войны", "орден Трудового Красного Знамени"], trueAnswer: "орден «Победа»")
        
        questions.append(contentsOf: [question1, question2, question3, question4, question5, question6, question7, question8, question9, question10])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.buttonA.backgroundColor = #colorLiteral(red: 1, green: 0.5642306805, blue: 0, alpha: 1)
        self.buttonB.backgroundColor = #colorLiteral(red: 1, green: 0.5642306805, blue: 0, alpha: 1)
        self.buttonC.backgroundColor = #colorLiteral(red: 1, green: 0.5642306805, blue: 0, alpha: 1)
        self.buttonD.backgroundColor = #colorLiteral(red: 1, green: 0.5642306805, blue: 0, alpha: 1)

        addQuestions()
        startGame()

    }

}
