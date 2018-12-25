//
//  NTApplicationsFetcher.m
//  Notarized
//
//  Created by Sergii Kryvoblotskyi on 12/25/18.
//  Copyright © 2018 MacPaw. All rights reserved.
//

#import "NTApplicationsFetcher.h"
#import "NTApplication.h"

@implementation NTApplicationsFetcher

- (NSArray<NTApplication *> *)fetchDeveloperIDapplications
{
    NSArray *urls = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath:@"/Applications"] includingPropertiesForKeys:nil options:0 error:nil];
    NSMutableArray<NTApplication *> *apps = [NSMutableArray new];
    for (NSURL *url in urls)
    {
        if ([url.pathExtension isEqualToString:@"app"])
        {
            NTApplication *app = [[NTApplication alloc] initWithURL:url];
            if (app.isAppStoreApplication == NO)
            {
                [apps addObject:app];
            }
        }
    }
    return [[apps copy] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
}

@end
