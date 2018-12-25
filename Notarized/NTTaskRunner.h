//
//  NTTaskRunner.h
//  Notarized
//
//  Created by Sergii Kryvoblotskyi on 12/12/18.
//  Copyright © 2018 MacPaw. All rights reserved.
//

@import Cocoa;

@interface NTTaskRunner : NSObject

+ (NSString *)getOutput:(NSString *)cmd arguments:(NSArray *)args suppressErrorOutput:(BOOL)suppressErrorOutput useErrorOutputAsStd:(BOOL)useErrorOutputAsStd resultCode:(NSInteger *)resultCode;

@end
