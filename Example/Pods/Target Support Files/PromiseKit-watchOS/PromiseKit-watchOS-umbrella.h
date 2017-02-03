#ifdef __OBJC__
#import <Foundation/Foundation.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "AAA-CocoaPods-Hack.h"
#import "AnyPromise.h"
#import "PromiseKit.h"
#import "NSNotificationCenter+AnyPromise.h"
#import "NSTask+AnyPromise.h"
#import "NSURLSession+AnyPromise.h"
#import "PMKFoundation.h"

FOUNDATION_EXPORT double PromiseKitVersionNumber;
FOUNDATION_EXPORT const unsigned char PromiseKitVersionString[];

