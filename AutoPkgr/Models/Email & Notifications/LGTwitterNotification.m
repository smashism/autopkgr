//
//  LGTwitterNotification.m
//  AutoPkgr
//
//  Created by James Barclay on 7/30/15.
//  Copyright 2015 The Linde Group, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "LGTwitterNotification.h"
#import "LGDefaults.h"

#import "STTwitter.h"

static NSString *const TwitterLink = @"https://support.apple.com/kb/PH18993?locale=en_US";

static NSString *const TwitterNotificationEnabledKey = @"TwitterNotificationEnabled";

@implementation LGTwitterNotification

#pragma mark - Protocol Conforming
+ (NSString *)serviceDescription
{
    return @"AutoPkgr Twitter";
}

+ (BOOL)reportsIntegrations
{
    return NO;
}

+ (BOOL)isEnabled
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:TwitterNotificationEnabledKey];
}

+ (BOOL)storesInfoInKeychain
{
    return YES;
}

+ (NSString *)account
{
    return @"AutoPkgr Twitter API Token";
}

+ (NSURL *)serviceURL
{
    return [NSURL URLWithString:TwitterLink];
}

#pragma mark - Send
- (void)send:(void (^)(NSError *))complete
{
    self.notificatonComplete = complete;
    NSString *message = self.report.emailSubjectString;
    [self.twitter postStatusUpdate:message inReplyToStatusID:nil latitude:nil longitude:nil placeID:nil displayCoordinates:nil trimUser:nil successBlock:^(NSDictionary *status) {
        NSLog(@"Success: %@.", status);
    } errorBlock:^(NSError *error) {
        NSLog(@"Error: %@.", error);
    }];
}

- (void)sendTest:(void (^)(NSError *))complete
{
    self.notificatonComplete = complete;
    NSString *message = NSLocalizedString(@"Testing Twitter notifications from AutoPkgr!",
                                          @"Twitter testing message");
    [self.twitter postStatusUpdate:message inReplyToStatusID:nil latitude:nil longitude:nil placeID:nil displayCoordinates:nil trimUser:nil successBlock:^(NSDictionary *status) {
        NSLog(@"Success: %@.", status);
    } errorBlock:^(NSError *error) {
        NSLog(@"Error: %@.", error);
    }];
}

#pragma mark - Private
- (STTwitterAPI *)twitter
{
    return [STTwitterAPI twitterAPIOSWithFirstAccount];
}

@end
