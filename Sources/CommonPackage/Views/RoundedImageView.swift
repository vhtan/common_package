//
//  File.swift
//  
//
//  Created by Tan Vo on 04/05/2023.
//

import UIKit

open class RoundedImageView: UIImageView {
    
    private var corners: UIRectCorner = []
    
    @IBInspectable open var topLeft: Bool = false {
        didSet {
            if (topLeft) {
                self.corners.insert(.topLeft)
            } else {
                self.corners.remove(.topLeft)
            }
        }
    }
    
    @IBInspectable open var topRight: Bool = false {
        didSet {
            if (topRight) {
                self.corners.insert(.topRight)
            } else {
                self.corners.remove(.topRight)
            }
        }
    }
    
    @IBInspectable open var bottomLeft: Bool = false {
        didSet {
            if (bottomLeft) {
                self.corners.insert(.bottomLeft)
            } else {
                self.corners.remove(.bottomLeft)
            }
        }
    }
    
    @IBInspectable open var bottomRight: Bool = false {
        didSet {
            if (bottomRight) {
                self.corners.insert(.bottomRight)
            } else {
                self.corners.remove(.bottomRight)
            }
        }
    }
    
    @IBInspectable open var roundToCircle: Bool = false
    @IBInspectable open var borderWidthForRounded: CGFloat = 0
    
    var borderLayer = CAShapeLayer()
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if self.roundToCircle {
            self.layer.cornerRadius = self.width() / 2
            return
        }
        
        let maskLayer = CAShapeLayer()
        
        let actualCornerRadius = self.roundToCircle ? self.width() / 2 : self.cornerRadius
        let actualCorners = self.roundToCircle ? [UIRectCorner.allCorners] : self.corners
        
        let path = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: actualCorners, cornerRadii: CGSize(width: actualCornerRadius, height: 0));//Passing height:0 does absolutely nothing. Fuck you stupid Apple engineers
        
        maskLayer.path = path.cgPath
        
        maskLayer.frame = self.bounds
        self.layer.mask = maskLayer
        
        self.borderLayer.path = maskLayer.path
        self.borderLayer.fillColor = UIColor.clear.cgColor
        self.borderLayer.strokeColor = self.borderColor?.cgColor
        self.borderLayer.lineWidth = self.borderWidthForRounded
        self.borderLayer.frame = self.bounds
        
        if (borderLayer.superlayer == nil) {
            self.layer.addSublayer(self.borderLayer)
        }
        
        borderLayer.layoutIfNeeded()
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    @discardableResult
    open func setRoundCornerTopLeft(_ value: Bool) -> Self {
        self.topLeft = value
        return self
    }
    
    @discardableResult
    open func setRoundCornerTopRight(_ value: Bool) -> Self {
        self.topRight = value
        return self
    }
    
    @discardableResult
    open func setRoundCornerBottomLeft(_ value: Bool) -> Self {
        self.bottomLeft = value
        return self
    }
    
    @discardableResult
    open func setRoundCornerBottomRight(_ value: Bool) -> Self {
        self.bottomRight = value
        return self
    }
}
