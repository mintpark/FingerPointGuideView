//
//  FingerPointGuideViewController.swift
//
//  Created by mint on 2017. 2. 10..
//  Copyright © 2017년 mint. All rights reserved.
//

import UIKit

protocol FingerPointGuideViewDelegate: class {
    func didEndedFingerPointAnimation()
}

class FingerPointGuideView: UIView {

    private var pulsator: Pulsator!
    private var pulseDotView: UIView!
    private var coverView: UIView!
    private var keyWindow: UIWindow!
    private var animationDuration: TimeInterval!
    
    weak var delegate: FingerPointGuideViewDelegate?
    
    init(x: CGFloat, y: CGFloat, pulseInterval: TimeInterval) {
        super.init(frame: UIScreen.main.bounds)
        initialize(x: x, y: y, pulseInterval: pulseInterval)
    }
    
    private func initialize(x: CGFloat, y: CGFloat, pulseInterval: TimeInterval) {
        pulsator = Pulsator()
        pulsator.frame = CGRect(x: x, y: y , width: 0, height: 0)
        pulsator.backgroundColor = UIColor(hexString: Constants.Color.MEMEBOX)?.cgColor
        pulsator.fromValueForRadius = 0.4
        pulsator.numPulse = 3
        pulsator.radius = 18
        pulsator.animationDuration = 1.5
        pulsator.pulseInterval = pulseInterval
        pulsator.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        self.animationDuration = pulseInterval
        keyWindow = UIApplication.shared.keyWindow!
        if keyWindow == nil { return } 
        
        coverView = UIView()
        keyWindow.addSubview(coverView)
        coverView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(keyWindow)
        }
        coverView.layer.addSublayer(pulsator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func start() {
        pulsator.start()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + self.animationDuration, execute: {
            self.stop()
            self.delegate?.didEndedFingerPointAnimation()
        })
    }
    
    func stop() {
        pulsator.stop()
        if let _ = coverView.superview {
            coverView.removeFromSuperview()
        }
    }
}

