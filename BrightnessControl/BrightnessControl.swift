//
//  BrightnessControl.swift
//  BrightnessControl
//
//  Created by Fedor Volchkov on 9/10/19.
//  Copyright © 2019 Fedor Volchkov. All rights reserved.
//

import Foundation
import UIKit

final class BrightnessControl: UIControl {
    var value: CGFloat = 100 {
        didSet {
            updateBrightnessLayout()
            updateDeviceBrightness()
        }
    }
    
    private let inactiveColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 0.5)
    private let activeColor = UIColor.white
    
    private let brightnessLayer = CALayer()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupInitialValue()
    }
    
    private func commonInit() {
        backgroundColor = inactiveColor
        layer.cornerRadius = 40
        clipsToBounds = true
        brightnessLayer.frame = frame
        brightnessLayer.backgroundColor = activeColor.cgColor
        layer.addSublayer(brightnessLayer)
    }
    
    
    private func setupInitialValue() {
        let brightness = UIScreen.main.brightness
        self.value = self.value / brightness
    }
    
    private func updateDeviceBrightness() {
        let brightness = (value / frame.height)
        UIScreen.main.brightness = brightness
    }
    
    private func updateBrightnessLayout() {
        brightnessLayer.frame = CGRect(x: bounds.origin.x, y: bounds.height - value, width: frame.width, height: value)
    }
}

extension BrightnessControl {
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        value = frame.height - touch.location(in: self).y
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        guard frame.height - touch.location(in: self).y < frame.height else { value = frame.height
            return true
        }
        
        guard frame.height - touch.location(in: self).y > 0 else { value = 0
            return true
        }
        value = frame.height - touch.location(in: self).y
        return true
    }
}
