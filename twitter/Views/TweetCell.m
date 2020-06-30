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
    
    if(self.tweet.favorited) {
        self.favoriteButton.selected = YES;
    }
    if(self.tweet.retweeted) {
        self.retweetButton.selected = YES;
    }
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

@end
