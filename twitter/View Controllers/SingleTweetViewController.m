//
//  SingleTweetViewController.m
//  twitter
//
//  Created by Andres Barragan on 30/06/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "SingleTweetViewController.h"
#import "UIImageView+AFNetworking.h"

@interface SingleTweetViewController ()

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

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
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
