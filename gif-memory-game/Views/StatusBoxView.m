//
//  StatusBoxView.m
//  gif-memory-game
//
//  Created by Jon on 2/6/16.
//  Copyright © 2016 Second Wind, LLC. All rights reserved.
//

#import "StatusBoxView.h"
#import <Masonry/Masonry.h>

@interface StatusBoxView ()

@property (nonatomic, strong) UILabel *turnLabel;
@property (nonatomic, strong) MemoryGame *game;

@end


@implementation StatusBoxView


- (instancetype)initWithGame:(MemoryGame *)game;
{
    self = [super init];
    if (!self) return nil;
   
    _game = game;
    
    _turnLabel = [[UILabel alloc] init];
    _turnLabel.font = [UIFont fontWithName:@"8BITWONDERNominal" size:18];
    _turnLabel.textColor = [UIColor whiteColor];
    _turnLabel.textAlignment = NSTextAlignmentLeft;
    _turnLabel.text = @"Turns: 0";
    
    [self addSubview:_turnLabel];
    
    [_turnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.centerY.equalTo(self);
    }];
    
    self.backgroundColor = [UIColor blackColor];
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 1.0f;
    
    [self setupGameObserver];
    
    return self;
}

- (void)setupGameObserver
{
    [self.game addObserver:self forKeyPath:@"numberOfTurns" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"numberOfTurns"]) {
        NSUInteger newValue = [[change valueForKey:NSKeyValueChangeNewKey] unsignedIntegerValue];
        [self updateTurnLabel:newValue];
    }
}

- (void)dealloc
{
    [self.game removeObserver:self forKeyPath:@"numberOfTurns"];
}

- (void)updateTurnLabel:(NSUInteger)newValue
{
    self.turnLabel.text = [NSString stringWithFormat:@"Turns: %lu", newValue];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
