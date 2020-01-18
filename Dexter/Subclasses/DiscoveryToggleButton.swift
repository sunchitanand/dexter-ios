//
//  DiscoveryToggleButton.swift
//  Dexter
//
//  Created by Sunchit Anand on 1/13/20.
//  Copyright © 2020 Sunchit Anand. All rights reserved.
//

import UIKit

class DiscoveryToggleButton: UIButton {
    
    var isOn = false
    var name = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initButton()
    }
    
    func initButton() {
        layer.borderWidth = 2.0
        layer.borderColor = .init(srgbRed: 0, green: 0, blue: 250, alpha: 1)
        layer.cornerRadius = frame.size.height/2
        
        setTitleColor(UIColor.systemBlue, for: .normal)
        addTarget(self, action: #selector(DiscoveryToggleButton.buttonPressed), for: .touchUpInside)
    }
    
    @objc func buttonPressed() {
        activateButton(bool: !isOn)
    }
    
    func activateButton(bool: Bool) {
        isOn = bool
        
        let color = bool ? UIColor.systemBlue : .clear
        let title = bool ? "ON" : "OFF"
        let titleColor = bool ? .white : UIColor.systemBlue
        
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        backgroundColor = color
    }
}
