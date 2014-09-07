//
//  KItemReviewCell.m
//  Kritikanstvo
//
//  Created by Василий Наумкин on 05.09.14.
//  Copyright (c) 2014 bezumkin. All rights reserved.
//

#import "KItemReviewCell.h"

@implementation KItemReviewCell

	- (void) awakeFromNib {
		[super awakeFromNib];
		self.Utils = [[KUtils alloc] init];
	}

	- (void) setHighlighted:(BOOL) highlighted animated:(BOOL) animated {
		UIColor *backgroundColor = self.rating.backgroundColor;
		[super setHighlighted:highlighted animated:animated];

		self.rating.backgroundColor = backgroundColor;
	}

	- (void) setSelected:(BOOL) selected animated:(BOOL) animated {
		UIColor *backgroundColor = self.rating.backgroundColor;

		if (![self.link isEqualToString:@""]) {
			if (selected && !self.selected) {
				[self.tableView performSegueWithIdentifier:@"review" sender:self];
			}
			[super setSelected:selected animated:animated];
		}
		else {
			[super setSelected:NO animated:animated];
		}
		self.rating.backgroundColor = backgroundColor;
	}

	- (void) template {
		self.publication.text = self.data[@"publication"];
		self.date.text = self.data[@"date"];
		self.author.text = self.data[@"author"];
		self.summary.text = self.data[@"summary"];
		self.link = self.data[@"link"];

		if (![self.link isEqualToString:@""]) {
			self.publication.textColor = [UIColor colorWithRed:0 green:0.5 blue:0.8 alpha:1];
		}
		else {
			self.publication.textColor = [UIColor blackColor];
		}

		// Rating
		NSInteger rating = [(NSString *) self.data[@"rating"] intValue];
		if (rating > 0) {
			UIColor *color = [self.Utils ratingColor:rating];
			self.rating.backgroundColor = color;
			self.rating.textColor = [UIColor whiteColor];
			self.rating.text = [NSString stringWithFormat:@"%li", (long) rating];
		}
		else {
			self.rating.hidden = YES;
		}
	}

@end
