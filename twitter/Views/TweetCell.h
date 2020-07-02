//
//  TweetCell.h
//  twitter
//
//  Created by Andres Barragan on 29/06/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import <ResponsiveLabel.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TweetCellDelegate;

@interface TweetCell : UITableViewCell

@property (nonatomic, strong) Tweet *tweet;
@property (nonatomic, weak) id<TweetCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet ResponsiveLabel *contentTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIImageView *retweetImage;
@property (weak, nonatomic) IBOutlet UILabel *retweetUser;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweetConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *mediaImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mediaConstraint;

- (void)initCellWithTweet:(Tweet *)tweet;

@end

@protocol TweetCellDelegate

- (void)tweetCell:(TweetCell *) tweetCell didTap: (User *)user;
- (void)replyWithTweetCell:(Tweet *) tweet;

@end

NS_ASSUME_NONNULL_END
