//
//  NTApplicationsFetcher.h
//  Notarized
//
//  Created by Sergii Kryvoblotskyi on 12/25/18.
//  Copyright © 2018 MacPaw. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@class NTApplication;
@interface NTApplicationsFetcher : NSObject

- (NSArray<NTApplication *> *)fetchDeveloperIDapplications;

@end

NS_ASSUME_NONNULL_END
