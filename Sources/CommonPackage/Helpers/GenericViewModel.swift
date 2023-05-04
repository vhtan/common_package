//
//  File.swift
//  
//
//  Created by Tan Vo on 04/05/2023.
//

import Foundation

public protocol GenericViewModel {
    
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}
