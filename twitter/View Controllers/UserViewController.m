//
//  UserViewController.m
//  twitter
//
//  Created by Andres Barragan on 01/07/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "UIImageView+AFNetworking.h"
#import "UserViewController.h"
#import "TweetCell.h"
#import "APIManager.h"
#import "User.h"

@interface UserViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCount;
@property (weak, nonatomic) IBOutlet UILabel *followersCount;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) User *user;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self fetchUserInfo];
}

- (void)fetchUserInfo {
    [[APIManager shared] getProfileInfo:^(User *user, NSError *error) {
        if (user) {
            self.user = user;
            
            self.userNameLabel.text = self.user.name;
            self.userScreenNameLabel.text = self.user.screenName;
            self.tweetCountLabel.text = [self.user.tweetsCount stringValue];
            self.followingCount.text = [self.user.followingCount stringValue];
            self.followersCount.text = [self.user.followersCount stringValue];
            
            // Profile image request
            self.profileImageView.image = [UIImage imageNamed:@"profile-Icon"];
            NSURLRequest *profileImageRequest = [NSURLRequest requestWithURL:self.user.profileImage];
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
            
            // Banner image request
            self.bannerImageView.image = nil;
            NSURLRequest *bannerImageRequest = [NSURLRequest requestWithURL:self.user.profileBanner];
            [self.bannerImageView setImageWithURLRequest:bannerImageRequest placeholderImage:nil success:NULL failure:NULL];
        } else {
            NSLog(@"Error getting user: %@", error.localizedDescription);
        }
        
        [self getUserTweets];
    }];

}

- (void)getUserTweets {
    [[APIManager shared] getUserTimeline:self.user withCompletion:^(NSArray *tweets, NSError *error) {
            if (tweets) {
                self.tweets = [NSMutableArray arrayWithArray:tweets];
//                NSLog(@"😎😎😎 Successfully loaded user timeline");
            } else {
                NSLog(@"😫😫😫 Error getting user timeline: %@", error.localizedDescription);
            }
            [self.tableView reloadData];
        }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    
    Tweet *tweet = self.tweets[indexPath.row];
    
    [cell initCellWithTweet:tweet];
    
    return cell;
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
