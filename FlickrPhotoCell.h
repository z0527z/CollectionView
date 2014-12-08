//
//  FlickrPhotoCell.h
//  CollectionView
//
//  Created by dingql on 14-12-8.
//  Copyright (c) 2014年 dingql. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@class FlickrPhoto;
@interface FlickrPhotoCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) FlickrPhoto *photo;
@end
