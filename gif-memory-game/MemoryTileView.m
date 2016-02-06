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
    
    self.imageView.hidden = YES;
    self.clipsToBounds = YES;
    
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 1.0;
    
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

- (void)setupTileObserver
{
    [self.tile addObserver:self forKeyPath:@"visible" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"visible"]) {
        BOOL newValue = [[change valueForKey:NSKeyValueChangeNewKey] boolValue];
        BOOL oldValue = [[change valueForKey:NSKeyValueChangeOldKey] boolValue];
        
        self.imageView.hidden = oldValue;
        self.backgroundImageView.hidden = newValue;
        
    }
}

- (void)flipTile
{
    self.imageView.hidden = !self.imageView.hidden;
    self.backgroundImageView.hidden = !self.backgroundImageView.hidden;
}

@end
