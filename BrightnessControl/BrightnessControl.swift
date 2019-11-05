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
    var value: CGFloat = 1 {
        didSet {
            updateBrightnessLayout()
            updateDeviceBrightness()
            updateSunImage()
        }
    }
    
    private let canvasView = UIView()
    private let sunImageView = UIImageView()
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
        backgroundColor = .clear
        brightnessLayer.frame = frame
        brightnessLayer.backgroundColor = activeColor.cgColor
        setupCanvasView()
        setupSunImage()
    }
    
    private func setupCanvasView() {
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(canvasView)
        canvasView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        canvasView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        canvasView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        canvasView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1).isActive = true
        canvasView.isUserInteractionEnabled = false
        canvasView.clipsToBounds = true
        canvasView.backgroundColor = inactiveColor
        canvasView.layer.cornerRadius = 40
        canvasView.layer.addSublayer(brightnessLayer)
    }
    
    
    private func setupInitialValue() {
        let brightness = UIScreen.main.brightness
        self.value = bounds.height * brightness
    }
    
    private func updateDeviceBrightness() {
        let brightness = (value / frame.height)
        UIScreen.main.brightness = brightness
    }
    
    private func updateBrightnessLayout() {
        brightnessLayer.frame = CGRect(x: bounds.origin.x, y: bounds.height - value, width: frame.width, height: value)
    }
    
    private func updateSunImage() {
        switch value {
        case 0...bounds.height * 0.3:
            sunImageView.image = UIImage(named: "sunLow")
        case (bounds.height * 0.3)...(bounds.height * 0.7):
            sunImageView.image = UIImage(named: "sunMid")
        case (bounds.height * 0.7)...(bounds.height):
            sunImageView.image = UIImage(named: "sunTop")
        default:
            sunImageView.image = UIImage(named: "sunMid")
        }
    }
    
    private func setupSunImage() {
        sunImageView.translatesAutoresizingMaskIntoConstraints = false
        sunImageView.image = UIImage(named: "sunLow")
        addSubview(sunImageView)
        sunImageView.bottomAnchor.constraint(equalTo: topAnchor, constant: -20).isActive = true
        sunImageView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        sunImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        sunImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        bringSubviewToFront(sunImageView)
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
