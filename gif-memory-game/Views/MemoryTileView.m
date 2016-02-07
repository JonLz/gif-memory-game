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
    [self setupTileObserver];
    
    _imageView.hidden = YES;
    self.clipsToBounds = YES;
    
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 1.0;
    
    return self;
}

- (void)setupViewHierarchy
{
    [self addSubview:self.imageView];
    [self addSubview:self.backgroundImageView];
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

- (void)setupTileObserver
{
    [self.tile addObserver:self forKeyPath:@"visible" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"visible"]) {
        BOOL newValue = [[change valueForKey:NSKeyValueChangeNewKey] boolValue];
        BOOL oldValue = [[change valueForKey:NSKeyValueChangeOldKey] boolValue];
        
        [self flipTileFrom:oldValue toNewValue:newValue];
    }
}

- (void)dealloc
{
    [self.tile removeObserver:self forKeyPath:@"visible"];

}

- (void)flipTileFrom:(BOOL)oldValue toNewValue:(BOOL)newValue
{
    if (oldValue == newValue) {
        return;
    }
    
    // we are observing the value for visibility. if its true, the tile should be visible!
    BOOL shouldBeVisible = newValue == 1 ? YES : NO;
    
    if (shouldBeVisible) {
        [UIView transitionFromView:self.backgroundImageView toView:self.imageView duration:0.5f options: UIViewAnimationOptionTransitionFlipFromRight | UIViewAnimationOptionShowHideTransitionViews completion:nil];
    } else {
        [UIView transitionFromView:self.imageView  toView:self.backgroundImageView duration:0.5f options:UIViewAnimationOptionTransitionFlipFromLeft | UIViewAnimationOptionShowHideTransitionViews completion:nil];
    }
}

@end
