//
//  TweetCell.m
//  twitter
//
//  Created by Andres Barragan on 29/06/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)initCellWithTweet:(Tweet *)tweet {
    self.tweet = tweet;
    self.createdAtLabel.text = tweet.createdAtString;
    self.contentTextLabel.text = tweet.text;
    self.favoriteCountLabel.text = [@(tweet.favoriteCount) stringValue];
    self.retweetCountLabel.text = [@(tweet.retweetCount) stringValue];
    self.userNameLabel.text = tweet.user.name;
    self.userScreenNameLabel.text = tweet.user.screenName;
    self.favoriteButton.selected = self.tweet.favorited;
    self.retweetButton.selected = self.tweet.retweeted;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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

@end
