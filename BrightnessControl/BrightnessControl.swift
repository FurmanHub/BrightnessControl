//
//  BrightnessControl.swift
//  BrightnessControl
//
//  Created by Fedor Volchkov on 9/10/19.
//  Copyright © 2019 Fedor Volchkov. All rights reserved.
//

import Foundation
import UIKit

protocol BrightnessControlDelegate: class {
    func brightnessControlDidTapClose()
}

final class BrightnessControl: UIControl {
    
    // MARK: - Public properties
    
    var value: CGFloat = 1 {
        didSet {
            guard value < bounds.height else {
                value = bounds.height
                updateUI()
                return
            }
            guard value > 0 else {
                value = 0
                updateUI()
                return
            }
            
            updateUI()
        }
    }
    
    weak var delegate: BrightnessControlDelegate?
    
    // MARK: - Private properties
    
    private let canvasView = UIView()
    private let sunImageView = UIImageView()
    private let inactiveColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 0.5)
    private let activeColor = UIColor.white
    private let brightnessLayer = CALayer()
    private let closeButton = UIButton()
    private var previousTouchLocation: CGPoint?
    
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
    
    // MARK: - Setup
    
    private func commonInit() {
        backgroundColor = .clear
        brightnessLayer.frame = frame
        brightnessLayer.backgroundColor = activeColor.cgColor
        setupCanvasView()
        setupSunImage()
        startAnimation()
        setupCloseButton()
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
    
    private func setupCloseButton() {
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(closeButton)
        closeButton.topAnchor.constraint(equalTo: bottomAnchor, constant: 40).isActive = true
        closeButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        bringSubviewToFront(closeButton)
        closeButton.addTarget(self, action: #selector(closeControl), for: .touchUpInside)
        closeButton.setImage(UIImage(named: "deleteIcon"), for: .normal)
    }
    
    // MARK: - Update UI
    
    private func updateDeviceBrightness() {
        let brightness = (value / frame.height)
        UIScreen.main.brightness = brightness
    }
    
    private func updateBrightnessLayout() {
        brightnessLayer.frame = CGRect(x: bounds.origin.x, y: bounds.height - value, width: frame.width, height: value)
    }
    
    private func updateUI() {
        updateBrightnessLayout()
        updateDeviceBrightness()
        updateSunImage()
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
    
    private func startAnimation() {
        alpha = 0
        UIView.animate(withDuration: 0.7) {
            self.alpha = 1
        }
    }
    
    // MARK: - Actions
    
    @objc private func closeControl() {
        UIView.animate(withDuration: 0.7, animations: {
            self.alpha = 0
        }, completion: { _ in
            self.delegate?.brightnessControlDidTapClose()
        })
    }
}

extension BrightnessControl {
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        previousTouchLocation = touch.location(in: self)
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        if previousTouchLocation!.y > touch.location(in: self).y {
            value = value - (touch.location(in: self).y - previousTouchLocation!.y)
        } else {
            value = value + (previousTouchLocation!.y - touch.location(in: self).y)
        }
        previousTouchLocation = touch.location(in: self)
        return true
    }
}

extension BrightnessControl {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let pointForCloseButton = closeButton.convert(point, from: self)
        if closeButton.bounds.contains(pointForCloseButton) {
            return closeButton
        }
        return super.hitTest(point, with: event)
    }
}
