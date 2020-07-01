//
//  User.m
//  twitter
//
//  Created by Andres Barragan on 29/06/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User

-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.idStr = dictionary[@"id_str"];
        self.name = dictionary[@"name"];
        self.screenName = [NSString stringWithFormat:@"@%@", dictionary[@"screen_name"]];
        self.followersCount = dictionary[@"followers_count"];
        self.tweetsCount = dictionary[@"statuses_count"];
        self.followingCount = dictionary[@"friends_count"];
//        self.lastTweet = [[Tweet alloc] initWithDictionary:dictionary[@"status"]];
        
        self.profileImage = [NSURL URLWithString:dictionary[@"profile_image_url_https"]];
        self.profileBanner = [NSURL URLWithString:dictionary[@"profile_banner_url"]];
    }
    return self; 
}

@end
