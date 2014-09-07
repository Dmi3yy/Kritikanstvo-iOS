//
//  KItemGalleryController.h
//  Kritikanstvo
//
//  Created by Василий Наумкин on 30.08.14.
//  Copyright (c) 2014 bezumkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KItemViewController.h"

@class KUtils;

@interface KItemGalleryController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

	@property (nonatomic, readonly) KItemViewController *parentViewController;
	@property IBOutlet UICollectionView *collectionView;
	@property IBOutlet UIImageView *imageView;
	@property NSArray *images;
	@property KUtils *Utils;
	@property NSInteger activeImage;

	- (void) loadImages;

	- (void) prepareBigImage;

@end
