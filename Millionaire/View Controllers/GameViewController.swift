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
    
    public var hintsSettings: Int? = Game.shared.defaults.integer(forKey: "difficulty")
    
    let getQuestions = GetQuestionsApi()
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
                UIView.animate(withDuration: 0.07, delay: 0, options: [.autoreverse, .repeat], animations: {
                    UIView.modifyAnimations(withRepeatCount: 3, autoreverses: true) {
                        self.pressedButton?.setBackgroundImage(UIImage(named: "mainBackgroundTrue"), for: .normal)
                        self.pressedButton?.alpha = 0
                        self.pressedButton?.alpha = 1
                    }
                    
                }) { _ in
                    self.pressedButton?.setBackgroundImage(UIImage(named: "mainBackground"), for: .normal)
                    self.countTrueAnswers.countTrueAnswers += 1
                }
            } else if self.checkAnswer() {
                UIView.animate(withDuration: 0.07, delay: 0, options: [.autoreverse, .repeat], animations: {
                    UIView.modifyAnimations(withRepeatCount: 3, autoreverses: true) {
                        self.pressedButton?.setBackgroundImage(UIImage(named: "mainBackgroundTrue"), for: .normal)
                        self.pressedButton?.alpha = 0
                        self.pressedButton?.alpha = 1
                    }
                }) { _ in
                    self.pressedButton?.setBackgroundImage(UIImage(named: "mainBackground"), for: .normal)
                    self.countTrueAnswers.countTrueAnswers += 1
                    self.startGame()
                }
            } else {
                let buttonsArray = [buttonA, buttonB, buttonC, buttonD]
                
                for button in buttonsArray {
                    var text = button?.titleLabel?.text
                    var count = 0
                    while count < 3 {
                        text!.removeFirst()
                        count += 1
                    }
                    button?.titleLabel?.text = text
                }
                guard let trueButton = buttonsArray.filter({$0?.titleLabel?.text == self.selectedQuestion?.trueAnswer}).first! else {return}
                
                UIView.animate(withDuration: 0.09, delay: 0, options: [.autoreverse, .repeat], animations: {
                    UIView.modifyAnimations(withRepeatCount: 3, autoreverses: true) {
                        self.pressedButton?.setBackgroundImage(UIImage(named: "mainBackgroundFalse"), for: .normal)
                        trueButton.setBackgroundImage(UIImage(named: "mainBackgroundTrue"), for: .normal)
                        self.pressedButton?.alpha = 0
                        self.pressedButton?.alpha = 1
                    }
                }) { _ in
                    sleep(2)
                    if self.countTrueAnswers.countTrueAnswers == 0 {
                        self.gameDelegate?.didEndGame(result: "0")
                    } else {
                        self.gameDelegate?.didEndGame(result: self.labelsPriceArray[self.countTrueAnswers.countTrueAnswers - 1].currentTitle ?? "error")
                    }
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
    
    @IBOutlet weak var consoleView: FriendCallView!
    
    @IBAction func pressedButton(_ sender: UIButton) {
        guard var answer = sender.titleLabel?.text else {return}
        self.pressedButton = sender
        
        var count = 0
        while count < 3 {
            answer.removeFirst()
            count += 1
        }
        self.answer = answer
        consoleView.stopTimer()
        consoleView.animateRemoving(view: consoleView.friendCallView)
    }
    
    @IBAction func callFriend(_ sender: Any) {
        print("calling friend")
        hintsOptionsStrategy?.hintOptionsByTap(button: &self.callFriendButton)
        
        consoleView.startTimer()
        consoleView.animateCircle(duration: 0.3)
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
        
        guard let question = selectedQuestion?.answers else {return}
        
        self.buttonA.setTitle("A: " + (question[0]), for: .normal)
        self.buttonB.setTitle("B: " + (question[1]), for: .normal)
        self.buttonC.setTitle("C: " + (question[2]), for: .normal)
        self.buttonD.setTitle("D: " + (question[3]), for: .normal)
    }
    
    func startGame() {
        if self.countTrueAnswers.countTrueAnswers == 2 {
            DispatchQueue.global(qos: .userInteractive).async {
                self.getQuestions.getQuestions(questionDifficulty: .medium) { (state) in
                    if state {
                        sleep(4)
                        print("add 5 medium questions")
                        self.questions.append(contentsOf: Game.shared.questionsArrayMedium)
                    } else {
                        print("Error with data from server")
                    }
                }
            }
        }
        if self.countTrueAnswers.countTrueAnswers == 8 {
            DispatchQueue.global(qos: .userInteractive).async {
                self.getQuestions.getQuestions(questionDifficulty: .hard) { (state) in
                    if state {
                        sleep(4)
                        print("add 5 hard questions")
                        self.questions.append(contentsOf: Game.shared.questionsArrayHard)
                    } else {
                        print("Error with data from server")
                    }
                }
            }
        }
        questions = questionSelectionStrategy!.selectionQuestions(questionArray: questions, number: numberOfQuestion).2
        selectedQuestion = questionSelectionStrategy?.selectionQuestions(questionArray: questions, number: numberOfQuestion).0
        numberOfQuestion = questionSelectionStrategy!.selectionQuestions(questionArray: questions, number: numberOfQuestion).1
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
    
    func addSpace(integer: Int) -> String {
        var string = String(integer)
        var count = 1

        string = String(string.reversed())

        string.forEach { (char) in
            switch count {
            case 3:
                string.insert(" ", at: string.index(string.startIndex, offsetBy: count))
            case 6:
                string.insert(" ", at: string.index(string.startIndex, offsetBy: count + 1))
            default:
                break
            }
            count += 1
        }
        
        return String(string.reversed())
    }
    
    func setTitlePriceButtons(buttons: [UIButton]) {
        var title = 100
        var count = 0
        buttons.forEach { (button) in
            switch count {
            case 0...1:
                button.setTitle(addSpace(integer: title), for: .normal)
                count += 1
                title += 100
            case 2:
                button.setTitle(addSpace(integer: title), for: .normal)
                count += 1
                title += 200
            case 3...9, 11...14:
                button.setTitle(addSpace(integer: title), for: .normal)
                count += 1
                title *= 2
            case 10:
                button.setTitle(addSpace(integer: title), for: .normal)
                count += 1
                title = 125_000
            default:
                break
            }
        }
    }
    
    func setImagePriceButtons(buttons: [UIButton]) {
        buttons.forEach { $0.setBackgroundImage(UIImage(named: "mainBackground"), for: .normal) }
    }
    
    func observerFunc() {
        observer = {
            countTrueAnswers.observe(\.countTrueAnswers, options: [.old ,.new]) { (_, change) in
                if let newValue = change.newValue, newValue > 0, newValue < self.questions.count {
                    let titleLabel = self.labelsPriceArray[newValue - 1].titleLabel?.text
                    
                    UIView.animate(withDuration: 0.5, animations: {
                        self.labelsPriceArray[newValue - 1].transform = CGAffineTransform(translationX: 0, y: -self.question1PriceLabel.frame.height)
                        self.labelsPriceArray[newValue - 1].setTitle(self.labelsPriceArray[newValue].titleLabel?.text, for: .normal)
                    }, completion: { (status) in
                        self.labelsPriceArray[newValue - 1].setTitle(titleLabel, for: .normal)
                        self.labelsPriceArray[newValue - 1].alpha = 0
                        UIView.animate(withDuration: 0.1) {
                            self.labelsPriceArray[newValue - 1].alpha = 1
                            self.labelsPriceArray[newValue - 1].transform = CGAffineTransform(translationX: 0, y: 0)
                            self.labelsPriceArray[newValue - 1].setBackgroundImage(UIImage(named: "mainBackgroundTrue"), for: .normal)
                            self.labelsPriceArray[newValue - 1].titleLabel?.font = UIFont(descriptor: UIFontDescriptor(), size: 20)
                            self.labelsPriceArray[newValue].setBackgroundImage(UIImage(named: "mainBackgroundOrange"), for: .normal)
                            self.labelsPriceArray[newValue].titleLabel?.font = UIFont(descriptor: UIFontDescriptor(), size: 30)
                        }
                    })
                }
            }
        }()
    }
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
                
        questions = Game.shared.questionsArrayChild
        labelsPriceArray.append(contentsOf: [question1PriceLabel, question2PriceLabel, question3PriceLabel, question4PriceLabel, question5PriceLabel, question6PriceLabel, question7PriceLabel, question8PriceLabel, question9PriceLabel, question10PriceLabel, question11PriceLabel, question12PriceLabel, question13PriceLabel, question14PriceLabel, question15PriceLabel])
        
        setTitlePriceButtons(buttons: labelsPriceArray)
        setImagePriceButtons(buttons: labelsPriceArray)

        labelsPriceArray.first?.setBackgroundImage(UIImage(named: "mainBackgroundOrange"), for: .normal)
        labelsPriceArray.first?.titleLabel?.font = UIFont(descriptor: UIFontDescriptor(), size: 25)
        
        observerFunc()
        questionSelectionStrategy = SeriesQuestionSelection()
        
        switch hintsSettings {
        case 0:
            hintsOptionsStrategy = NoHintsStrategy()
        case 1:
            hintsOptionsStrategy = OneTimeHintsStrategy()
        case 2:
            hintsOptionsStrategy = InfinitelyHintsStrategy()
        default:
            hintsOptionsStrategy = InfinitelyHintsStrategy()
        }
        
        startGame()
        self.gameDelegate = self
    }
}

extension GameViewController: GameSceneDelegate {
    func didEndGame(result: String) {
        self.dismiss(animated: true, completion: nil)
        var records = (try? GameCaretaker.shared.load()) ?? []
        let newRecord = GameSession(date: Date(), value: result).self
        records.insert(newRecord, at: 0)
        Game.shared.questionsArrayChild.removeAll()
        Game.shared.questionsArrayMedium.removeAll()
        Game.shared.questionsArrayHard.removeAll()
        
        DispatchQueue.global(qos: .userInteractive).async {
            self.getQuestions.getQuestions(questionDifficulty: .child) { (state) in
                if state {
                    print("add 5 questions")
                    self.questions.append(contentsOf: Game.shared.questionsArrayChild)
                } else {
                    print("Error with data from server")
                }
            }
        }
        try? GameCaretaker.shared.save(records: records)
    }
}
