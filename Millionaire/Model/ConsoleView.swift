//
//  ConsoleView.swift
//  Millionaire
//
//  Created by Stanislav Slipchenko on 20.09.2020.
//  Copyright © 2020 Stanislav Slipchenko. All rights reserved.
//

import UIKit

class FriendCallView: UIView {
    
    let friendCallView: UIView = {
        let view = UIView(frame: .zero)
        
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
        
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCountering), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        print("stop timer")
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func animateRemoving(view: UIView) {
        UIView.animate(withDuration: 0.3) {
            view.transform = CGAffineTransform.init(scaleX: 0.2, y: 0.2)
            view.alpha = 0.2
        } completion: { (status) in
            view.removeFromSuperview()
            view.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            view.alpha = 1
            self.timerCounter = 30
            self.strokeEnd = 0
        }
    }
    
    func friendRandomAnswerGenerate(question: Question) {
        var friendAnswer = "Я думаю, что правильный ответ это - "
        
        let answerA = RandomAnswersByFriendCall()
        let answerB = RandomAnswersByFriendCall()
        let answerC = RandomAnswersByFriendCall()
        let answerD = RandomAnswersByFriendCall()
        
        var count = 0
        var selectedAnswerByFriend = RandomAnswersByFriendCall()
        
        let answersArray = [answerA, answerB, answerC, answerD]
        
        question.answers.forEach { (answer) in
            var randomiser = 0.0
            
            switch answer {
            case question.trueAnswer:
                randomiser = Double.random(in: 40...100)
            case "":
                randomiser = 0.0
            default:
                randomiser = Double.random(in: 0...90)
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
    
}

class ConsoleView: UIView {
    
    var friendCallView = FriendCallView()
    
    var auditoryHelpView = AuditoryHelpView()
    
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
        
        friendCallView.frame = bounds
        auditoryHelpView.frame = bounds
        
        addSubview(auditoryHelpView)
        addSubview(friendCallView)
    }
}
