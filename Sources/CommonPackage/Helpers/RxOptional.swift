//
//  File.swift
//  
//
//  Created by Tan Vo on 04/05/2023.
//

import Foundation
import RxSwift
import RxCocoa

public protocol OptionalType {
    associatedtype Wrapped
    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    /// Cast `Optional<Wrapped>` to `Wrapped?`
    public var value: Wrapped? {
        return self
    }
}

public enum RxOptionalError: Error, CustomStringConvertible {
    case foundNilWhileUnwrappingOptional(Any.Type)
    case emptyOccupiable(Any.Type)

    public var description: String {
        switch self {
        case .foundNilWhileUnwrappingOptional(let type):
           return "Found nil while trying to unwrap type <\(String(describing: type))>"
        case .emptyOccupiable(let type):
            return "Empty occupiable of type <\(String(describing: type))>"
        }
    }
}

public extension ObservableType where Element: OptionalType {
    /**
     Unwraps and filters out `nil` elements.
     - returns: `Observable` of source `Observable`'s elements, with `nil` elements filtered out.
     */
    
    func filterNil() -> Observable<Element.Wrapped> {
        return self.flatMap { element -> Observable<Element.Wrapped> in
            guard let value = element.value else {
                return Observable<Element.Wrapped>.empty()
            }
            return Observable<Element.Wrapped>.just(value)
        }
    }

    /**
    
    Filters out `nil` elements. Similar to `filterNil`, but keeps the elements of the observable
    wrapped in Optionals. This is often useful for binding to a UIBindingObserver with an optional type.
    - returns: `Observable` of source `Observable`'s elements, with `nil` elements filtered out.
    */

    func filterNilKeepOptional() -> Observable<Element> {
        return self.filter { element -> Bool in
            return element.value != nil
        }
    }

    /**
     Throws an error if the source `Observable` contains an empty element; otherwise returns original source `Observable` of non-empty elements.
     - parameter error: error to throw when an empty element is encountered. Defaults to `RxOptionalError.FoundNilWhileUnwrappingOptional`.
     - throws: `error` if an empty element is encountered.
     - returns: original source `Observable` of non-empty elements if it contains no empty elements.
     */
    
    func errorOnNil(_ error: Error = RxOptionalError.foundNilWhileUnwrappingOptional(Element.self)) -> Observable<Element.Wrapped> {
        return self.map { element -> Element.Wrapped in
            guard let value = element.value else {
                throw error
            }
            return value
        }
    }

    /**
     Unwraps optional elements and replaces `nil` elements with `valueOnNil`.
     - parameter valueOnNil: value to use when `nil` is encountered.
     - returns: `Observable` of the source `Observable`'s unwrapped elements, with `nil` elements replaced by `valueOnNil`.
     */
    
    func replaceNilWith(_ valueOnNil: Element.Wrapped) -> Observable<Element.Wrapped> {
        return self.map { element -> Element.Wrapped in
            guard let value = element.value else {
                return valueOnNil
            }
            return value
        }
    }

    /**
     Unwraps optional elements and replaces `nil` elements with result returned by `handler`.
     - parameter handler: `nil` handler throwing function that returns `Observable` of non-`nil` elements.
     - returns: `Observable` of the source `Observable`'s unwrapped elements, with `nil` elements replaced by the handler's returned non-`nil` elements.
     */
    
    func catchOnNil(_ handler: @escaping () throws -> Observable<Element.Wrapped>) -> Observable<Element.Wrapped> {
        return self.flatMap { element -> Observable<Element.Wrapped> in
            guard let value = element.value else {
                return try handler()
            }
            return Observable<Element.Wrapped>.just(value)
        }
    }
    
    func filterErrors() -> Observable<Element> {
        return materialize()
            .compactMap { $0.element }
    }
}

public extension Driver where Element: OptionalType {
    /**
     Unwraps and filters out `nil` elements.
     - returns: `Observable` of source `Observable`'s elements, with `nil` elements filtered out.
     */
    
    func filterNil() -> Driver<Element.Wrapped> {
        return self.flatMap { element -> Driver<Element.Wrapped> in
            guard let value = element.value else {
                return Driver<Element.Wrapped>.empty()
            }
            return Driver<Element.Wrapped>.just(value)
        }
    }
}
