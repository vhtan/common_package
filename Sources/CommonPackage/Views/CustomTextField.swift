//
//  File.swift
//  
//
//  Created by Tan Vo on 04/05/2023.
//

import UIKit

open class CustomTextField: UITextField {
    
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        if newSuperview != nil {
            cornerRadius = 8
            borderWidth = 1
            borderColor = .gray
        }
    }
    
    let padding = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
