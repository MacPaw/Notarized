//
//  Application.h
//  Notarized
//
//  Created by Sergii Kryvoblotskyi on 12/12/18.
//  Copyright © 2018 MacPaw. All rights reserved.
//

@import AppKit;

NS_ASSUME_NONNULL_BEGIN

@interface NTApplication : NSObject

- (instancetype)initWithURL:(NSURL *)url;

@property (nonatomic, readonly) BOOL isNotarized;
@property (nonatomic, readonly) BOOL isAppStoreApplication;

@property (nonatomic, strong, readonly) NSImage *icon;

@property (nonatomic, readonly) NSString *path;
@property (nonatomic, readonly) NSString *name;

@end

@interface NTApplication(Unavailable)

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

@interface NTApplication(DataLoading)

- (void)loadNotarizationStatus;

@end

NS_ASSUME_NONNULL_END
