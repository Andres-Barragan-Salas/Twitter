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
        self.name = dictionary[@"name"];
        self.screenName = [NSString stringWithFormat:@"@%@", dictionary[@"screen_name"]];
        
        self.profileImage = [NSURL URLWithString:dictionary[@"profile_image_url_https"]];
        self.profileBanner = [NSURL URLWithString:dictionary[@"profile_banner_url"]];
    }
    return self; 
}

@end
