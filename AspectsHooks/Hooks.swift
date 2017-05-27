//
//  Hooks.swift
//  AOP
//
//  Created by Chirag on 20/05/17.
//  Copyright © 2017 Chirag. All rights reserved.
//

import Aspects

/// Hook Type
///
/// - beforeSelector: hooks before the selector is called
/// - afterSelector: hooks after the selector has been executed
/// - inseadOfSelector: replaces the selector's execution
@objc public enum HookType: Int {
    case beforeSelector
    case afterSelector
    case inseadOfSelector
}

extension HookType {
    /// Returns an appropriate Aspect Option
    var aspectOption: AspectOptions {
        switch self {
        case .afterSelector:
            return .optionAutomaticRemoval
        case .beforeSelector:
            return .positionBefore
        case .inseadOfSelector:
            return .positionInstead
        }
    }
}

public extension NSObject {
    /// Hooking selectors for instances
    ///
    /// - Parameters:
    ///   - selector: Selector be be hooked
    ///   - options: Options such as - instead, after and before the actual implementation
    ///   - body: CLosure to be executed
    /// - Returns: Aspect token which can be used to deregister the hooking
    /// - Throws: throws exception
    @objc public final func hook(_ selector: Selector, type: HookType,  body: (@convention(block) (AspectInfo) -> Void)? = nil) {
        //Creating the block which on execution talks to the Aspects Environment to create/update the selector
        
        let block: @convention(block) (AspectInfo) -> Void = { aspectInfo in
            switch(type) {
            case .beforeSelector:
                body?(aspectInfo)
                AspectsEnvironment.environment.update(selector, with: type)
                
            case .afterSelector:
                AspectsEnvironment.environment.update(selector, with: type)
                body?(aspectInfo)
                
            default: break
            }
        }
        do {
            let aspectToken = try self.aspect_hook(selector, with: type.aspectOption, usingBlock: unsafeBitCast(block, to: NSObject.self))
            AspectsEnvironment.environment.add(selector: selector, with: aspectToken)
        } catch let error {
            //Not handling the errors as of now
            print("Error while registering the aspect: \(error)")
        }
    }
    
    /// Hooking selector - class function
    ///
    /// - Parameters:
    ///   - selector: Selector be be hooked
    ///   - options: Options such as - instead, after and before the actual implementation
    ///   - body: CLosure to be executed
    /// - Returns: Aspect token which can be used to deregister the hooking
    /// - Throws: throws exception
    @objc public class func hook(_ selector: Selector, type: HookType, body: (@convention(block) (AspectInfo) -> Void)? = nil) {
        //Creating the block which on execution talks to the Aspects Environment to create/update the selector
        let block: @convention(block) (AspectInfo) -> Void = { aspectInfo in
            switch(type) {
            case .beforeSelector:
                body?(aspectInfo)
                AspectsEnvironment.environment.update(selector, with: type)
                
            case .afterSelector:
                AspectsEnvironment.environment.update(selector, with: type)
                body?(aspectInfo)
                
            default: break
            }
        }
        do {
            let aspectToken = try self.aspect_hook(selector, with: type.aspectOption, usingBlock: unsafeBitCast(block, to: NSObject.self))
            AspectsEnvironment.environment.add(selector: selector, with: aspectToken)
        } catch let error {
            //Not handling the errors as of now
            print("Error while registering the aspect : \(error)")
        }
    }
}

