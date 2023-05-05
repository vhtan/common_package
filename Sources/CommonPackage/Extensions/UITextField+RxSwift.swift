//
//  File.swift
//  
//
//  Created by Tan Vo on 04/05/2023.
//

import UIKit
import RxSwift
import RxCocoa

extension UITextField {

    /// Factory method that enables subclasses to implement their own `delegate`.
    ///
    /// - returns: Instance of delegate proxy that wraps `delegate`.
    func createRxDelegateProxy() -> RxTextFieldDelegateProxy {
        return RxTextFieldDelegateProxy(textField: self)
    }
}

extension Reactive where Base: UITextField {

    /// Reactive wrapper for `delegate`.
    ///
    /// For more information take a look at `DelegateProxyType` protocol documentation.
    var delegate: DelegateProxy<UITextField, UITextFieldDelegate> {
        return RxTextFieldDelegateProxy.proxy(for: base)
    }

    /// Reactive wrapper for `delegate` message.
    var shouldReturn: ControlEvent<Void> {
        let source = delegate.rx.methodInvoked(#selector(UITextFieldDelegate.textFieldShouldReturn))
            .map { _ in }

        return ControlEvent(events: source)
    }

    var shouldClear: ControlEvent<Void> {
        let source = delegate.rx.methodInvoked(#selector(UITextFieldDelegate.textFieldShouldClear))
            .map { _ in }

        return ControlEvent(events: source)
    }
}

class RxTextFieldDelegateProxy: DelegateProxy<UITextField, UITextFieldDelegate>, DelegateProxyType, UITextFieldDelegate {

    static func currentDelegate(for object: UITextField) -> UITextFieldDelegate? {
        return object.delegate
    }

    static func setCurrentDelegate(_ delegate: UITextFieldDelegate?, to object: UITextField) {
        object.delegate = delegate
    }

    /// Typed parent object.
    weak private(set) var textField: UITextField?

    /// - parameter textfield: Parent object for delegate proxy.
    init(textField: ParentObject) {
        self.textField = textField
        super.init(parentObject: textField, delegateProxy: RxTextFieldDelegateProxy.self)
    }

    // Register known implementations
    static func registerKnownImplementations() {
        register(make: RxTextFieldDelegateProxy.init)
    }

    // MARK: delegate methods
    /// For more information take a look at `DelegateProxyType`.
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return forwardToDelegate()?.textFieldShouldReturn?(textField) ?? true
    }

    @objc func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return forwardToDelegate()?.textFieldShouldClear?(textField) ?? true
    }
}
