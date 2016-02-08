//
//  GameViewController.m
//  gif-memory-game
//
//  Created by Jon on 2/3/16.
//  Copyright © 2016 Second Wind, LLC. All rights reserved.
//

#import "GameViewController.h"
#import "MemoryGame.h"
#import "MemoryTile.h"
#import "MemoryTileView.h"
#import "StatusBoxView.h"
#import <Masonry/Masonry.h>

@interface GameViewController ()
@property (nonatomic, strong) NSMutableArray *memoryTileViews;
@property (nonatomic, strong) MemoryGame *game;
@property (nonatomic, strong) UIStackView *gameStackView;
@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    _memoryTileViews = [[NSMutableArray alloc] init];
    
    _game = [MemoryGame sharedInstance];
    if ([_game savedGameExists]) {
        [self setupUI];
        
    } else {
        [_game newGameWithCompletion:^(BOOL success) {
            [self setupUI];
        
        }];
    }
}

- (void)setupUI
{
    [self setupStackViews];
    [self setupTileInteractions];
    [self setupStatusBoxView];
    [self setupExitArrow];
}

- (void)setupStackViews
{
    UIStackView *verticalStackView = [self verticalStackView];
    
    for (NSUInteger i=0;i<6;i++) {
        UIStackView *horizontalStackView = [self horizontalStackView];
        for (NSUInteger j=0;j<4;j++) {
            NSUInteger index = i*4 + j;
            MemoryTile *tile = self.game.tiles[index];
            MemoryTileView *tileView = [[MemoryTileView alloc] initWithTile:tile];
            [horizontalStackView addArrangedSubview:tileView];
            [self.memoryTileViews addObject:tileView];
        }
        [verticalStackView addArrangedSubview:horizontalStackView];
    }
    
    [self.view addSubview:verticalStackView];
    [verticalStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(self.view).mas_offset(@10);
        make.right.equalTo(self.view).mas_offset(@-10);
        make.height.equalTo(self.view).multipliedBy(0.75);
    }];
    
    self.gameStackView = verticalStackView;
}

- (UIStackView *)verticalStackView
{
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.alignment = UIStackViewAlignmentFill;
    stackView.distribution = UIStackViewDistributionFillEqually;
    stackView.spacing = 5.0f;
    stackView.axis = UILayoutConstraintAxisVertical;
    return stackView;
}

- (UIStackView *)horizontalStackView
{
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.alignment = UIStackViewAlignmentFill;
    stackView.distribution = UIStackViewDistributionFillEqually;
    stackView.spacing = 5.0f;
    stackView.axis = UILayoutConstraintAxisHorizontal;
    return stackView;
}

- (void)setupStatusBoxView
{
    StatusBoxView *statusView = [[StatusBoxView alloc] initWithGame:self.game];
    [self.view addSubview:statusView];
    
    [statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.gameStackView.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(@50);
    }];
}

- (void)setupExitArrow
{
    UIImage *arrowImg = [[UIImage imageNamed:@"UpArrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
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

- (void)setupTileInteractions
{
    for (MemoryTileView *tileView in self.memoryTileViews) {
        [tileView addTarget:self action:@selector(memoryTileViewTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)memoryTileViewTapped:(MemoryTileView *)memoryTileView
{
    [self.game handleTurn:memoryTileView.tile];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.game saveCurrentGame];
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
