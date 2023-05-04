//
//  File.swift
//  
//
//  Created by Tan Vo on 04/05/2023.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import SnapKit
import NVActivityIndicatorView

public class IndicatorView: UIView {
    
    private let indicator = NVActivityIndicatorView(frame: .init(x: 0, y: 0, width: 50, height: 50),
                                                    type: .circleStrokeSpin,
                                                    color: .gray,
                                                    padding: nil)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupIndicator()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupIndicator()
    }
    
    private func setupIndicator() {
        backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        addSubview(indicator)
        indicator.snp.remakeConstraints { (maker) in
            maker.centerX.centerY.equalToSuperview()
        }
        indicator.startAnimating()
    }
}

public protocol SpinableView: AnyObject {
    var indicator: IndicatorView { get set }
}

extension Reactive where Base : UIView & SpinableView {
    public var isLoading: Binder<Bool> {
        return Binder(self.base) { base, isLoading  in
            if isLoading {
                base.showIndicator()
            }else{
                base.hideIndicator()
            }
        }
    }
}

extension SpinableView where Self : UIView {
    public func showIndicator() {
        if indicator.superview != self {
            addSubview(indicator)
            indicator.snp.remakeConstraints { (marker) in
                marker.trailing.leading.top.bottom.equalToSuperview()
            }
        }
        
        guard let constraint = self.constraints
            .filter({ $0.firstAttribute == .bottom && ($0.firstItem is IndicatorView) })
            .first else { return }
        
        self.layoutIfNeeded()
        indicator.isHidden = false
        constraint.constant = 0
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.layoutIfNeeded()
        }
    }
    
    public func hideIndicator(after: TimeInterval = 0.5) {
        DispatchQueue.main.asyncAfter(deadline: .now() + after) { [weak self] in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.layoutIfNeeded()
            }) { [weak self] (completed) in
                self?.indicator.isHidden = true
            }
        }
    }
}
