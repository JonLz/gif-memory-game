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
#import <Masonry/Masonry.h>

@interface GameViewController ()
@property (nonatomic, strong) NSMutableArray *memoryTileViews;
@property (nonatomic, strong) MemoryGame *game;
@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    _memoryTileViews = [[NSMutableArray alloc] init];
    
    _game = [MemoryGame sharedInstance];
    [_game newGameWithCompletion:^(BOOL success) {
        [self setupStackViews];
        [self setupTileInteractions];
    }];
    
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

- (void)setupTileInteractions
{
    for (MemoryTileView *tileView in self.memoryTileViews) {
        [tileView addTarget:self action:@selector(memoryTileViewTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)memoryTileViewTapped:(MemoryTileView *)memoryTileView
{
    [memoryTileView flipTile];
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
