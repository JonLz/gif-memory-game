//
//  SettingsViewController.m
//  gif-memory-game
//
//  Created by Jon on 2/8/16.
//  Copyright © 2016 Second Wind, LLC. All rights reserved.
//

#import "SettingsViewController.h"
#import "TransitionAnimator.h"
#import "TrendingViewController.h"

#import <Masonry/Masonry.h>

@interface SettingsViewController () <UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIStackView *menuStackView;
@property (nonatomic, strong) UILabel *trendingLabel;
@property (nonatomic, strong) UILabel *searchLabel;

@end


@implementation SettingsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.backgroundImageView = [[UIImageView alloc] init];
    self.titleLabel = [[UILabel alloc] init];
    self.menuStackView = [[UIStackView alloc] init];
    self.trendingLabel = [self menuLabel];
    self.searchLabel = [self menuLabel];
    
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.menuStackView];
    
    // Background
    UIImage *backgroundImage = [UIImage imageNamed:@"BG"];
    self.backgroundImageView.image = backgroundImage;
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    // Title Label
    self.titleLabel.font = [UIFont fontWithName:@"8BITWONDERNominal" size:27];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.numberOfLines = 3;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = @"Customize";
   
    // Menu Stack View
    self.menuStackView.alignment = UIStackViewAlignmentCenter;
    self.menuStackView.distribution = UIStackViewDistributionFillEqually;
    self.menuStackView.axis = UILayoutConstraintAxisVertical;
    self.menuStackView.spacing = 8.0f;
    [self.menuStackView addArrangedSubview:self.trendingLabel];
    [self.menuStackView addArrangedSubview:self.searchLabel];

    UILabel *fillerLabel = [self menuLabel];
    fillerLabel.text = @"";
    fillerLabel.userInteractionEnabled = NO;

    
    [self.menuStackView addArrangedSubview:fillerLabel];
    
    // Menu Labels
    self.trendingLabel.text = @"Trending";
    self.searchLabel.text = @"Search";
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_topMargin).mas_offset(@90);
        make.centerX.equalTo(self.view);
    }];
    
    [self.menuStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottomMargin).offset(-50);
        make.left.and.right.equalTo(self.view);
        make.height.equalTo(@150);
    }];
    
    [self setupUserInteractions];
    [self setupExitArrow];
}

- (UILabel *)menuLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont fontWithName:@"8BITWONDERNominal" size:18];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.userInteractionEnabled = YES;
    return label;
}

- (void)setupUserInteractions
{
    UITapGestureRecognizer *trendingTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(trendingTapped)];
    [self.trendingLabel addGestureRecognizer:trendingTap];
    
    UITapGestureRecognizer *searchTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchTapped)];
    [self.searchLabel addGestureRecognizer:searchTap];
}

- (void)trendingTapped
{
    TrendingViewController *tvc = [[TrendingViewController alloc] init];
    tvc.transitioningDelegate = self;
    [self presentViewController:tvc animated:YES completion:nil];
}

- (void)searchTapped
{
    
}

- (void)setupExitArrow
{
    UIImage *arrowImg = [[UIImage imageNamed:@"RightArrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImageView *arrowImgView = [[UIImageView alloc] initWithImage:arrowImg];
    arrowImgView.contentMode = UIViewContentModeScaleAspectFit;
    arrowImgView.tintColor = [UIColor whiteColor];
    arrowImgView.userInteractionEnabled = YES;
    
    [self.view addSubview:arrowImgView];
    
    [arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        make.centerX.equalTo(self.view);
        make.height.equalTo(@40);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(arrowTapped)];
    [arrowImgView addGestureRecognizer:tap];
}

- (void)arrowTapped
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark
#pragma mark View Transition Handlers
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    
    TransitionAnimator *animator = [[TransitionAnimator alloc] initWithDirection:Down];
    animator.presenting = YES;
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    TransitionAnimator *animator = [[TransitionAnimator alloc] initWithDirection:Down];
    return animator;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
