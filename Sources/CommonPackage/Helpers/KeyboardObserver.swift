//
//  File.swift
//  
//
//  Created by Tan Vo on 04/05/2023.
//

import UIKit
import RxSwift
import RxCocoa
import RxSwiftExt

public final class KeyboardObserver {
    
    struct KeyboardInfo {
        
        let frameBegin: CGRect
        let frameEnd: CGRect
        
        init(notification: NSNotification) {
            let frameEnd = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            let frameBegin = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as AnyObject).cgRectValue
            self.frameBegin = frameBegin!
            self.frameEnd = frameEnd!
        }
    }
    
    let willChangeFrame = PublishSubject<KeyboardInfo>()
    let didChangeFrame = PublishSubject<KeyboardInfo>()
    
    let willShow = PublishSubject<KeyboardInfo>()
    let didShow = PublishSubject<KeyboardInfo>()
    let willHide = PublishSubject<KeyboardInfo>()
    let didHide = PublishSubject<KeyboardInfo>()
    
    init() {
        
        NotificationCenter.default
            .rx.notification(UIResponder.keyboardWillChangeFrameNotification)
            .map { KeyboardInfo(notification: $0 as NSNotification) }
            .bind(to: self.willChangeFrame)
            .disposed(by: self.disposeBag)
        
        NotificationCenter.default
            .rx.notification(UIResponder.keyboardDidChangeFrameNotification)
            .map { KeyboardInfo(notification: $0 as NSNotification) }
            .bind(to: self.didChangeFrame)
            .disposed(by: self.disposeBag)
        
        NotificationCenter.default
            .rx.notification(UIResponder.keyboardWillShowNotification)
            .map { KeyboardInfo(notification: $0 as NSNotification) }
            .bind(to: self.willShow)
            .disposed(by: self.disposeBag)
        
        NotificationCenter.default
            .rx.notification(UIResponder.keyboardDidShowNotification)
            .map { KeyboardInfo(notification: $0 as NSNotification) }
            .bind(to: self.didShow)
            .disposed(by: self.disposeBag)
        
        NotificationCenter.default
            .rx.notification(UIResponder.keyboardWillHideNotification)
            .map { KeyboardInfo(notification: $0 as NSNotification) }
            .bind(to: self.willHide)
            .disposed(by: self.disposeBag)
        
        NotificationCenter.default
            .rx.notification(UIResponder.keyboardDidHideNotification)
            .map { KeyboardInfo(notification: $0 as NSNotification) }
            .bind(to: self.didHide)
            .disposed(by: self.disposeBag)
    }
    
    private let disposeBag = DisposeBag()
}
