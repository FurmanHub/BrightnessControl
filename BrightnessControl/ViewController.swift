//
//  ViewController.swift
//  BrightnessControl
//
//  Created by Fedor Volchkov on 9/10/19.
//  Copyright © 2019 Fedor Volchkov. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupBackground()
        setupButton()
    }
    
    private func setupButton() {
        let openMenuButton = UIButton()
        openMenuButton.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        openMenuButton.center = view.center
        openMenuButton.setTitle("Show Brightness Control", for: .normal)
        openMenuButton.setTitleColor(.white, for: .normal)
        openMenuButton.addTarget(self, action: #selector(showControl), for: .touchUpInside)
        view.addSubview(openMenuButton)
    }
    
    private func setupBackground() {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "screen")
        view.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
    }
    
    @objc private func showControl() {
        let brightnessVC = BrightnessControlVC()
        brightnessVC.start()
    }
}

