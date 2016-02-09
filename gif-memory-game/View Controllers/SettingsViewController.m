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
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIStackView *menuStackView;
@property (nonatomic, strong) UILabel *trendingLabel;
@property (nonatomic, strong) UILabel *searchLabel;
@property (nonatomic, strong) UILabel *defaultLabel;
@property (nonatomic, assign) NSUInteger selectedCustomization;
@end


@implementation SettingsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self setupViews];
    [self setupViewContent];
    [self setupViewConstraints];
    [self setupUserInteractions];
    [self setupExitArrow];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self checkConfigurations];
}

- (void)checkConfigurations
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSNumber *option = [def valueForKey:@"com.memory.customization"];
    
    if (option) {
        self.selectedCustomization = [option unsignedIntegerValue];
    } else {
        self.selectedCustomization = 2;
    }
   
    UIColor *color = [UIColor greenColor];
    self.trendingLabel.textColor = [UIColor whiteColor];
    self.defaultLabel.textColor = [UIColor whiteColor];
    
    switch (self.selectedCustomization) {
        case 0: self.trendingLabel.textColor = color; break;
        case 1: self.searchLabel.textColor = color; break;
        case 2: self.defaultLabel.textColor = color; break;
    }
    
}

- (void)setupViews
{
    self.backgroundImageView = [[UIImageView alloc] init];
    self.titleLabel = [[UILabel alloc] init];
    self.menuStackView = [[UIStackView alloc] init];
    self.trendingLabel = [self menuLabel];
    self.searchLabel = [self menuLabel];
    self.defaultLabel = [self menuLabel];
    
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.menuStackView];
}

- (void)setupViewContent
{
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
    
    // Content label
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont fontWithName:@"8BITWONDERNominal" size:18];
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 100;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"Customize your game experience by picking GIFs from the latest trending topics.";
    
    [self.view addSubview:label];
    self.contentLabel = label;
    
    // Menu Stack View
    self.menuStackView.alignment = UIStackViewAlignmentCenter;
    self.menuStackView.distribution = UIStackViewDistributionFillEqually;
    self.menuStackView.axis = UILayoutConstraintAxisVertical;
    self.menuStackView.spacing = 8.0f;
    [self.menuStackView addArrangedSubview:self.trendingLabel];
    [self.menuStackView addArrangedSubview:self.defaultLabel];
    [self.menuStackView addArrangedSubview:self.searchLabel];
 
    // Menu Labels
    self.trendingLabel.text = @"Trending";
    self.searchLabel.text = @"";
    self.defaultLabel.text = @"Default";
}

- (void)setupViewConstraints
{
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_topMargin).mas_offset(@90);
        make.centerX.equalTo(self.view);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(30);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
    }];
    
    [self.menuStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottomMargin).offset(-50);
        make.left.and.right.equalTo(self.view);
        make.height.equalTo(@150);
    }];
    
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
//    
//    UITapGestureRecognizer *searchTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchTapped)];
//    [self.searchLabel addGestureRecognizer:searchTap];
//    
    UITapGestureRecognizer *defaultTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(defaultTapped)];
    [self.defaultLabel addGestureRecognizer:defaultTap];
}

- (void)trendingTapped
{
    TrendingViewController *tvc = [[TrendingViewController alloc] init];
    tvc.transitioningDelegate = self;
    [self presentViewController:tvc animated:YES completion:nil];
}
//
//- (void)searchTapped
//{
//    
//}
//
- (void)defaultTapped
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setInteger:2 forKey:@"com.memory.customization"];
    [def removeObjectForKey:@"com.memory.keyword"];
    [def synchronize];
    
    [self checkConfigurations];
    [self dismissViewControllerAnimated:YES completion:nil];
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
