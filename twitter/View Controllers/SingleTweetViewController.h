//
//  SingleTweetViewController.h
//  twitter
//
//  Created by Andres Barragan on 30/06/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface SingleTweetViewController : UIViewController

@property (nonatomic, strong) Tweet *tweet;

@end

NS_ASSUME_NONNULL_END
