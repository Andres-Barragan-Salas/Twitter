//
//  ComposeViewController.m
//  twitter
//
//  Created by Andres Barragan on 29/06/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"

@interface ComposeViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendButton;
@property (weak, nonatomic) IBOutlet UITextView *tweetContent;
@property (weak, nonatomic) IBOutlet UILabel *charCount;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (nonatomic, strong) User *user;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tweetContent.delegate = self;
    
    if(self.tweet) {
        self.sendButton.title = @"Reply";
        self.tweetContent.text = [NSString stringWithFormat:@"%@ ", self.tweet.user.screenName];
    }
    
    [self fetchUserInfo];
    [self.tweetContent becomeFirstResponder];
}

- (void)fetchUserInfo {
    [[APIManager shared] getProfileInfo:^(User *user, NSError *error) {
        if (user) {
            self.user = user;
            
            self.userNameLabel.text = self.user.name;
            self.userScreenNameLabel.text = self.user.screenName;
            
            // Profile image request
            self.userImageView.layer.cornerRadius = 10;
            self.userImageView.image = [UIImage imageNamed:@"profile-Icon"];
            NSURLRequest *profileImageRequest = [NSURLRequest requestWithURL:self.user.profileImage];
            [self.userImageView setImageWithURLRequest:profileImageRequest placeholderImage:nil
            success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
                if (imageResponse) {
                    self.userImageView.alpha = 0.0;
                    self.userImageView.image = image;
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        self.userImageView.alpha = 1.0;
                    }];
                }
                else {
                    self.userImageView.image = image;
                }
            }
            failure:NULL];
        } else {
            NSLog(@"Error getting user: %@", error.localizedDescription);
        }
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    int characterLimit = 140;

    NSString *newText = [self.tweetContent.text stringByReplacingCharactersInRange:range withString:text];

    self.charCount.text = [@(characterLimit - newText.length) stringValue];

    return newText.length < characterLimit;
}

- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)tweetAction:(id)sender {
    if (self.tweet) {
        [[APIManager shared] replyTweet:self.tweet withText:self.tweetContent.text completion:^(Tweet *tweet, NSError *error) {
            if (error) {
                NSLog(@"Error replying to Tweet: %@", error.localizedDescription);
            } else {
                [self.delegate didTweet:tweet];
                NSLog(@"Compose reply Success!");
                [self dismissViewControllerAnimated:true completion:nil];
            }
        }];
    }
    else {
        [[APIManager shared] postStatusWithText:self.tweetContent.text completion:^(Tweet *tweet, NSError *error) {
            if (error) {
                NSLog(@"Error composing Tweet: %@", error.localizedDescription);
            } else {
                [self.delegate didTweet:tweet];
                NSLog(@"Compose Tweet Success!");
                [self dismissViewControllerAnimated:true completion:nil];
            }
        }];
    }
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
