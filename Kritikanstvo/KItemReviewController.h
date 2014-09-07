//
//  KItemReviewController.h
//  Kritikanstvo
//
//  Created by Василий Наумкин on 30.08.14.
//  Copyright (c) 2014 bezumkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KItemViewController.h"
#import "KItemReviewCell.h"

@class KUtils, KItemReviewCell;

@interface KItemReviewController : UITableViewController

	@property KUtils *Utils;
	@property (nonatomic, readonly) KItemViewController *parentViewController;
	@property IBOutlet UIImageView *imageView;
	@property IBOutlet UIButton *russian;
	@property IBOutlet UILabel *original;
	@property IBOutlet UILabel *genres;
	@property IBOutlet UILabel *other;
	@property IBOutlet UILabel *ratingLabel;
	@property NSArray *reviewsArray;

	- (void) loadDetails;

	- (void) templateDetails:(NSDictionary *) data;

@end
