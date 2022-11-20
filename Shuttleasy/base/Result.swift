//
//  Result.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 17.11.2022.
//

import Foundation

class AnyResult<T> {
    public private(set) var value : T?
    public private(set) var error : Error?
    
    private init(value: T) {
        self.value = value
        self.error = nil
    }
    
    private init(error: Error) {
        self.value = nil
        self.error = error
    }
    
    public static func success(_ value: T) -> AnyResult<T> {
        return AnyResult(value: value)
    }
    
    public static func failure(error: Error) -> AnyResult<T> {
        return AnyResult(error: error)
    }
    
    public static func failure<T>(error: Error) -> AnyResult<T> {
        return AnyResult<T>(error: error)
    }

    public func isSuccess() -> Bool {
        return value != nil && error == nil
    }
    
    public func isError() -> Bool {
        return value == nil && error != nil
    }
    
    public func map<R>(
        builderBlock : (T) -> AnyResult<R>
    ) -> AnyResult<R> {
        var result : AnyResult<R>
        if self.isError() {
            result = AnyResult.failure(error: error!)
        } else {
            result = builderBlock(value!)
        }
        
        return result
    }
}
