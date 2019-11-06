//
//  BrightnessControlVC.swift
//  BrightnessControl
//
//  Created by Fedor Volchkov on 9/10/19.
//  Copyright © 2019 Fedor Volchkov. All rights reserved.
//

import Foundation
import UIKit

final class BrightnessControlVC: UIViewController {
    
    private var window: UIWindow?
    private var previousWindow: UIWindow?
    private var blurEffectView: UIVisualEffectView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }
    
    func start() {
        previousWindow = UIApplication.shared.keyWindow
        window = UIWindow()
        window?.rootViewController = self
        window?.windowLevel = .alert
        window?.makeKeyAndVisible()
        window?.isOpaque = false
        window?.backgroundColor = .clear
        
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView?.frame = CGRect(x: view.center.x, y: view.center.y, width: 0, height: 0)
        UIView.animate(withDuration: 0.3) {
            self.blurEffectView?.frame = self.view.bounds
        }
        
        let brightnessControl = BrightnessControl()
        brightnessControl.delegate = self
        brightnessControl.frame = CGRect(x: 0, y: 0, width: view.frame.width / 2 - 50, height: 300)
        brightnessControl.center = view.center
        view.addSubview(brightnessControl)
        view.addSubview(blurEffectView!)
        view.bringSubviewToFront(brightnessControl)
    }
}

extension BrightnessControlVC: BrightnessControlDelegate {
    func brightnessControlDidTapClose() {
        UIView.animate(withDuration: 0.3, animations: {
            self.blurEffectView?.frame = CGRect(x: self.view.center.x, y: self.view.center.y, width: 0, height: 0)
            self.blurEffectView?.alpha = 0
        }, completion:  { _ in
            self.previousWindow?.makeKeyAndVisible()
            self.window = nil
        })
    }
}
