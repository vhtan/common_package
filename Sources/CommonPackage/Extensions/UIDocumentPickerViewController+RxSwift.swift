//
//  File.swift
//  
//
//  Created by Tan Vo on 04/05/2023.
//

import UIKit
import RxSwift
import RxCocoa

extension UIDocumentPickerViewController: HasDelegate {
    public typealias Delegate = UIDocumentPickerDelegate
}

private class RxUIDocumentPickerDelegateProxy: DelegateProxy<UIDocumentPickerViewController, UIDocumentPickerDelegate>, DelegateProxyType, UIDocumentPickerDelegate {
    
    weak private (set) var controller: UIDocumentPickerViewController?
    
    init(controller: ParentObject) {
        self.controller = controller
        super.init(parentObject: controller, delegateProxy: RxUIDocumentPickerDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        register { RxUIDocumentPickerDelegateProxy(controller: $0) }
    }
}

extension Reactive where Base: UIDocumentPickerViewController {
    
    /// Delegate proxy for `UIDocumentPickerViewController`
    var delegate: DelegateProxy<UIDocumentPickerViewController, UIDocumentPickerDelegate> {
        RxUIDocumentPickerDelegateProxy.proxy(for: base)
    }
    
    /// Tells that user has selected one or more documents.
    @available(iOS 11.0, *)
    var didPickDocumentsAt: Observable<[URL]> {
        delegate
            .methodInvoked(#selector(UIDocumentPickerDelegate.documentPicker(_:didPickDocumentsAt:)))
            .compactMap { $0.last as? [URL] }
    }
    
    /// Tells that user canceled the document picker.
    var documentPickerWasCancelled: Observable<()> {
        delegate
            .methodInvoked(#selector(UIDocumentPickerDelegate.documentPickerWasCancelled(_:)))
            .map {_ in () }
    }
    
    /// Tells that user has selected a document or a destination.
    @available(iOS, introduced: 8.0, deprecated: 11.0, message: "Implement documentPicker:didPickDocumentsAtURLs: instead")
    var didPickDocumentAt: Observable<URL> {
        delegate
            .methodInvoked(#selector(UIDocumentPickerDelegate.documentPicker(_:didPickDocumentAt:)))
            .compactMap { $0.last as? URL }
    }
}

