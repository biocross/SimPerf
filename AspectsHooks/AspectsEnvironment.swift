//
//  AspectsEnvironment.swift
//  Pods
//
//  Created by Chirag on 24/05/17.
//
//

import Foundation
import Aspects

/// Environment which holds information about the methods being swizzled
@objc public class AspectsEnvironment: NSObject {
    /// Aspects environment singleton
    static public let environment = AspectsEnvironment()
    
    /// Swizzling methods
    var swizzlingMethods = [String: SwizzledMethod]()
}

//Value or reference types updates AspectsEnvironment class with the following functions
extension AspectsEnvironment {
    /// Adding method to the swizzling methods dictionary of this class
    ///
    /// - Parameters:
    ///   - selector: selector
    ///   - token: token
    public func add(selector: Selector, with token: AspectToken) {
        let swizzledMethod = SwizzledMethod(name: selector.description, token: token)
        AspectsEnvironment.environment.swizzlingMethods[selector.description] = swizzledMethod
    }
    
    /// Used to update the swizzled method already present
    ///
    /// - Parameters:
    ///   - selector: selector
    ///   - type: whether the selector is hooked before/after/instead of the actual implementation
    public func update(_ selector: Selector, with type: HookType) {
        //Checking if selector exists
        guard let swizzledMethod = AspectsEnvironment.environment.swizzlingMethods[selector.description] else {
            return
        }
        switch(type) {
        case .beforeSelector:
            //If before selector, we update the start time
            swizzledMethod.startTime = Date().timeIntervalSince1970
            
        case .afterSelector:
            //If after selector, we update the end time
            swizzledMethod.endTime = Date().timeIntervalSince1970
            
        default: break
        }
    }
}

extension AspectsEnvironment {
    
    @objc public func computePerformance(for delegateClass: NSObject) {
        guard let appDelegate = delegateClass as? AnyClass else {
            return
        }
        
        //responds to selector (UIApplicationDelegate.application(_:didFinishLaunchingWithOptions:))
        if appDelegate.instancesRespond(to: #selector(UIApplicationDelegate.application(_:didFinishLaunchingWithOptions:))) {
            delegateClass.hook(#selector(UIApplicationDelegate.application(_:didFinishLaunchingWithOptions:)), type: .beforeSelector)
            delegateClass.hook(#selector(UIApplicationDelegate.application(_:didFinishLaunchingWithOptions:)), type: .afterSelector)
        }
        
        //responds to selector (UIApplicationDelegate.applicationDidBecomeActive(_:))
        if appDelegate.instancesRespond(to: #selector(UIApplicationDelegate.applicationDidBecomeActive(_:))) {
            delegateClass.hook(#selector(UIApplicationDelegate.applicationDidBecomeActive(_:)), type: .beforeSelector)
            delegateClass.hook(#selector(UIApplicationDelegate.applicationDidBecomeActive(_:)), type: .afterSelector)
        }
    }
    
}
