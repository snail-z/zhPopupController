#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "MLeaksFinder.h"
#import "NSObject+MemoryLeak.h"

FOUNDATION_EXPORT double MLeaksFinderVersionNumber;
FOUNDATION_EXPORT const unsigned char MLeaksFinderVersionString[];

