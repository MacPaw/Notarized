//
//  AppDelegate.m
//  Notarized
//
//  Created by Sergii Kryvoblotskyi on 12/12/18.
//  Copyright © 2018 MacPaw. All rights reserved.
//

#import "NTAppDelegate.h"
#import "NTApplication.h"
#import "NTApplicationsFetcher.h"

@interface NTAppDelegate () <NSTableViewDelegate>

@property (weak) IBOutlet NSTextField *processingLabel;
@property (weak) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@property (weak) IBOutlet NSWindow *window;

@property (nonatomic, strong) NSArray <NSSortDescriptor *> *sortDescriptors;
@property (nonatomic, strong) NSArray<NTApplication *> *applications;

@property (nonatomic) BOOL isProcessing;
@property (nonatomic) NSInteger processedApplicationsCount;
@property (nonatomic) NSInteger applicationsCount;

@property (nonatomic, strong) dispatch_queue_t workingQueue;

@end

@implementation NTAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES],
                             [NSSortDescriptor sortDescriptorWithKey:@"path" ascending:YES],
                             [NSSortDescriptor sortDescriptorWithKey:@"isNotarized" ascending:NO]];
    self.workingQueue = dispatch_queue_create([[self className] cStringUsingEncoding:NSUTF8StringEncoding], DISPATCH_QUEUE_SERIAL);
    
    NTApplicationsFetcher *fetcher = [NTApplicationsFetcher new];
    NSArray<NTApplication *> *applications = [fetcher fetchDeveloperIDapplications];
    [self _setupLoadingStateWithApplications:applications];
    [self _loadNotarizationStatusesWithApplications:applications];
}

#pragma mark -

- (void)_setupLoadingStateWithApplications:(NSArray<NTApplication *> *)applications
{
    [self _setupViewCollapsed:YES animated:NO];
    self.isProcessing = YES;
    self.applicationsCount = applications.count;
}

- (void)_setupCompletedStateWithApplications:(NSArray<NTApplication *> *)applications
{
    [self _setupViewCollapsed:NO animated:YES];
    self.isProcessing = NO;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isNotarized == YES"];
    NSArray<NTApplication *> *notarizedApps = [applications filteredArrayUsingPredicate:predicate];
    [self _updateProgressLabelWithPrefix:@"Notarization Result:" totalCount:applications.count processedCount:notarizedApps.count];
}

- (void)_setupViewCollapsed:(BOOL)collapsed animated:(BOOL)animated
{
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
        context.duration = animated ? 0.4 : 0.0f;
        self.tableViewHeightConstraint.animator.constant = collapsed ? 0 : 500;
    } completionHandler:^{
        self.tableViewHeightConstraint.active = collapsed;
    }];
}

- (void)_updateProgressLabelWithPrefix:(NSString *)prefix totalCount:(NSInteger)totalCount processedCount:(NSInteger)processedCount
{
    self.processingLabel.stringValue = [NSString stringWithFormat:@"%@ %ld of %ld", prefix, processedCount, totalCount];
}

- (void)_loadNotarizationStatusesWithApplications:(NSArray<NTApplication *> *)applications
{
    dispatch_group_t group = dispatch_group_create();
    [applications enumerateObjectsUsingBlock:^(NTApplication * _Nonnull application, NSUInteger idx, BOOL * _Nonnull stop) {
        dispatch_group_async(group, self.workingQueue, ^{
            [application loadNotarizationStatus];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.processedApplicationsCount++;
                [self _updateProgressLabelWithPrefix:@"Processing:" totalCount:self.applicationsCount processedCount:self.processedApplicationsCount];
            });
        });
    }];
    dispatch_group_notify(group, self.workingQueue, ^ {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.applications = applications;
            [self _setupCompletedStateWithApplications:applications];
        });
    });
}

@end
