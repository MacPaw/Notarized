//
//  Application.m
//  Notarized
//
//  Created by Sergii Kryvoblotskyi on 12/12/18.
//  Copyright © 2018 MacPaw. All rights reserved.
//

#import "NTApplication.h"
#import "NTTaskRunner.h"

@implementation NTApplication

@synthesize isNotarized = _isNotarized;
@synthesize icon = _icon;

- (instancetype)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self)
    {
        _path = [url path];
        _name = [[url lastPathComponent] stringByDeletingPathExtension];
        _isAppStoreApplication = [self _loadAppStoreStatus];
    }
    return self;
}

- (NSImage *)icon
{
    if (!_icon)
    {
        _icon = [[NSWorkspace sharedWorkspace] iconForFile:self.path];
    }
    return _icon;
}

#pragma mark - Private

- (BOOL)_loadAppStoreStatus
{
    NSString *receiptPath = [self.path stringByAppendingPathComponent:@"Contents/_MASReceipt/receipt"];
    BOOL exists = [[NSURL fileURLWithPath:receiptPath] checkResourceIsReachableAndReturnError:NULL];
    if (exists)
    {
        return YES;
    }
    NSURL *infoPlist = [[NSURL fileURLWithPath:self.path] URLByAppendingPathComponent:@"Contents/Info.plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfURL:infoPlist];
    return [dict[@"CFBundleIdentifier"] hasPrefix:@"com.apple"];
}

@end

@implementation NTApplication (DataLoading)

- (void)loadNotarizationStatus
{
    NSString *result = [NTTaskRunner getOutput:@"/usr/sbin/spctl" arguments:@[@"-a", @"-v", self.path] suppressErrorOutput:NO useErrorOutputAsStd:YES resultCode:NULL];
    [self willChangeValueForKey:@"isNotarized"];
    _isNotarized = [result rangeOfString:@"source=Notarized Developer ID"].location != NSNotFound;
    [self didChangeValueForKey:@"isNotarized"];
}

@end
