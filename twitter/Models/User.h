//
//  User.h
//  twitter
//
//  Created by Andres Barragan on 29/06/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSNumber *tweetsCount;
@property (nonatomic, strong) NSNumber *followingCount;
@property (nonatomic, strong) NSNumber *followersCount;
@property (nonatomic, strong) NSURL *profileImage;
@property (nonatomic, strong) NSURL *profileBanner;
//@property (nonatomic, strong) Tweet *lastTweet;

//Initializer
- (instancetype)initWithDictionary:(NSDictionary *)dictionary; 

@end

NS_ASSUME_NONNULL_END
