//
//  FlickrPhotoCell.m
//  CollectionView
//
//  Created by dingql on 14-12-8.
//  Copyright (c) 2014年 dingql. All rights reserved.
//

#import "FlickrPhotoCell.h"
#import <QuartzCore/QuartzCore.h>
#import "FlickrPhoto.h"

@implementation FlickrPhotoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(frame) - 20, CGRectGetHeight(frame) - 20)];
        _imageView = imageView;
        [self addSubview:imageView];
        
        UIImageView * pushPin = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 31)];
        pushPin.image = [UIImage imageNamed:@"pushpin.png"];
        pushPin.center = CGPointMake(CGRectGetMidX(frame), pushPin.center.y);
        [self addSubview:pushPin];
    }
    
    return self;
}



- (void)setPhoto:(FlickrPhoto *)photo
{
    if (_photo != photo) {
        _photo = photo;
    }
    
    self.imageView.image = _photo.thumbnail;
}
@end
