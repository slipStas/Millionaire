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
        
        abcdLabel.translatesAutoresizingMaskIntoConstraints = false
        abcdLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: self.leadingAnchor, multiplier: 0).isActive = true
        abcdLabel.trailingAnchor.constraint(equalToSystemSpacingAfter: self.trailingAnchor, multiplier: 0).isActive = true
        abcdLabel.bottomAnchor.constraint(equalToSystemSpacingBelow: self.bottomAnchor, multiplier: 0).isActive = true
        abcdLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        UIView.animate(withDuration: 0.5) {
            self.auditoryHelpView.alpha = 1
        }
    }
    
    func animateRemoving(view: UIView) {
        UIView.animate(withDuration: 0.5) {
            view.transform = CGAffineTransform.init(scaleX: 0.2, y: 0.2)
            view.alpha = 0
        } completion: { (status) in
            view.removeFromSuperview()
            view.transform = CGAffineTransform.init(scaleX: 1, y: 1)
        }
    }
    
    func animateColumns() {
        
        let columnAHeight = CGFloat.random(in: 0...100)
        let columnBHeight = CGFloat.random(in: 0...100)
        let columnCHeight = CGFloat.random(in: 0...100)
        let columnDHeight = CGFloat.random(in: 0...100)
        
        UIView.animate(withDuration: 2, delay: 1) {
            self.columnAView.frame = CGRect(x: self.columnAView.frame.minX, y: self.columnAView.frame.minY - columnAHeight * 3, width: self.columnAView.frame.width, height: self.columnAView.frame.height + columnAHeight * 3)
        }
        UIView.animate(withDuration: 2, delay: 1.1) {
            self.columnBView.frame = CGRect(x: self.columnBView.frame.minX, y: self.columnBView.frame.minY - columnBHeight * 3, width: self.columnBView.frame.width, height: self.columnBView.frame.height + columnBHeight * 3)
        }
        UIView.animate(withDuration: 2, delay: 1.2) {
            self.columnCView.frame = CGRect(x: self.columnCView.frame.minX, y: self.columnCView.frame.minY - columnCHeight * 3, width: self.columnCView.frame.width, height: self.columnCView.frame.height + columnCHeight * 3)
        }
        UIView.animate(withDuration: 2, delay: 1.3) {
            self.columnDView.frame = CGRect(x: self.columnDView.frame.minX, y: self.columnDView.frame.minY - columnDHeight * 3, width: self.columnDView.frame.width, height: self.columnDView.frame.height + columnDHeight * 3)
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
