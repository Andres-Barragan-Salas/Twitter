//
//  APIManager.h
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "BDBOAuth1SessionManager.h"
#import "BDBOAuth1SessionManager+SFAuthenticationSession.h"
#import "Tweet.h"
#import "User.h"

@interface APIManager : BDBOAuth1SessionManager

+ (instancetype)shared;

- (void)getHomeTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion;
- (void)postStatusWithText:(NSString *)text completion:(void (^)(Tweet *, NSError *))completion;
- (void)replyTweet:(Tweet *)tweet withText:(NSString *)text completion:(void (^)(Tweet *, NSError *))completion;
- (void)favorite:(Tweet *)tweet remove:(BOOL *)toRemove completion:(void (^)(Tweet *, NSError *))completion;
- (void)retweet:(Tweet *)tweet remove:(BOOL *)toRemove completion:(void (^)(Tweet *, NSError *))completion;
- (void)getProfileInfo:(void(^)(User *user, NSError *error))completion;
- (void)getUserTimeline:(User *)user withCompletion:(void(^)(NSArray *tweets, NSError *error))completion;

@end
