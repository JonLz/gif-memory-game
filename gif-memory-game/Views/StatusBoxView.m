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
@property (nonatomic, strong) UILabel *displayLabel;

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
    [self updateTurnLabel:_game.numberOfTurns];
    
    _displayLabel = [[UILabel alloc] init];
    _displayLabel.font = _turnLabel.font;
    _displayLabel.textColor = _turnLabel.textColor;
    _displayLabel.textAlignment = NSTextAlignmentRight;
    _displayLabel.adjustsFontSizeToFitWidth = YES;
    
    NSString *trend = [[NSUserDefaults standardUserDefaults] objectForKey:@"com.memory.keyword"];
    if (trend) {
        _displayLabel.text = trend;
    } else {
        _displayLabel.text = @"Default";
    }
    
    [self addSubview:_turnLabel];
    [self addSubview:_displayLabel];
    
    [_turnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.centerY.equalTo(self);
    }];
    
    [_displayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self);
        make.left.equalTo(_turnLabel.mas_right).offset(10);
    }];
    
    [_turnLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [_displayLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    self.backgroundColor = [UIColor blackColor];
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 1.0f;
    
    [self setupGameObserver];
    
    return self;
}

- (void)setupGameObserver
{
    [self.game addObserver:self forKeyPath:@"numberOfTurns" options:NSKeyValueObservingOptionNew context:nil];
    [self.game addObserver:self forKeyPath:@"gameInProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"numberOfTurns"]) {
        NSUInteger newValue = [[change valueForKey:NSKeyValueChangeNewKey] unsignedIntegerValue];
        [self updateTurnLabel:newValue];
    } else if ([keyPath isEqualToString:@"gameInProgress"]) {
        BOOL gameInProgress = [[change valueForKey:NSKeyValueChangeNewKey] boolValue];
        if (!gameInProgress) {
            self.displayLabel.text = @"You win!";
            self.displayLabel.textColor = [UIColor greenColor];
        }
    }
}

- (void)dealloc
{
    [self.game removeObserver:self forKeyPath:@"numberOfTurns"];
    [self.game removeObserver:self forKeyPath:@"gameInProgress"];
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
