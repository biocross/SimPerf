//
//  SwizzledMethod.swift
//  Pods
//
//  Created by Chirag on 24/05/17.
//
//

import Foundation
import Aspects

/// Struct: Swizzled Method (the method which will be swizzled to compute the time taken by it to execute)
public class SwizzledMethod {
    /// Selector name
    let name: String
    
    /// Start time: Time when the selector will start executing
    var startTime: TimeInterval?
    
    /// Time when the selector finished its execution
    var endTime: TimeInterval?
    
    /// Arguments taken by the selector
    var arguments: [Any]?
    
    /// Aspect token - used to deregister the aspect
    var aspectToken: AspectToken
    
    init(name: String, token: AspectToken) {
        self.name = name
        self.aspectToken = token
    }
}
