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
    public var hintsSettings: HintsSettings = Game.shared.hintsSettings ?? HintsSettings.noHints
    
    var questionSelectionStrategy: QuestionSelectionStrategy?
    var hintsOptionsStrategy: HintOptionsStrategy?
    var questions: [Question] = []
    var selectedQuestion: Question?
    var pressedButton: UIButton?
    var countTrueAnswers = MyObservable(countTrueAnswers: 0)
    var numberOfQuestion = 0
    var observer: NSKeyValueObservation?
    var labelsPriceArray: [UIButton] = []
    
    var answer: String = "" {
        didSet {
            if self.checkAnswer() && countTrueAnswers.countTrueAnswers == questions.count - 1 {
                UIView.animate(withDuration: 0.07, delay: 0.07, options: [.autoreverse, .repeat], animations: {
                    UIView.setAnimationRepeatCount(3)
                    self.pressedButton?.setBackgroundImage(UIImage(named: "mainBackgroundTrue"), for: .normal)
                    self.pressedButton?.alpha = 0
                    self.pressedButton?.alpha = 1
                }) { _ in
                    self.pressedButton?.setBackgroundImage(UIImage(named: "mainBackground"), for: .normal)
                    self.countTrueAnswers.countTrueAnswers += 1
                    self.gameDelegate?.didEndGame(result: self.countTrueAnswers.countTrueAnswers)
                }
            } else if self.checkAnswer() {
                UIView.animate(withDuration: 0.07, delay: 0.07, options: [.autoreverse, .repeat], animations: {
                    UIView.setAnimationRepeatCount(3)
                    self.pressedButton?.setBackgroundImage(UIImage(named: "mainBackgroundTrue"), for: .normal)
                    self.pressedButton?.alpha = 0
                    self.pressedButton?.alpha = 1
                }) { _ in
                    self.pressedButton?.setBackgroundImage(UIImage(named: "mainBackground"), for: .normal)
                    self.countTrueAnswers.countTrueAnswers += 1
                    self.startGame()
                }
            } else {
              UIView.animate(withDuration: 0.07, delay: 0.07, options: [.autoreverse, .repeat], animations: {
                  UIView.setAnimationRepeatCount(3)
                  self.pressedButton?.setBackgroundImage(UIImage(named: "mainBackgroundFalse"), for: .normal)
                  self.pressedButton?.alpha = 0
                  self.pressedButton?.alpha = 1
              }) { _ in
                self.gameDelegate?.didEndGame(result: self.countTrueAnswers.countTrueAnswers)
                  
              }
            }
        }
    }
    
    @IBOutlet weak var question1PriceLabel: UIButton!
    @IBOutlet weak var question2PriceLabel: UIButton!
    @IBOutlet weak var question3PriceLabel: UIButton!
    @IBOutlet weak var question4PriceLabel: UIButton!
    @IBOutlet weak var question5PriceLabel: UIButton!
    @IBOutlet weak var question6PriceLabel: UIButton!
    @IBOutlet weak var question7PriceLabel: UIButton!
    @IBOutlet weak var question8PriceLabel: UIButton!
    @IBOutlet weak var question9PriceLabel: UIButton!
    @IBOutlet weak var question10PriceLabel: UIButton!
    @IBOutlet weak var question11PriceLabel: UIButton!
    @IBOutlet weak var question12PriceLabel: UIButton!
    @IBOutlet weak var question13PriceLabel: UIButton!
    @IBOutlet weak var question14PriceLabel: UIButton!
    @IBOutlet weak var question15PriceLabel: UIButton!
    
    @IBOutlet weak var buttonA: UIButton!
    @IBOutlet weak var buttonB: UIButton!
    @IBOutlet weak var buttonC: UIButton!
    @IBOutlet weak var buttonD: UIButton!
    
    @IBOutlet weak var help50Button: UIButton!
    @IBOutlet weak var callFriendButton: UIButton!
    @IBOutlet weak var hallHelpButton: UIButton!
    
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
    
    @IBAction func callFriend(_ sender: Any) {
        print("calling friend")
        hintsOptionsStrategy?.hintOptionsByTap(button: &self.callFriendButton)
    }
    @IBAction func hallHelp(_ sender: Any) {
        print("helping hall")
        hintsOptionsStrategy?.hintOptionsByTap(button: &self.hallHelpButton)
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
        hintsOptionsStrategy?.hintOptionsViewDidLoad(button: &self.callFriendButton)
        hintsOptionsStrategy?.hintOptionsViewDidLoad(button: &self.hallHelpButton)

        
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
        
        question1PriceLabel.setTitle("100", for: .normal)
        question2PriceLabel.setTitle("200", for: .normal)
        question3PriceLabel.setTitle("300", for: .normal)
        question4PriceLabel.setTitle("500", for: .normal)
        question5PriceLabel.setTitle("1,000", for: .normal)
        question6PriceLabel.setTitle("2,000", for: .normal)
        question7PriceLabel.setTitle("4,000", for: .normal)
        question8PriceLabel.setTitle("8,000", for: .normal)
        question9PriceLabel.setTitle("16,000", for: .normal)
        question10PriceLabel.setTitle("32,000", for: .normal)
        question11PriceLabel.setTitle("64,000", for: .normal)
        question12PriceLabel.setTitle("125,000", for: .normal)
        question13PriceLabel.setTitle("250,000", for: .normal)
        question14PriceLabel.setTitle("500,000", for: .normal)
        question15PriceLabel.setTitle("1,000,000", for: .normal)
        
        question1PriceLabel.setBackgroundImage(UIImage(named: "mainBackground"), for: .normal)
        question2PriceLabel.setBackgroundImage(UIImage(named: "mainBackground"), for: .normal)
        question3PriceLabel.setBackgroundImage(UIImage(named: "mainBackground"), for: .normal)
        question4PriceLabel.setBackgroundImage(UIImage(named: "mainBackground"), for: .normal)
        question5PriceLabel.setBackgroundImage(UIImage(named: "mainBackground"), for: .normal)
        question6PriceLabel.setBackgroundImage(UIImage(named: "mainBackground"), for: .normal)
        question7PriceLabel.setBackgroundImage(UIImage(named: "mainBackground"), for: .normal)
        question8PriceLabel.setBackgroundImage(UIImage(named: "mainBackground"), for: .normal)
        question9PriceLabel.setBackgroundImage(UIImage(named: "mainBackground"), for: .normal)
        question10PriceLabel.setBackgroundImage(UIImage(named: "mainBackground"), for: .normal)
        question11PriceLabel.setBackgroundImage(UIImage(named: "mainBackground"), for: .normal)
        question12PriceLabel.setBackgroundImage(UIImage(named: "mainBackground"), for: .normal)
        question13PriceLabel.setBackgroundImage(UIImage(named: "mainBackground"), for: .normal)
        question14PriceLabel.setBackgroundImage(UIImage(named: "mainBackground"), for: .normal)
        question15PriceLabel.setBackgroundImage(UIImage(named: "mainBackground"), for: .normal)
        
        labelsPriceArray.append(contentsOf: [question1PriceLabel, question2PriceLabel, question3PriceLabel, question4PriceLabel, question5PriceLabel, question6PriceLabel, question7PriceLabel, question8PriceLabel, question9PriceLabel, question10PriceLabel, question11PriceLabel, question12PriceLabel, question13PriceLabel, question14PriceLabel, question15PriceLabel])
        
        labelsPriceArray.first?.setBackgroundImage(UIImage(named: "mainBackgroundOrange"), for: .normal)
        labelsPriceArray.first?.titleLabel?.font = UIFont(descriptor: UIFontDescriptor(), size: 25)
        
        observer = {
            countTrueAnswers.observe(\.countTrueAnswers, options: [.old ,.new]) { (_, change) in
                if let newValue = change.newValue, newValue > 0, newValue < 15 {
                    let titleLabel = self.labelsPriceArray[newValue - 1].titleLabel?.text
                    UIView.animate(withDuration: 0.5, animations: {
                        self.labelsPriceArray[newValue - 1].transform = CGAffineTransform(translationX: 0, y: -self.question1PriceLabel.frame.height)
                        self.labelsPriceArray[newValue - 1].setTitle(self.labelsPriceArray[newValue].titleLabel?.text, for: .normal)
                    }, completion: { (status) in
                        self.labelsPriceArray[newValue - 1].setTitle(titleLabel, for: .normal)
                        self.labelsPriceArray[newValue - 1].transform = CGAffineTransform(translationX: 0, y: 0)
                        self.labelsPriceArray[newValue - 1].setBackgroundImage(UIImage(named: "mainBackgroundTrue"), for: .normal)
                        self.labelsPriceArray[newValue - 1].titleLabel?.font = UIFont(descriptor: UIFontDescriptor(), size: 20)
                        self.labelsPriceArray[newValue].setBackgroundImage(UIImage(named: "mainBackgroundOrange"), for: .normal)
                        self.labelsPriceArray[newValue].titleLabel?.font = UIFont(descriptor: UIFontDescriptor(), size: 25)
                    })
                    
                }
                print("\(String(describing: change.oldValue)) was change to \(String(describing: change.newValue))")
            }
        }()
                
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
