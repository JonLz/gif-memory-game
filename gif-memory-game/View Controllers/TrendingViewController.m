//
//  TrendingViewController.m
//  gif-memory-game
//
//  Created by Jon on 2/8/16.
//  Copyright © 2016 Second Wind, LLC. All rights reserved.
//

#import "TrendingViewController.h"
#import "TwitterNetworkingModel.h"
#import "GiphyNetworkingModel.h"

#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface TrendingViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITableView *trendingTopicsTableView;
@property (nonatomic, strong) NSArray *trends;
@property (nonatomic, strong) UILabel *noGIFsFoundLabel;
@property (nonatomic, strong) NSString *keyword;
@end

@implementation TrendingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setupViews];
    [self setupViewContent];
    [self setupExitArrow];
    
    [self loadKeyword];
    [self fetchTrends];
}

- (void)loadKeyword {
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    self.keyword = [def objectForKey:@"com.memory.keyword"];
}

- (void)setupViews
{
    self.titleLabel = [[UILabel alloc] init];
    self.imageView = [[UIImageView alloc] init];
    self.trendingTopicsTableView = [[UITableView alloc] init];
    self.noGIFsFoundLabel = [[UILabel alloc] init];
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.noGIFsFoundLabel];
    [self.view addSubview:self.trendingTopicsTableView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(30);
        make.centerX.equalTo(self.view);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.height.equalTo(@200);
    }];
    
    [self.noGIFsFoundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(self.imageView);
        make.left.equalTo(self.imageView).offset(15);
        make.right.equalTo(self.imageView).offset(-15);
    }];
    
    [self.trendingTopicsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.imageView.mas_bottom).offset(10);
        make.bottom.equalTo(self.view).offset(-60);
    }];
}

- (void)setupViewContent
{
    self.titleLabel.text = @"Trending";
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont fontWithName:@"8BITWONDERNominal" size:36];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imageView.layer.borderWidth = 1.0f;
    
    self.noGIFsFoundLabel.text = @"Sorry! No GIFS found for this trend";
    self.noGIFsFoundLabel.numberOfLines = 2;
    self.noGIFsFoundLabel.textColor = [UIColor whiteColor];
    self.noGIFsFoundLabel.font = [UIFont fontWithName:@"8BITWONDERNominal" size:18];
    self.noGIFsFoundLabel.textAlignment = NSTextAlignmentCenter;
    self.noGIFsFoundLabel.hidden = YES;
    
    self.trendingTopicsTableView.delegate = self;
    self.trendingTopicsTableView.dataSource = self;
    [self.trendingTopicsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.trendingTopicsTableView.backgroundColor = [UIColor blackColor];
    self.trendingTopicsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

//    self.trendingTopicsTableView.layer.borderColor = [UIColor whiteColor].CGColor;
//    self.trendingTopicsTableView.layer.borderWidth = 1.0f;
    
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

- (void)fetchTrends
{
    TwitterNetworkingModel *twitterAPI = [TwitterNetworkingModel sharedInstance];
    [twitterAPI fetchTrends:^(NSArray *trends) {
        self.trends = trends;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.trendingTopicsTableView reloadData];
            for (NSString *trend in self.trends){
                
                if ([trend isEqualToString:self.keyword]) {
                    NSIndexPath *ip = [NSIndexPath indexPathForRow:[self.trends indexOfObject:trend] inSection:0];
                    [self.trendingTopicsTableView selectRowAtIndexPath:ip animated:NO scrollPosition:UITableViewScrollPositionMiddle];
                    [self tableView:self.trendingTopicsTableView didSelectRowAtIndexPath:ip];
                }
            }
        });
    } failure:^(NSError *error) {
        NSLog(@"Error with twitter");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.trends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont fontWithName:@"8BITWONDERNominal" size:18];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = self.trends[indexPath.row];
    
    if ([cell.textLabel.text isEqualToString:self.keyword]) {
        cell.textLabel.textColor = [UIColor greenColor];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *trend = self.trends[indexPath.row];
    UITableViewCell *cell = [self.trendingTopicsTableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor greenColor];
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    GiphyNetworkingModel *giphyAPI = [GiphyNetworkingModel sharedInstance];
    [giphyAPI fetchGiphyImagePreviewForSearchTerm:trend success:^(NSURL *url) {
        if (url) {
            self.noGIFsFoundLabel.hidden = YES;
            [self.imageView sd_setImageWithURL:url];
            [def setInteger:0 forKey:@"com.memory.customization"];
            [def setObject:trend forKey:@"com.memory.keyword"];
            self.keyword = trend;
            [def synchronize];
            
        } else {
            self.noGIFsFoundLabel.hidden = NO;
            [self.imageView sd_setImageWithURL:nil];
            [def setInteger:2 forKey:@"com.memory.customization"];
            [def removeObjectForKey:@"com.memory.keyword"];
            [def synchronize];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"Error with giphy");
    }];
    
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.trendingTopicsTableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor whiteColor];
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
