import XCGLogger

@_exported import RxSwift
@_exported import RxCocoa
@_exported import RxRelay
@_exported import RxGesture
@_exported import SnapKit
@_exported import KeychainAccess
@_exported import SwiftyAttributes
@_exported import Cosmos

public struct CommonPackage {
    
    public let logger = log
    public typealias AutoBool = ParserValue<AnyToValueStrategy<BoolCodable>>
    
    public init() {
        
    }
}
