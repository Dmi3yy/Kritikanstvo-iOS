//
//  KMainItemCell.h
//  Kritikanstvo
//
//  Created by Василий Наумкин on 30.08.14.
//  Copyright (c) 2014 bezumkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KUtils.h"

@class KUtils;

@interface KMainItemCell : UITableViewCell

	@property KUtils *Utils;
	@property NSDictionary *data;
	@property IBOutlet UIImageView *poster;
	@property IBOutlet UILabel *russian;
	@property IBOutlet UILabel *original;
	@property IBOutlet UILabel *rating;

	- (void) template;

@end
