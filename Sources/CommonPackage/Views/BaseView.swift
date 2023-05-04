//
//  File.swift
//  
//
//  Created by Tan Vo on 04/05/2023.
//

import UIKit
import RxSwift

open class BaseView: UIView {
    
    open var disposeBag = DisposeBag()
    
    open func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        nib.instantiate(withOwner: self, options: nil)
    }
}
