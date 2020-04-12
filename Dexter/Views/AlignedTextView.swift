//
//  AlignedTextView.swift
//  Dexter
//
//  Created by Sunchit Anand on 2/19/20.
//  Copyright © 2020 Sunchit Anand. All rights reserved.
//

import UIKit

class AlignedTextView: UITextView {
    
    override func awakeFromNib() {
        self.isEditable = false
        self.isUserInteractionEnabled = false
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        
        if action == #selector(UIResponderStandardEditActions.copy(_:)) {
            return false
        }
        if action == #selector(UIResponderStandardEditActions.cut(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension UITextView {
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(0, topOffset)
        contentOffset.y = -positiveTopOffset
    }
}
