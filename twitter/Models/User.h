//
//  User.h
//  twitter
//
//  Created by Andres Barragan on 29/06/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSURL *profileImage;
@property (nonatomic, strong) NSURL *profileBanner;

//Initializer
- (instancetype)initWithDictionary:(NSDictionary *)dictionary; 

@end

NS_ASSUME_NONNULL_END
