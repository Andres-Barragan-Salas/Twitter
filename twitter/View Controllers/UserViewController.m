//
//  UserViewController.m
//  twitter
//
//  Created by Andres Barragan on 01/07/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
#import "SingleTweetViewController.h"
#import "LoginViewController.h"
#import "UserViewController.h"
#import "AppDelegate.h"
#import "TweetCell.h"
#import "APIManager.h"
#import "User.h"

@interface UserViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, TweetCellDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCount;
@property (weak, nonatomic) IBOutlet UILabel *followersCount;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSMutableArray *tweets;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.activityIndicator startAnimating];
    if(self.user == nil) {
        [self fetchUserInfo];
    }
    else {
        [self setUserInfo];
        [self getUserTweets];
        self.navigationItem.title = self.user.name;
    }
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getUserTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)fetchUserInfo {
    [[APIManager shared] getProfileInfo:^(User *user, NSError *error) {
        if (user) {
            self.user = user;
            [self setUserInfo];
        } else {
            NSLog(@"Error getting user: %@", error.localizedDescription);
        }
        
        [self getUserTweets];
    }];
}

- (void) setUserInfo {
    self.userNameLabel.text = self.user.name;
    self.userScreenNameLabel.text = self.user.screenName;
    
    self.followingCount.text = [self.user.followingCount stringValue];
    
    NSString *tweetsCount = [self.user.tweetsCount stringValue];
    if([self.user.tweetsCount intValue] > 1000000) {
        tweetsCount = [NSString stringWithFormat:@"%.1f M", ([self.user.tweetsCount doubleValue]/1000000)];
    }
    else if ([self.user.tweetsCount intValue] > 10000) {
        tweetsCount = [NSString stringWithFormat:@"%.1f K", ([self.user.tweetsCount doubleValue]/1000)];
    }
    self.tweetCountLabel.text = tweetsCount;
    
    NSString *followersCount = [self.user.followersCount stringValue];
    if([self.user.followersCount intValue] > 1000000) {
        followersCount = [NSString stringWithFormat:@"%.1f M", ([self.user.followersCount doubleValue]/1000000)];
    }
    else if ([self.user.followersCount intValue] > 10000) {
        followersCount = [NSString stringWithFormat:@"%.1f K", ([self.user.followersCount doubleValue]/1000)];
    }
    self.followersCount.text = followersCount;
    
    // Profile image request
    self.profileImageView.layer.cornerRadius = 10;
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
}

- (void)getUserTweets {
    [[APIManager shared] getUserTimeline:self.user withCompletion:^(NSArray *tweets, NSError *error) {
            if (tweets) {
                self.tweets = [NSMutableArray arrayWithArray:tweets];
            } else {
                NSLog(@"😫😫😫 Error getting user timeline: %@", error.localizedDescription);
            }
            [self.tableView reloadData];
            [self.activityIndicator stopAnimating];
            [self.refreshControl endRefreshing];
        }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    
    Tweet *tweet = self.tweets[indexPath.row];
    
    cell.delegate = self;
    [cell initCellWithTweet:tweet];
    
    return cell;
}

- (void)didTweet:(Tweet *)tweet {}

- (void)tweetCell:(TweetCell *)tweetCell didTap:(User *)user{
    UserViewController *userViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserViewController"];
    userViewController.user = user;
    [self.navigationController pushViewController:userViewController animated:YES];
}

- (void)replyWithTweetCell:(Tweet *)tweet {
    [self performSegueWithIdentifier:@"replySegue" sender:tweet];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    }
    if ([sender isKindOfClass:[TweetCell class]]) {
        TweetCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Tweet *tweet = self.tweets[indexPath.row];
        
        SingleTweetViewController *singleTweetViewController = [segue destinationViewController];
        singleTweetViewController.tweet = tweet;
    }
    if ([segue.identifier isEqual:@"replySegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
        
        composeController.tweet = sender;
    }
}

@end
