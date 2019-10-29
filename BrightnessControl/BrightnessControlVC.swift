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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    func start() {
        window = UIWindow()
        window?.rootViewController = self
        window?.windowLevel = .alert
        window?.makeKeyAndVisible()
//        window?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
//        let blurEffect = UIBlurEffect(style: .dark)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = view.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        window?.addSubview(blurEffectView)
        
        let brightnessControl = BrightnessControl()
        brightnessControl.frame = CGRect(x: 0, y: 0, width: view.frame.width / 2, height: 300)
        brightnessControl.center = view.center
        view.addSubview(brightnessControl)
    }
}
