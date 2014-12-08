//
//  ViewController.m
//  CollectionView
//
//  Created by dingql on 14-12-8.
//  Copyright (c) 2014年 dingql. All rights reserved.
//

#import "ViewController.h"
#import "Flickr.h"
#import "FlickrPhoto.h"
#import "FlickrPhotoCell.h"

@interface ViewController () <UITextFieldDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UIToolbar * _toolBar;
    UIBarButtonItem * _shareButton;
    UITextField * _textField;
    UICollectionView * _collectionView;
}

@property(nonatomic, strong) NSMutableDictionary *searchResults;
@property(nonatomic, strong) NSMutableArray *searches;
@property(nonatomic, strong) Flickr * flickr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searches = [@[] mutableCopy];
    self.searchResults = [@{} mutableCopy];
    self.flickr = [[Flickr alloc] init];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_cork.png"]];
    
    // 工具栏
    UIToolbar * toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 44)];
    _toolBar = toolBar;
    [self.view addSubview:toolBar];
    
    UIImage *navBarImage = [[UIImage imageNamed:@"navbar.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(27, 27, 27, 27)];
    [toolBar setBackgroundImage:navBarImage forToolbarPosition:UIToolbarPositionAny
                     barMetrics:UIBarMetricsDefault];
    
    // 分享按钮
    UIBarButtonItem * shareButton = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shareButtonClicked:)];
    _shareButton = shareButton;
    toolBar.items = @[shareButton];
    
    UIImage *shareButtonImage = [[UIImage imageNamed:@"button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    [shareButton setBackgroundImage:shareButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [shareButton setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];
    
    // 搜索条
    UIImage * image = [UIImage imageNamed:@"search_text.png"];
    UIImageView * searchText = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    searchText.image = image;
    searchText.center = CGPointMake(100, CGRectGetMaxY(toolBar.frame) + 30);
    [self.view addSubview:searchText];
    
    UITextField * textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(searchText.frame) + 10, CGRectGetMinY(searchText.frame), 120, 30)];
    textField.delegate = self;
    textField.center = CGPointMake(textField.center.x, searchText.center.y);
    UIImage *textFieldImage = [[UIImage imageNamed:@"search_field.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    _textField = textField;
    [textField setBackground:textFieldImage];
    [self.view addSubview:textField];
    
    // 线
    UIImageView * lineView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(self.view.frame) - 20, 6)];
    lineView.image = [UIImage imageNamed:@"divider_bar"];
    lineView.center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMaxY(textField.frame) + 5);
    [self.view addSubview:lineView];
    
    // clloctionView
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView * collctionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView.frame) + 5, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetMaxY(lineView.frame) - 5) collectionViewLayout:layout];
    collctionView.dataSource = self;
    collctionView.delegate = self;
    collctionView.backgroundColor = [UIColor clearColor];
    _collectionView = collctionView;
    [self.view addSubview:collctionView];
    
    [collctionView registerClass:[FlickrPhotoCell class] forCellWithReuseIdentifier:@"FlickrCell"];
}

- (void)shareButtonClicked:(UIButton *)btn
{
    NSLog(@"分享");
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.flickr searchFlickrForTerm:textField.text completionBlock:^(NSString *searchTerm, NSArray *results, NSError *error) {
        if (results && [results count] > 0) {
            if (![self.searches containsObject:searchTerm]) {
                NSLog(@"Found %d photos matching %@", results.count, searchTerm);
                [self.searches insertObject:searchTerm atIndex:0];
                self.searchResults[searchTerm] = results;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [_collectionView reloadData];
            });
        }else {
            NSLog(@"Error searching Flickr: %@", error.localizedDescription);
        }
    }];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UICollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSString * searchTerm = self.searches[section];
    return [self.searchResults[searchTerm] count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.searches.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FlickrPhotoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FlickrCell" forIndexPath:indexPath];
    NSString * searchTerm = self.searches[indexPath.section];
    cell.photo = self.searchResults[searchTerm][indexPath.row];
    
    return cell;
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    return [[UICollectionReusableView alloc] init];
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * searchTerm = self.searches[indexPath.section];
    FlickrPhoto * photo = self.searchResults[searchTerm][indexPath.row];
    
//    CGSize retval = photo.thumbnail.size.width > 0 ? photo.thumbnail.size : CGSizeMake(60, 60);
//    retval.height += 15;
//    retval.width += 15;
    return CGSizeMake(100, 100);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
