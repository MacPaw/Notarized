//
//  CMTaskRunner.h
//  CleanMyMac
//
//  Created by Vera Tkachenko on 9/29/09.
//  Copyright (c) 2009-2013 MacPaw Inc. All rights reserved.
//

@import Cocoa;

@interface NTTaskRunner : NSObject

+ (NSString *)getOutput:(NSString *)cmd arguments:(NSArray *)args suppressErrorOutput:(BOOL)suppressErrorOutput useErrorOutputAsStd:(BOOL)useErrorOutputAsStd resultCode:(NSInteger *)resultCode;

@end
