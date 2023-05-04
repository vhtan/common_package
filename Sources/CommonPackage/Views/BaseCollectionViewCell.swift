//
//  File.swift
//  
//
//  Created by Tan Vo on 04/05/2023.
//

import UIKit
import RxSwift

open class BaseCollectionViewCell: UICollectionViewCell {
    
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview != nil {
            self.layoutIfNeeded()
            self.layoutSubviews()
        }
    }
    
    open var disposeBag: DisposeBag!
    
    deinit {
//        log.info(String(describing: self))
        NotificationCenter.default.removeObserver(self)
    }
}
