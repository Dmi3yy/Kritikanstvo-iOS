//
//  KItemReviewCell.h
//  Kritikanstvo
//
//  Created by Василий Наумкин on 05.09.14.
//  Copyright (c) 2014 bezumkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KUtils.h"

@class KUtils;

@interface KItemReviewCell : UITableViewCell

	@property KUtils *Utils;
	@property UITableViewController *tableView;
	@property NSDictionary *data;
	@property IBOutlet UILabel *publication;
	@property IBOutlet UILabel *date;
	@property IBOutlet UILabel *author;
	@property IBOutlet UILabel *summary;
	@property IBOutlet UILabel *rating;
	@property NSString *link;

	- (void) template;

@end
