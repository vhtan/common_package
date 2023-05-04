//
//  File.swift
//  
//
//  Created by Tan Vo on 04/05/2023.
//

import UIKit
import SnapKit

open class CustomTextView: UITextView {
    
    open var placeholderLabel = UILabel()
    private var placeholderInsets = CGPoint(x: 0, y: 0)
    
    open override var text: String? {
        didSet {
            if let text = text, text != "" {
                placeholderLabel.isHidden = true
            } else {
                placeholderLabel.isHidden = false
            }
        }
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
//        placeholderLabel.frame = CGRect(x: 4, y: placeholderInsets.y, width: self.width() , height: 60)
        
        placeholderLabel.numberOfLines = 0
        placeholderLabel.lineBreakMode = .byWordWrapping
        placeholderLabel.alpha = 0.5
        
        addSubview(placeholderLabel)
        
        placeholderLabel.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(4)
            make.width.equalToSuperview()
            make.top.equalToSuperview().offset(8)
        }
    }
    
    @objc func textViewDidBeginEditing() {
//        UIView.animate(withDuration: 0.15, animations: { [unowned self] in
//            self.placeholderLabel.isHidden = true
//            self.starLabel.isHidden = true
//        })
    }
    
    @objc func textViewDidEndEditing() {
        if self.text != "" {
            self.placeholderLabel.isHidden = true
        } else {
            self.placeholderLabel.isHidden = false
        }
    }
    
    @objc func textViewDidChange() {
        if self.text != "" {
            self.placeholderLabel.isHidden = true
        } else {
            self.placeholderLabel.isHidden = false
        }
    }
    
    open override func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview != nil {
            NotificationCenter.default.addObserver(self, selector: #selector(textViewDidBeginEditing), name: UITextView.textDidBeginEditingNotification, object: self)
            NotificationCenter.default.addObserver(self, selector: #selector(textViewDidEndEditing), name: UITextView.textDidEndEditingNotification, object: self)
            NotificationCenter.default.addObserver(self, selector: #selector(textViewDidChange), name: UITextView.textDidChangeNotification, object: self)
        }
    }
}

public extension CustomTextView {
    func setText(_ text: String?,
                 placeholder: String?,
                 font: UIFont?,
                 color: UIColor? = nil) {
        self.text = text
        self.font = font
        self.placeholderLabel.setText(placeholder,
                                      font: font,
                                      color: color?.withAlphaComponent(0.7))
        self.textColor = color
    }
}
