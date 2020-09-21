//
//  ConsoleView.swift
//  Millionaire
//
//  Created by Stanislav Slipchenko on 20.09.2020.
//  Copyright © 2020 Stanislav Slipchenko. All rights reserved.
//

import UIKit

class FriendCallView: UIView {
    
    var isFriendCallEnableNow = false
    
    let friendCallView: UIView = {
        let view = UIView(frame: .zero)
        view.alpha = 0
        
        return view
    }()
    
    let circleLayer: CAShapeLayer = {
        let circle = CAShapeLayer()
        circle.fillColor = UIColor.clear.cgColor
        circle.strokeColor = UIColor.green.cgColor
        circle.lineWidth = 7.0

        circle.strokeEnd = 0
        return circle
    }()
    
    let timerLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 80)
        
        return label
    }()
    
    let diagramView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.isEditable = false
        textView.textColor = .systemGray
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.text = "qwerty bgrbyteh ergkjkmlfse jnfwrf4"
        
        return textView
    }()
    
    var timer : Timer? = Timer()
    var timerCounter = 30 {
        didSet {
            print(timerCounter)
            timerLabel.text = ":" + String(timerCounter)
            animateCircle(duration: 0.3)
            if timerCounter == 0 {
                stopTimer()
                animateRemoving(view: self.friendCallView)
            }
        }
    }
    var strokeEnd = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setup(){
        backgroundColor = UIColor.clear
        
        friendCallView.frame = bounds
        
        timerLabel.frame = CGRect(x: friendCallView.frame.minX, y: friendCallView.frame.minY, width: friendCallView.frame.width, height: friendCallView.frame.width)
        timerLabel.text = ":" + String(timerCounter)
        
        diagramView.frame = CGRect(x: friendCallView.frame.minX, y: friendCallView.frame.width, width: friendCallView.frame.width, height: friendCallView.frame.width)

        addSubview(friendCallView)
        friendCallView.layer.addSublayer(circleLayer)
        friendCallView.addSubview(timerLabel)
        friendCallView.addSubview(diagramView)
        
        UIView.animate(withDuration: 0.5) {
            self.friendCallView.alpha = 1
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: self.frame.size.width / 2.0, y: self.frame.size.width / 2.0), radius: (self.frame.size.width) / 2, startAngle: CGFloat(270 * Double.pi / 180), endAngle: CGFloat(269.9 * Double.pi / 180), clockwise: true)
        
        circleLayer.path = circlePath.cgPath
    }
    
    func animateCircle(duration time: TimeInterval) {
                
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.duration = time
        strokeEndAnimation.fromValue = self.strokeEnd
        
        self.strokeEnd += 0.033333
        if self.strokeEnd >= 1 {
            self.strokeEnd = 1
        }
        strokeEndAnimation.toValue = self.strokeEnd
        
        strokeEndAnimation.isRemovedOnCompletion = false
        strokeEndAnimation.fillMode = CAMediaTimingFillMode.both
        self.circleLayer.strokeEnd = CGFloat(self.strokeEnd)
        strokeEndAnimation.isRemovedOnCompletion = true
        strokeEndAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        
        circleLayer.add(strokeEndAnimation, forKey: "animateCircle")
    }
    
    @objc func timerCountering() {
        timerCounter -= 1
    }
    
    func startTimer() {
        setup()
        print("start timer")
        isFriendCallEnableNow = true
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCountering), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        print("stop timer")
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func animateRemoving(view: UIView) {
        UIView.animate(withDuration: 0.5) {
            view.transform = CGAffineTransform.init(scaleX: 0.2, y: 0.2)
            view.alpha = 0
        } completion: { (status) in
            view.removeFromSuperview()
            view.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            self.timerCounter = 30
            self.strokeEnd = 0
            self.isFriendCallEnableNow = false
        }
    }
    
    func friendRandomAnswerGenerate(question: Question) {
        var friendAnswer = "Я думаю, что правильный ответ это - "
        
        let answerA = RandomAnswers()
        let answerB = RandomAnswers()
        let answerC = RandomAnswers()
        let answerD = RandomAnswers()
        
        var count = 0
        var selectedAnswerByFriend = RandomAnswers()
        
        let answersArray = [answerA, answerB, answerC, answerD]
        
        question.answers.forEach { (answer) in
            var randomiser = 0
            
            switch answer {
            case question.trueAnswer:
                randomiser = Int.random(in: 40...100)
            case "":
                randomiser = 0
            default:
                randomiser = Int.random(in: 0...90)
            }
            
            answersArray[count].integer = randomiser
            answersArray[count].index = count
            
            count += 1
        }
        
        answersArray.forEach { (item) in
            if item.integer > selectedAnswerByFriend.integer {
                selectedAnswerByFriend = item
            }
        }
        
        friendAnswer += question.answers[selectedAnswerByFriend.index]
        
        self.diagramView.text = friendAnswer
    }
}

