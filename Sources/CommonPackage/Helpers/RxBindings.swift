//
//  File.swift
//  
//
//  Created by Tan Vo on 04/05/2023.
//

import Foundation
import RxSwift
import RxCocoa

public class AnyObservableType<Element>: ObservableType {
    public typealias E = Element
    
    private let _subscribe: (AnyObserver<E>) -> Disposable
    
    public init<O>(_ observer: O) where O : ObservableType, O.Element == Element {
        self._subscribe = observer.subscribe(_:)
    }
    
    public func subscribe<O>(_ observer: O) -> Disposable where O : ObserverType, O.Element == Element {
        return self._subscribe(observer.asObserver())
    }
}

infix operator <->

public func <-><E>(left: ControlProperty<E>, right: ControlProperty<E>) -> Disposable {
    let leftChannel = RxChannel<E>(withProperty: left)
    let rightChannel = RxChannel<E>.init(withProperty: right)
    
    return CompositeDisposable.init(leftChannel, rightChannel, leftChannel & rightChannel)
}

public func <-><E>(left: BehaviorRelay<E>, right: BehaviorRelay<E>) -> Disposable {
    let leftChannel = RxChannel<E>(withBehaviorRelay: left)
    let rightChannel = RxChannel<E>.init(withBehaviorRelay: right)
    
    return CompositeDisposable.init(leftChannel, rightChannel, leftChannel & rightChannel)
}

public func <-><E>(left: ControlProperty<E>, right: BehaviorRelay<E>) -> Disposable {
    let leftChannel = RxChannel<E>(withProperty: left)
    let rightChannel = RxChannel<E>.init(withBehaviorRelay: right)
    
    return CompositeDisposable.init(leftChannel, rightChannel, leftChannel & rightChannel)
}

//MARK: - Core RxChannel
public class RxChannel<E>: NSObject {
    public var leadingTerminal: RxChannelTerminal<E>?
    public var followingTerminal: RxChannelTerminal<E>?
    
    private var isSkippingNextUpdate = false
    private var keyPath: String?
    private var target: E?
    
    private let disposeBag = DisposeBag()
    
    public override init() {
        let leadingSubject = ReplaySubject<E>.create(bufferSize: 0)
        let followingSubject = ReplaySubject<E>.create(bufferSize: 1)
        
        leadingSubject
            .ignoreElements()
            .subscribe(onError: { error in
                followingSubject.onError(error)
            }, onCompleted: {
                followingSubject.onCompleted()
            })
            .disposed(by: self.disposeBag)
        
        followingSubject
            .ignoreElements()
            .subscribe(onError: { error in
                leadingSubject.onError(error)
            }, onCompleted: {
                leadingSubject.onCompleted()
            })
            .disposed(by: self.disposeBag)
        
        self.leadingTerminal = RxChannelTerminal<E>.init(withValues: AnyObservableType<E>(leadingSubject),
                                                         otherTerminal: AnyObserver<E>(followingSubject))
        self.followingTerminal = RxChannelTerminal<E>.init(withValues: AnyObservableType<E>(followingSubject),
                                                           otherTerminal: AnyObserver<E>(leadingSubject))
    }
}

//MARK: - Init with ControlProperty RxChannel
extension RxChannel {
    convenience init(withProperty property: ControlProperty<E>) {
        self.init()
        
//        _ = property.do { [weak self] in
//            self?.leadingTerminal?.onCompleted()
//        }
        
        _ = property.do(onCompleted: { [weak self] in
            self?.leadingTerminal?.onCompleted()
        })
        
        guard let gLeaTer = self.leadingTerminal else {
            return
        }
        
        property
            .subscribe(onNext: { [weak self] value in
                if self?.isSkippingNextUpdate == true {
                    self?.isSkippingNextUpdate = false
                    
                    return;
                }
                
                gLeaTer.onNext(value)
            })
            .disposed(by: self.disposeBag)
        
        gLeaTer
            .subscribe(onNext: { value in
                property.onNext(value)
            })
            .disposed(by: self.disposeBag)
    }
}

//MARK: - Init with BehaviorRelay RxChannel
extension RxChannel {
    convenience init(withBehaviorRelay relay: BehaviorRelay<E>) {
        self.init()
        
        _ = relay
            .asObservable()
            .do(onCompleted: { [weak self] in
                self?.leadingTerminal?.onCompleted()
            })
        
        guard let gLeaTer = self.leadingTerminal else {
            return
        }
        
        relay
            .asObservable()
            .subscribe(onNext: { [weak self] value in
                if self?.isSkippingNextUpdate == true {
                    self?.isSkippingNextUpdate = false
                    
                    return;
                }
                
                gLeaTer.onNext(value)
            })
            .disposed(by: self.disposeBag)
        
        gLeaTer
            .subscribe(onNext: { [weak self] value in
                self?.isSkippingNextUpdate = true
                
                relay.accept(value)
            })
            .disposed(by: self.disposeBag)
    }
}


//MARK: - Operator Overload RxChannel
extension RxChannel {
    fileprivate static func &(left: RxChannel<E>, right: RxChannel<E>) -> Disposable {
        guard let leftFolTer = left.followingTerminal, let rightFolTer = right.followingTerminal else {
            return Disposables.create()
        }
        
        let r = rightFolTer.bind(to: leftFolTer)
        let l = leftFolTer.skip(1).bind(to: rightFolTer)
        
        return CompositeDisposable.init(r, l)
    }
}

//MARK: - Disposable RxChannel
extension RxChannel: Disposable {
    public func dispose() {}
}

public class RxChannelTerminal<E>: NSObject {
    public typealias Element = E
    
    fileprivate private(set) var values: AnyObservableType<E>?
    fileprivate private(set) var otherTerminal: AnyObserver<E>?
    
    convenience init(withValues values: AnyObservableType<E>, otherTerminal: AnyObserver<E>) {
        self.init()
        
        self.values = values
        self.otherTerminal = otherTerminal
    }
}

extension RxChannelTerminal: ObserverType {
    public func on(_ event: Event<E>) {
        self.otherTerminal?.on(event)
    }
}

extension RxChannelTerminal: ObservableType {
    public func subscribe<O>(_ observer: O) -> Disposable where O : ObserverType, RxChannelTerminal.Element == O.Element {
        return self.values?.subscribe(observer) ?? Disposables.create()
    }
}
