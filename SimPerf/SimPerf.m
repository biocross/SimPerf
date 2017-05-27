//
//  SimPerf.m
//  Performance
//
//  Created by Chirag on 24/05/17.
//
//

#import <Foundation/Foundation.h>
#import <SimPerf.h>
#import <objc/runtime.h>
#import <SimPerf/SimPerf-Swift.h>

@implementation SimpPerf: NSObject
+(void)load {
    [SimpPerf computePerformance];
}

+(void) computePerformance {
    unsigned int numberOfClasses = 0;
    Class *classes = objc_copyClassList(&numberOfClasses);
    Class appDelegateClass = nil;
    for (unsigned int i = 0; i < numberOfClasses; ++i) {
        if (class_conformsToProtocol(classes[i], @protocol(UIApplicationDelegate))) {
            appDelegateClass = classes[i];
        }
    }
    if(appDelegateClass != nil) {
        [[AspectsEnvironment environment] computePerformanceFor:(NSObject *)appDelegateClass];
    }
}
@end
