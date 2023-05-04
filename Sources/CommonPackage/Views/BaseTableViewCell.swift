//
//  File.swift
//  
//
//  Created by Tan Vo on 04/05/2023.
//

import UIKit
import RxSwift

open class BaseTableViewCell: UITableViewCell {
    
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview != nil {
            self.layoutIfNeeded()
            self.layoutSubviews()
        }
    }
    
    open var disposeBag: DisposeBag!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
