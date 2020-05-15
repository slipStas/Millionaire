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
        Game.shared.questionsArrayChild.removeAll()
        Game.shared.questionsArrayMedium.removeAll()
        Game.shared.questionsArrayHard.removeAll()
        isDataLoad = false
        loadQuestions()
    }
    @IBAction func startGameTap(_ sender: Any) {
        if Game.shared.questionsArrayChild.count > 0 {
            let storyBoard : UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "GameVC") as! GameViewController
            self.present(newViewController, animated: true, completion: nil)
        }
//        else {
//            self.loadQuestions()
//            let storyBoard : UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
//            let newViewController = storyBoard.instantiateViewController(withIdentifier: "GameVC") as! GameViewController
//            self.present(newViewController, animated: true, completion: nil)
//        }
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
        
        Game.shared.questionsArrayChild.append(contentsOf: [question1, question2, question3, question4, question5, question6, question7, question8, question9, question10, question11, question12, question13, question14, question15])
        print("questions load from device")
    }
    
    func loadQuestions() {
        DispatchQueue.global(qos: .userInteractive).async {
            self.getQuestions.getQuestions(questionDifficulty: QuestionDifficulty.child) { (state)  in
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
                        self.addQuestions()
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
