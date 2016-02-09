//
//  ViewController.m
//  gif-memory-game
//
//  Created by Jon on 2/2/16.
//  Copyright © 2016 Second Wind, LLC. All rights reserved.
//

#import "TitleViewController.h"
#import <Masonry/Masonry.h>
#import "GameViewController.h"
#import "AboutViewController.h"
#import "SettingsViewController.h"
#import "TransitionAnimator.h"

@interface TitleViewController () <UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIStackView *menuStackView;
@property (nonatomic, strong) UILabel *startLabel;
@property (nonatomic, strong) UILabel *restartGameLabel;
@property (nonatomic, strong) UILabel *settingsLabel;
@property (nonatomic, strong) UILabel *aboutLabel;

@property (nonatomic, assign) TransitionDirection transitionDirection;
@end

@implementation TitleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    [self setupViewHierarchy];
    [self setupViewConstraints];
    [self setupViewContent];
    [self setupUserInteractions];
 
}

- (void)setupViews
{
    self.backgroundImageView = [[UIImageView alloc] init];
    self.titleLabel = [[UILabel alloc] init];
    self.logoImageView = [[UIImageView alloc] init];
    self.menuStackView = [[UIStackView alloc] init];
    self.startLabel = [self menuLabel];
    self.restartGameLabel = [self menuLabel];
    self.settingsLabel = [self menuLabel];
    self.aboutLabel = [self menuLabel];
}

- (void)setupViewHierarchy
{
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.menuStackView];
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
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.height.and.width.equalTo(@100);
    }];
    
    [self.menuStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottomMargin).offset(-50);
        make.left.and.right.equalTo(self.view);
        make.height.equalTo(@150);
    }];
}

- (void)setupViewContent
{
    // Background
    UIImage *backgroundImage = [UIImage imageNamed:@"BG"];
    self.backgroundImageView.image = backgroundImage;
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    // Title Label
    self.titleLabel.font = [UIFont fontWithName:@"8BITWONDERNominal" size:36];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.numberOfLines = 3;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = @"GIF\nMEMORY\nWARS";
    
    // Logo Image
    UIImage *image = [[UIImage imageNamed:@"SwordLogo"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.logoImageView.image = image;
    self.logoImageView.tintColor = [UIColor whiteColor];
    self.logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    // Menu Stack View
    self.menuStackView.alignment = UIStackViewAlignmentCenter;
    self.menuStackView.distribution = UIStackViewDistributionFillEqually;
    self.menuStackView.axis = UILayoutConstraintAxisVertical;
    self.menuStackView.spacing = 8.0f;
    
    [self.menuStackView addArrangedSubview:self.startLabel];
    [self.menuStackView addArrangedSubview:self.restartGameLabel];
    [self.menuStackView addArrangedSubview:self.settingsLabel];
    [self.menuStackView addArrangedSubview:self.aboutLabel];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    // Menu Labels
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"com.memory.game"] == nil) {
        self.startLabel.text = @"Start";
        self.restartGameLabel.hidden = YES;
    } else {
        self.startLabel.text = @"Resume";
        self.restartGameLabel.hidden = NO;
    }
    
    self.restartGameLabel.text = @"New Game";
    self.settingsLabel.text = @"Customize";
    self.aboutLabel.text = @"About";

}
- (void)setupUserInteractions
{
    UITapGestureRecognizer *startTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startTapped)];
    [self.startLabel addGestureRecognizer:startTap];
    
    UITapGestureRecognizer *newGameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newGameTapped)];
    [self.restartGameLabel addGestureRecognizer:newGameTap];
    
    UITapGestureRecognizer *settingsTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settingsTapped)];
    [self.settingsLabel addGestureRecognizer:settingsTap];
    
    UITapGestureRecognizer *aboutTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aboutTapped)];
    [self.aboutLabel addGestureRecognizer:aboutTap];
}

- (void)startTapped
{
    GameViewController *gvc = [[GameViewController alloc] init];
    gvc.transitioningDelegate = self;
    self.transitionDirection = Down;
    [self presentViewController:gvc animated:YES completion:nil];
}

- (void)newGameTapped
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"com.memory.game"];
    
    GameViewController *gvc = [[GameViewController alloc] init];
    gvc.transitioningDelegate = self;
    self.transitionDirection = Down;
    [self presentViewController:gvc animated:YES completion:nil];
}

- (void)settingsTapped
{
    SettingsViewController *svc = [[SettingsViewController alloc] init];
    svc.transitioningDelegate = self;
    self.transitionDirection = Left;
    [self presentViewController:svc animated:YES completion:nil];
}

- (void)aboutTapped
{
    AboutViewController *avc = [[AboutViewController alloc] init];
    avc.transitioningDelegate = self;
    self.transitionDirection = Right;
    [self presentViewController:avc animated:YES completion:nil];
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

#pragma mark
#pragma mark View Transition Handlers
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    
    TransitionAnimator *animator = [[TransitionAnimator alloc] initWithDirection:self.transitionDirection];
    animator.presenting = YES;
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    TransitionAnimator *animator = [[TransitionAnimator alloc] initWithDirection:self.transitionDirection];
    return animator;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
