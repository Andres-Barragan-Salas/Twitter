//
//  SingleTweetViewController.m
//  twitter
//
//  Created by Andres Barragan on 30/06/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "SingleTweetViewController.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
#import "UserViewController.h"
#import <ResponsiveLabel.h>
#import "APIManager.h"

@interface SingleTweetViewController ()

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet ResponsiveLabel *contentTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIImageView *mediaImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mediaConstraint;

@end

@implementation SingleTweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.createdAtLabel.text = self.tweet.createdAtString;
    self.contentTextLabel.text = self.tweet.text;
    self.favoriteCountLabel.text = [@(self.tweet.favoriteCount) stringValue];
    self.retweetCountLabel.text = [@(self.tweet.retweetCount) stringValue];
    self.userNameLabel.text = self.tweet.user.name;
    self.userScreenNameLabel.text = self.tweet.user.screenName;
    self.favoriteButton.selected = self.tweet.favorited;
    self.retweetButton.selected = self.tweet.retweeted;
    
    // Profile image request
    self.profileImageView.layer.cornerRadius = 10;
    self.profileImageView.image = [UIImage imageNamed:@"profile-Icon"];
    NSURLRequest *profileImageRequest = [NSURLRequest requestWithURL:self.tweet.user.profileImage];
    [self.profileImageView setImageWithURLRequest:profileImageRequest placeholderImage:nil
    success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
        if (imageResponse) {
            self.profileImageView.alpha = 0.0;
            self.profileImageView.image = image;
            
            [UIView animateWithDuration:0.3 animations:^{
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
        NSURLRequest *mediaImageRequest = [NSURLRequest requestWithURL:self.tweet.mediaURL];
        [self.profileImageView setImageWithURLRequest:mediaImageRequest placeholderImage:nil
        success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
            if (imageResponse) {
                self.mediaImageView.alpha = 0.0;
                self.mediaImageView.image = image;

                [UIView animateWithDuration:0.3 animations:^{
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        
        composeController.tweet = self.tweet;
    }
    else {
        UserViewController *userViewController = [segue destinationViewController];
        userViewController.user = self.tweet.user;
    }
}


@end
