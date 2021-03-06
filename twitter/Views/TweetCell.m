//
//  TweetCell.m
//  twitter
//
//  Created by Andres Barragan on 29/06/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"

#define ANIMATION_DURATION ((double) 0.3)

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.profileImageView addGestureRecognizer:profileTapGestureRecognizer];
    [self.profileImageView setUserInteractionEnabled:YES];
}

- (void)initCellWithTweet:(Tweet *)tweet {
    self.tweet = tweet;
    
    // Set retweeted legend
    if (tweet.retweetedByUser) {
        [self.retweetImage setHidden:NO];
        [self.retweetUser setHidden:NO];
        [self.retweetConstraint setActive:YES];
        self.retweetUser.text = [NSString stringWithFormat:@"%@ Retweeted", tweet.retweetedByUser.name];
    }
    else {
        [self.retweetConstraint setActive:NO];
        [self.retweetImage setHidden:YES];
        [self.retweetUser setHidden:YES];
    }
    
    self.createdAtLabel.text = [NSString stringWithFormat:@"·  %@", tweet.timeAgoString];
    self.contentTextLabel.text = tweet.text;
    self.userNameLabel.text = tweet.user.name;
    self.userScreenNameLabel.text = tweet.user.screenName;
    self.favoriteButton.selected = self.tweet.favorited;
    self.retweetButton.selected = self.tweet.retweeted;
    
    NSString *favoriteCount = [@(tweet.favoriteCount) stringValue];
    if (tweet.favoriteCount > 1000) {
        favoriteCount = [NSString stringWithFormat:@"%.1f K", (tweet.favoriteCount/1000.00)];
    }
    self.favoriteCountLabel.text = favoriteCount;
    
    NSString *retweetCount = [@(tweet.retweetCount) stringValue];
    if (tweet.retweetCount > 1000) {
        retweetCount = [NSString stringWithFormat:@"%.1f K", (tweet.retweetCount/1000.00)];
    }
    self.retweetCountLabel.text = retweetCount;
    
    // Detect URL, usernames, hashtags
    self.contentTextLabel.userInteractionEnabled = YES;
    PatternTapResponder urlTapAction = ^(NSString *tappedString) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tappedString]];
    };
    [self.contentTextLabel enableURLDetectionWithAttributes:
    @{NSForegroundColorAttributeName:[UIColor systemBlueColor],RLTapResponderAttributeName:urlTapAction}];
    [self.contentTextLabel enableHashTagDetectionWithAttributes:
     @{NSForegroundColorAttributeName:[UIColor systemBlueColor]}];
    [self.contentTextLabel enableUserHandleDetectionWithAttributes:
    @{NSForegroundColorAttributeName:[UIColor systemBlueColor]}];
    
    // Profile image request
    self.profileImageView.layer.cornerRadius = 10;
    self.profileImageView.image = [UIImage imageNamed:@"profile-Icon"];
    NSURLRequest *profileImageRequest = [NSURLRequest requestWithURL:tweet.user.profileImage];
    [self.profileImageView setImageWithURLRequest:profileImageRequest placeholderImage:nil
    success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
        if (imageResponse) {
            self.profileImageView.alpha = 0.0;
            self.profileImageView.image = image;
            
            [UIView animateWithDuration:ANIMATION_DURATION animations:^{
                self.profileImageView.alpha = 1.0;
            }];
        }
        else {
            self.profileImageView.image = image;
        }
    }
    failure:NULL];
    
    // Media image request
    self.mediaImageView.image = nil;
    if (self.tweet.mediaURL != nil){
        [self.mediaConstraint setActive:YES];
        [self.mediaImageView setHidden:NO];
        self.mediaImageView.layer.cornerRadius = 10;
        NSURLRequest *mediaImageRequest = [NSURLRequest requestWithURL:tweet.mediaURL];
        [self.profileImageView setImageWithURLRequest:mediaImageRequest placeholderImage:nil
        success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
            if (imageResponse) {
                self.mediaImageView.alpha = 0.0;
                self.mediaImageView.image = image;

                [UIView animateWithDuration:ANIMATION_DURATION animations:^{
                    self.mediaImageView.alpha = 1.0;
                }];
            }
            else {
                self.mediaImageView.image = image;
            }
        }
        failure:NULL];
    }
    else {
        [self.mediaConstraint setActive:NO];
        [self.mediaImageView setHidden:YES];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    UIColor *intitialColor = self.backgroundColor;
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        self.backgroundColor = UIColor.systemGray6Color;
        self.backgroundColor = intitialColor;
    }];
}

- (IBAction)didTapFavorite:(id)sender {
    [[APIManager shared] favorite:self.tweet remove:(BOOL *)self.tweet.favorited completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error favoriting/unfavoriting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully favorited/unfavorited the following Tweet: %@", tweet.text);
             }
    }];
    
    if(self.tweet.favorited) {
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        
        self.favoriteButton.selected = NO;
    }
    else {
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        
        self.favoriteButton.selected = YES;
    }
    
    self.favoriteCountLabel.text = [@(self.tweet.favoriteCount) stringValue];
}

- (IBAction)didTapRetweet:(id)sender {
    [[APIManager shared] retweet:self.tweet remove:(BOOL *)self.tweet.retweeted completion:^(Tweet *tweet, NSError *error) {
             if(tweet){
                  NSLog(@"Successfully retweeted/unretweeted the following Tweet: %@", tweet.text);
             }
             else{
                  NSLog(@"Error retweeting/unretweeting tweet: %@", error.localizedDescription);
             }
    }];
    
    if(self.tweet.retweeted) {
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        
        self.retweetButton.selected = NO;
    }
    else {
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        
        self.retweetButton.selected = YES;
    }
    
    self.retweetCountLabel.text = [@(self.tweet.retweetCount) stringValue];
}

- (IBAction)didTapReply:(id)sender {
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        UIButton *replyButton = sender;
        replyButton.alpha = 0.5;
        replyButton.alpha = 1;
    }];
    [self.delegate replyWithTweetCell:self.tweet];
}

- (void) didTapUserProfile:(UIGestureRecognizer *)sender {
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        self.profileImageView.alpha = 0.5;
        self.profileImageView.alpha = 1;
    }];
    [self.delegate tweetCell:self didTap:self.tweet.user];
}

@end
