import XCGLogger

public struct CommonPackage {
    
    public let logger = log
    public typealias AutoBool = ParserValue<AnyToValueStrategy<BoolCodable>>
    
    public init() {
    }
}
