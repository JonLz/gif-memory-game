//
//  MemoryTileView.m
//  gif-memory-game
//
//  Created by Jon on 2/3/16.
//  Copyright © 2016 Second Wind, LLC. All rights reserved.
//

#import "MemoryTileView.h"
#import "BackgroundView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Masonry/Masonry.h>

@interface MemoryTileView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) BackgroundView *backgroundImageView;
@property (nonatomic, strong) MemoryTile *tile;
@end

@implementation MemoryTileView

- (instancetype)initWithTile:(MemoryTile *)tile
{
    self = [super init];
    if (!self) return nil;
   
    _tile = tile;
    
    _imageView = [[UIImageView alloc] init];
    [_imageView sd_setImageWithURL:tile.smallAnimatedURL];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.userInteractionEnabled = NO;
    
    _backgroundImageView = [[BackgroundView alloc] init];
    _backgroundImageView.userInteractionEnabled = NO;
    
    [self setupViewHierarchy];
    [self setupViewConstraints];
    
    self.imageView.hidden = YES;
    self.clipsToBounds = YES;
    
    return self;
}

- (void)setupViewHierarchy
{
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.imageView];
}

- (void)setupViewConstraints
{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    
}

- (void)flipTile
{
    self.imageView.hidden = !self.imageView.hidden;
    self.backgroundImageView.hidden = !self.backgroundImageView.hidden;
}

@end