class AuditoryHelpView: UIView {
    
    var isHallHelpEnableNow = false
    
    var auditoryHelpView: UIView = {
        let view = UIView(frame: .zero)
        view.alpha = 0
        
        return view
    }()
    
    var abcdLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "A  B  C  D"
        label.textColor = .systemGray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 40)
        
        return label
    }()
    
    var columnAView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
        return view
    }()
    var columnBView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        
        return view
    }()
    var columnCView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        
        return view
    }()
    var columnDView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        
        return view
    }()
    
    var percentAColumn: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.alpha = 0
        return label
    }()
    var percentBColumn: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.alpha = 0
        return label
    }()
    var percentCColumn: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.alpha = 0
        return label
    }()
    var percentDColumn: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.alpha = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setup(){
        backgroundColor = UIColor.clear
        
        auditoryHelpView.frame = bounds
        
        columnAView.frame = CGRect(x: 0, y: auditoryHelpView.frame.height / 10 * 9, width: (bounds.width / 4) - 2, height: 1)
        columnBView.frame = CGRect(x: bounds.width / 4, y: auditoryHelpView.frame.height / 10 * 9, width: (bounds.width / 4) - 2, height: 1)
        columnCView.frame = CGRect(x: bounds.width / 4 * 2, y: auditoryHelpView.frame.height / 10 * 9, width: (bounds.width / 4) - 2, height: 1)
        columnDView.frame = CGRect(x: bounds.width / 4 * 3, y: auditoryHelpView.frame.height / 10 * 9, width: (bounds.width / 4) - 2, height: 1)
        
        addSubview(auditoryHelpView)
        auditoryHelpView.addSubview(abcdLabel)
        auditoryHelpView.addSubview(columnAView)
        auditoryHelpView.addSubview(columnBView)
        auditoryHelpView.addSubview(columnCView)
        auditoryHelpView.addSubview(columnDView)
        auditoryHelpView.addSubview(percentAColumn)
        auditoryHelpView.addSubview(percentBColumn)
        auditoryHelpView.addSubview(percentCColumn)
        auditoryHelpView.addSubview(percentDColumn)
        
        abcdLabel.translatesAutoresizingMaskIntoConstraints = false
        abcdLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: self.leadingAnchor, multiplier: 0).isActive = true
        abcdLabel.trailingAnchor.constraint(equalToSystemSpacingAfter: self.trailingAnchor, multiplier: 0).isActive = true
        abcdLabel.bottomAnchor.constraint(equalToSystemSpacingBelow: self.bottomAnchor, multiplier: 0).isActive = true
        abcdLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        percentAColumn.translatesAutoresizingMaskIntoConstraints = false
        percentAColumn.leadingAnchor.constraint(equalToSystemSpacingAfter: self.columnAView.leadingAnchor, multiplier: 0).isActive = true
        percentAColumn.trailingAnchor.constraint(equalToSystemSpacingAfter: self.columnAView.trailingAnchor, multiplier: 0).isActive = true
        percentAColumn.bottomAnchor.constraint(equalToSystemSpacingBelow: self.columnAView.topAnchor, multiplier: 0).isActive = true
        percentAColumn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        percentBColumn.translatesAutoresizingMaskIntoConstraints = false
        percentBColumn.leadingAnchor.constraint(equalToSystemSpacingAfter: self.columnBView.leadingAnchor, multiplier: 0).isActive = true
        percentBColumn.trailingAnchor.constraint(equalToSystemSpacingAfter: self.columnBView.trailingAnchor, multiplier: 0).isActive = true
        percentBColumn.bottomAnchor.constraint(equalToSystemSpacingBelow: self.columnBView.topAnchor, multiplier: 0).isActive = true
        percentBColumn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        percentCColumn.translatesAutoresizingMaskIntoConstraints = false
        percentCColumn.leadingAnchor.constraint(equalToSystemSpacingAfter: self.columnCView.leadingAnchor, multiplier: 0).isActive = true
        percentCColumn.trailingAnchor.constraint(equalToSystemSpacingAfter: self.columnCView.trailingAnchor, multiplier: 0).isActive = true
        percentCColumn.bottomAnchor.constraint(equalToSystemSpacingBelow: self.columnCView.topAnchor, multiplier: 0).isActive = true
        percentCColumn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        percentDColumn.translatesAutoresizingMaskIntoConstraints = false
        percentDColumn.leadingAnchor.constraint(equalToSystemSpacingAfter: self.columnDView.leadingAnchor, multiplier: 0).isActive = true
        percentDColumn.trailingAnchor.constraint(equalToSystemSpacingAfter: self.columnDView.trailingAnchor, multiplier: 0).isActive = true
        percentDColumn.bottomAnchor.constraint(equalToSystemSpacingBelow: self.columnDView.topAnchor, multiplier: 0).isActive = true
        percentDColumn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        UIView.animate(withDuration: 0.5) {
            self.auditoryHelpView.alpha = 1
        }
    }
    
    func animateRemoving(view: UIView) {
        UIView.animate(withDuration: 0.5) {
            view.transform = CGAffineTransform.init(scaleX: 0.2, y: 0.2)
            view.alpha = 0
            self.percentAColumn.alpha = 0
            self.percentBColumn.alpha = 0
            self.percentCColumn.alpha = 0
            self.percentDColumn.alpha = 0
        } completion: { (status) in
            view.removeFromSuperview()
            view.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            self.isHallHelpEnableNow = false
        }
    }
    
    func animateColumns(question: Question) {
        isHallHelpEnableNow = true
        
        var trueAnswerInt = 0
        var count = 0
        var bufferInteger = 100 {
            didSet  {
                if bufferInteger < 0 {
                    bufferInteger = 0
                }
            }
        }
        
        var answersArray: [Int] = []
        
        question.answers.forEach { (answer) in
            switch answer {
            case question.trueAnswer:
                answersArray.insert(Int.random(in: 0...bufferInteger), at: count)
                bufferInteger -= answersArray[count]
                trueAnswerInt = count
            case "":
                answersArray.insert(0, at: count)
            default:
                answersArray.insert(Int.random(in: 0...bufferInteger), at: count)
                bufferInteger -= answersArray[count]
            }
            count += 1
        }
        answersArray[trueAnswerInt] += bufferInteger
        
        self.percentAColumn.text = String(answersArray[0])
        self.percentBColumn.text = String(answersArray[1])
        self.percentCColumn.text = String(answersArray[2])
        self.percentDColumn.text = String(answersArray[3])
        
        UIView.animate(withDuration: 2, delay: 1, options: []) {
            self.columnAView.frame = CGRect(x: self.columnAView.frame.minX, y: self.columnAView.frame.minY - CGFloat(answersArray[0] * 3), width: self.columnAView.frame.width, height: self.columnAView.frame.height + CGFloat(answersArray[0] * 3))
        } completion: { (status) in
            UIView.animate(withDuration: 0.5) {
                self.percentAColumn.alpha = 1
            }
        }
        UIView.animate(withDuration: 2, delay: 1.1, options: []) {
            self.columnBView.frame = CGRect(x: self.columnBView.frame.minX, y: self.columnBView.frame.minY - CGFloat(answersArray[1] * 3), width: self.columnBView.frame.width, height: self.columnBView.frame.height + CGFloat(answersArray[1] * 3))
        } completion: { (status) in
            UIView.animate(withDuration: 0.5) {
                self.percentBColumn.alpha = 1
            }
        }
        UIView.animate(withDuration: 2, delay: 1.2, options: []) {
            self.columnCView.frame = CGRect(x: self.columnCView.frame.minX, y: self.columnCView.frame.minY - CGFloat(answersArray[2] * 3), width: self.columnCView.frame.width, height: self.columnCView.frame.height + CGFloat(answersArray[2] * 3))
        } completion: { (status) in
            UIView.animate(withDuration: 0.5) {
                self.percentCColumn.alpha = 1
            }
        }
        UIView.animate(withDuration: 2, delay: 1.3, options: []) {
            self.columnDView.frame = CGRect(x: self.columnDView.frame.minX, y: self.columnDView.frame.minY - CGFloat(answersArray[3] * 3), width: self.columnDView.frame.width, height: self.columnDView.frame.height + CGFloat(answersArray[3] * 3))
        } completion: { (status) in
            UIView.animate(withDuration: 0.5) {
                self.percentDColumn.alpha = 1
            }
        }
    }
}



//-----------------------------------------
class ConsoleView: UIView {
    
    var friendCall = FriendCallView()
    
    var auditoryHelp = AuditoryHelpView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup(){
        backgroundColor = UIColor.clear
        
        friendCall.frame = bounds
        auditoryHelp.frame = bounds
        
        addSubview(auditoryHelp)
        addSubview(friendCall)
    }
}
