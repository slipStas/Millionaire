//
//  GameViewController.swift
//  Millionaire
//
//  Created by Stanislav Slipchenko on 07.05.2020.
//  Copyright © 2020 Stanislav Slipchenko. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    /// Game delegate
    public weak var gameDelegate: GameSceneDelegate?
    
    public var orderOfQuestions: OrderOfQuestions = Game.shared.orderOfQuestions ?? OrderOfQuestions.inSeries
    public var hintsSettings: HintsSettings = Game.shared.hintsSettings ?? HintsSettings.infinitely
    
    var questionSelectionStrategy: QuestionSelectionStrategy?
    var hintsOptionsStrategy: HintOptionsStrategy?
    var questions: [Question] = []
    var selectedQuestion: Question?
    var pressedButton: UIButton?
    var countTrueAnswers = 0
    var numberOfQuestion = 0
    
    var answer: String = "" {
        didSet {
            if self.checkAnswer() && countTrueAnswers == 14 {
                UIView.animate(withDuration: 0.07, delay: 0.07, options: [.autoreverse, .repeat], animations: {
                    UIView.setAnimationRepeatCount(3)
                    self.pressedButton?.setBackgroundImage(UIImage(named: "mainBackgroundTrue"), for: .normal)
                    self.pressedButton?.alpha = 0
                    self.pressedButton?.alpha = 1
                }) { _ in
                    self.pressedButton?.setBackgroundImage(UIImage(named: "mainBackground"), for: .normal)
                    self.countTrueAnswers += 1
                    self.gameDelegate?.didEndGame(result: self.countTrueAnswers)
                }
            } else if self.checkAnswer() {
                UIView.animate(withDuration: 0.07, delay: 0.07, options: [.autoreverse, .repeat], animations: {
                    UIView.setAnimationRepeatCount(3)
                    self.pressedButton?.setBackgroundImage(UIImage(named: "mainBackgroundTrue"), for: .normal)
                    self.pressedButton?.alpha = 0
                    self.pressedButton?.alpha = 1
                }) { _ in
                    self.pressedButton?.setBackgroundImage(UIImage(named: "mainBackground"), for: .normal)
                    self.countTrueAnswers += 1
                    self.startGame()
                }
            } else {
              UIView.animate(withDuration: 0.07, delay: 0.07, options: [.autoreverse, .repeat], animations: {
                  UIView.setAnimationRepeatCount(3)
                  self.pressedButton?.setBackgroundImage(UIImage(named: "mainBackgroundFalse"), for: .normal)
                  self.pressedButton?.alpha = 0
                  self.pressedButton?.alpha = 1
              }) { _ in
                  self.gameDelegate?.didEndGame(result: self.countTrueAnswers)
                  
              }
            }
        }
    }
    
    @IBOutlet weak var buttonA: UIButton!
    @IBOutlet weak var buttonB: UIButton!
    @IBOutlet weak var buttonC: UIButton!
    @IBOutlet weak var buttonD: UIButton!
    
    @IBOutlet weak var help50Button: UIButton!
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBAction func pressedButton(_ sender: UIButton) {
        guard var answer = sender.titleLabel?.text else {return}
        self.pressedButton = sender
        
        var count = 0
        while count < 3 {
            answer.removeFirst()
            count += 1
        }
        self.answer = answer
    }
    
    @IBAction func help50(_ sender: Any) {
        guard let falseAnswers = useHelp50() else {return}
        for i in falseAnswers {
            selectedQuestion?.answers[i] = ""
        }
        addTitileToButtons()
        hintsOptionsStrategy?.hintOptionsByTap(button: &self.help50Button)
    }
    
    func addTitileToButtons() {
        self.buttonA.setTitle("A. " + (selectedQuestion?.answers[0] ?? "no question"), for: .normal)
        self.buttonB.setTitle("B. " + (selectedQuestion?.answers[1] ?? "no question"), for: .normal)
        self.buttonC.setTitle("C. " + (selectedQuestion?.answers[2] ?? "no question"), for: .normal)
        self.buttonD.setTitle("D. " + (selectedQuestion?.answers[3] ?? "no question"), for: .normal)
    }
    
    func startGame() {
        selectedQuestion = questionSelectionStrategy?.selectionQuestions(questionArray: &questions, number: &numberOfQuestion).0
        hintsOptionsStrategy?.hintOptionsViewDidLoad(button: &self.help50Button)
        
        self.questionLabel.text = selectedQuestion?.question
        
        addTitileToButtons()
    }
    
    func checkAnswer() -> Bool {
        let result = self.answer == self.selectedQuestion?.trueAnswer
        
        return result
    }
    
    func selectionQuestion() -> Question {
        let question = questions[numberOfQuestion]
        numberOfQuestion += 1
        return question
    }
    
    func useHelp50() -> [Int]? {
        guard let question = selectedQuestion else {return nil}
        var arrayFalseAnswers = question.answers.enumerated().filter {$0.element != question.trueAnswer}.map {$0.offset}
        
        let random = Int.random(in: 0...2)
        arrayFalseAnswers.remove(at: Int(random))
        return arrayFalseAnswers
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
        let question11 = Question(question: "Что в старину располагалось в Хельсинки на площади Наринкка?", answers: ["тюрьма", "кладбище", "торговые ряды", "больница"], trueAnswer: "торговые ряды")
        let question12 = Question(question: "Какое имя дал поручику Ржевскому автор пьесы «Давным-давно» Гладков?", answers: ["Михаил", "Дмитрий", "Василий", "Александр"], trueAnswer: "Дмитрий")
        let question13 = Question(question: "Чем увлекался знаменитый сказочник Ганс-Христан Андерсен?", answers: ["вязанием", "вырезанием из бумаги", "выжиганием", "выпиливанием лобзиком"], trueAnswer: "вырезанием из бумаги")
        let question14 = Question(question: "Во что оборачивают на время созревания сыр ярг, который производят в английском графстве Корнуолл?", answers: ["в мох", "в навозные лепешки", "в листья крапивы", "в торф"], trueAnswer: "в листья крапивы")
        let question15 = Question(question: " Как на Руси называлась небольшая комната, обычно в верхней части дома?", answers: ["светелка", "горелка", "огневка", "теплушка"], trueAnswer: "светелка")
        
        questions.append(contentsOf: [question1, question2, question3, question4, question5, question6, question7, question8, question9, question10, question11, question12, question13, question14, question15])
    }
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Game.shared.isHint50Used = true
        
        switch orderOfQuestions {
        case .inSeries:
            questionSelectionStrategy = SeriesQuestionSelection()
        case .random:
            questionSelectionStrategy = RandomQuestionSelection()
        }
        
        switch hintsSettings {
        case .noHints:
            hintsOptionsStrategy = NoHintsStrategy()
        case .oneTime:
            hintsOptionsStrategy = OneTimeHintsStrategy()
        case .infinitely:
            hintsOptionsStrategy = InfinitelyHintsStrategy()
        }
        
        addQuestions()
        startGame()
        self.gameDelegate = self

    }

}

extension GameViewController: GameSceneDelegate {
    func didEndGame(result: Int) {
        self.dismiss(animated: true, completion: nil)
        print("stop game")
        print("Your result is \(countTrueAnswers)")
        var records = (try? GameCaretaker.shared.load()) ?? []
        let newRecord = GameSession(date: Date(), value: result).self
        records.append(newRecord)
        
        try? GameCaretaker.shared.save(records: records)
    }
}