//
//  NTTaskRunner.m
//  Notarized
//
//  Created by Sergii Kryvoblotskyi on 12/12/18.
//  Copyright © 2018 MacPaw. All rights reserved.
//

#import "NTTaskRunner.h"

static CGFloat NTTaskRunningWaitTime = 0.01f;

@implementation NTTaskRunner

/// configurable task exec suppressErrorOutput = YES - error output => null
/// useErrorOutputAsStd = YES - return error output
+ (NSString *)getOutput:(NSString *)cmd arguments:(NSArray *)args suppressErrorOutput:(BOOL)suppressErrorOutput useErrorOutputAsStd:(BOOL)useErrorOutputAsStd resultCode:(NSInteger *)resultCode
{
    NSString *rawoutput = nil;

    @try
    {
        if (![[NSFileManager defaultManager] isExecutableFileAtPath:cmd])
        {
            NSLog(@"Unable to execute %@. File doesn't seem to be executable.", cmd);
            return nil;
        }

        // create task and pipe objects
        NSTask *task = [[NSTask alloc] init];
        NSPipe *outputPipe = [[NSPipe alloc] init];
        NSPipe *errorPipe = [[NSPipe alloc] init];

        // setup binary and arguments
        task.launchPath = cmd;
        task.standardOutput = outputPipe;
        // and all error output goes to our pipe, not console
        if (suppressErrorOutput || useErrorOutputAsStd)
        {
            task.standardError = errorPipe;
        }
        task.arguments = args;

        // launch task
        [task launch];

        NSData *result = [[useErrorOutputAsStd ? errorPipe : outputPipe fileHandleForReading] readDataToEndOfFile];
        if (result)
        {
            rawoutput = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
            if ([[rawoutput stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)
            {
                rawoutput = nil;
            }
        }
        while (task.isRunning)
        {
            [NSThread sleepForTimeInterval:NTTaskRunningWaitTime];
        }

        if (resultCode != NULL)
        {
            *resultCode = task.terminationStatus;
        }
        // cleanup
        [[errorPipe fileHandleForReading] closeFile];
        [[outputPipe fileHandleForReading] closeFile];
    }
    @catch (NSException *e)
    {
        NSLog(@"Error while invoking command %@ with args %@ : %@", cmd, args, [e reason]);
    }

    return rawoutput;
}

@end
