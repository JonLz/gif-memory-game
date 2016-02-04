//
//  ViewController.m
//  gif-memory-game
//
//  Created by Jon on 2/2/16.
//  Copyright © 2016 Second Wind, LLC. All rights reserved.
//

#import "TitleViewController.h"
#import <Masonry/Masonry.h>
#import "MemoryGame.h"
#import "MemoryTile.h"

@interface TitleViewController ()
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIStackView *menuStackView;
@property (nonatomic, strong) UILabel *startLabel;
@property (nonatomic, strong) UILabel *aboutLabel;
@end

@implementation TitleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    [self setupViewHierarchy];
    [self setupViewConstraints];
    [self setupViewContent];
    [self setupUserInteractions];
    
    MemoryGame *game = [MemoryGame sharedInstance];
    [game newGameWithCompletion:^(BOOL success) {
        
    }];
   
}

- (void)setupViews
{
    self.backgroundImageView = [[UIImageView alloc] init];
    self.titleLabel = [[UILabel alloc] init];
    self.menuStackView = [[UIStackView alloc] init];
    self.startLabel = [self menuLabel];
    self.aboutLabel = [self menuLabel];
}

- (void)setupViewHierarchy
{
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.titleLabel];
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
    
    // Menu Labels
    self.startLabel.text = @"Start";
    self.aboutLabel.text = @"About";
    
    // Menu Stack View
    self.menuStackView.alignment = UIStackViewAlignmentCenter;
    self.menuStackView.distribution = UIStackViewDistributionFillEqually;
    self.menuStackView.axis = UILayoutConstraintAxisVertical;
    self.menuStackView.spacing = 8.0f;
    [self.menuStackView addArrangedSubview:self.startLabel];
    [self.menuStackView addArrangedSubview:self.aboutLabel];
}

- (void)setupUserInteractions
{
    UITapGestureRecognizer *startTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startTapped)];
    [self.startLabel addGestureRecognizer:startTap];
    
    UITapGestureRecognizer *aboutTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aboutTapped)];
    [self.aboutLabel addGestureRecognizer:aboutTap];
}

- (void)startTapped
{
    NSLog(@"Start tapped");
}

- (void)aboutTapped
{
    NSLog(@"About tapped");
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
