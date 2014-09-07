//
//  KMainItemCell.m
//  Kritikanstvo
//
//  Created by Василий Наумкин on 30.08.14.
//  Copyright (c) 2014 bezumkin. All rights reserved.
//

#import "KMainItemCell.h"

@implementation KMainItemCell

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
		[super setSelected:selected animated:animated];

		self.rating.backgroundColor = backgroundColor;
	}

	- (void) template {
		// Russian title
		self.russian.text = self.data[@"russian"];
		//Poster
		[self.poster sd_setImageWithURL:[NSURL URLWithString:self.data[@"thumb"]]
					   placeholderImage:[UIImage imageNamed:@"NoPoster"]
		];
		// Original, year
		NSMutableArray *original = [NSMutableArray array];
		if (self.data[@"original"] && ![self.data[@"original"] isEqualToString:@""]) {
			[original addObject:(NSString *) self.data[@"original"]];
		}
		if (self.data[@"year"] && [self.data[@"year"] intValue] > 0) {
			[original addObject:[NSString stringWithFormat:@"(%i)", [self.data[@"year"] intValue]]];
		}
		self.original.text = [original componentsJoinedByString:@" "];
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
