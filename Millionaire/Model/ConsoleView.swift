//
//  ConsoleView.swift
//  Millionaire
//
//  Created by Stanislav Slipchenko on 20.09.2020.
//  Copyright © 2020 Stanislav Slipchenko. All rights reserved.
//

import UIKit

class FriendCallView: UIView {
    
    var timer : Timer? = Timer()
    var timerCounter = 30 {
        didSet {
            print(timerCounter)
            animateCircle(duration: 0.3)
            if timerCounter == 0 {
                stopTimer()
                animateRemoving(view: self.friendCallView)
            }
        }
    }
    var strokeEnd = 0.0
    
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

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setup(){
        backgroundColor = UIColor.clear
        
        friendCallView.frame = bounds

        addSubview(friendCallView)
        friendCallView.layer.addSublayer(circleLayer)
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
        
        self.strokeEnd += 0.0333
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
}

class AuditoryHelpView: UIView {
    
}

class ConsoleView: UIView {
    
    var friendCallView: FriendCallView?
    
    var auditoryHelpView: AuditoryHelpView?

}
