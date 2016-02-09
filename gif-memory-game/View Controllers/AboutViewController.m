//
//  AboutViewController.m
//  gif-memory-game
//
//  Created by Jon on 2/8/16.
//  Copyright © 2016 Second Wind, LLC. All rights reserved.
//

#import "AboutViewController.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImage+GIF.h>

@interface AboutViewController ()
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.backgroundImageView = [[UIImageView alloc] init];
    self.titleLabel = [[UILabel alloc] init];
    
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.titleLabel];
    
    // Background
    UIImage *backgroundImage = [UIImage imageNamed:@"BG"];
    self.backgroundImageView.image = backgroundImage;
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    // Title Label
    self.titleLabel.font = [UIFont fontWithName:@"8BITWONDERNominal" size:27];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.numberOfLines = 3;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = @"About";
    
    // Content label
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont fontWithName:@"8BITWONDERNominal" size:18];
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 100;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"Created By: Jon Lazar\n\nA quick game created to educate about iOS fundamentals.\n\nTap to find out how you can make it!";
    
    [self.view addSubview:label];
    
    UITapGestureRecognizer *tappedLabel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedLabel)];
    [label addGestureRecognizer:tappedLabel];
    label.userInteractionEnabled = YES;
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_topMargin).mas_offset(@90);
        make.centerX.equalTo(self.view);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(30);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
    }];
    
    // Giphy Attribution
    UIImageView *attr = [[UIImageView alloc] init];
    attr.image = [UIImage sd_animatedGIFNamed:@"GiphyAttribution"];
    attr.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:attr];
    
    [attr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-80);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@200);
        make.height.equalTo(@42);
    }];
    
    [self setupExitArrow];
    
}

- (void)setupExitArrow
{
    UIImage *arrowImg = [[UIImage imageNamed:@"LeftArrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
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

- (void)tappedLabel
{
    NSURL *url = [NSURL URLWithString:@"http://www.github.com/JonLz/gif-memory-game"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
