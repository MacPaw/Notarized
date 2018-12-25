//
//  BoolToCheckmarkTransformer.m
//  Notarized
//
//  Created by Sergii Kryvoblotskyi on 12/19/18.
//  Copyright © 2018 MacPaw. All rights reserved.
//

@import AppKit;

#import "NTBoolToCheckmarkTransformer.h"

@implementation NTBoolToCheckmarkTransformer

- (id)transformedValue:(NSNumber *)value
{
    NSString *name = [value boolValue] ? @"CheckmarkChecked" : @"CheckmarkUnchecked";
    return [NSImage imageNamed:name];
}

@end
