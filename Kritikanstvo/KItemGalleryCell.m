//
//  KItemGalleryCell.m
//  Kritikanstvo
//
//  Created by Василий Наумкин on 02.09.14.
//  Copyright (c) 2014 bezumkin. All rights reserved.
//

#import "KItemGalleryCell.h"
#import "KUtils.h"

@implementation KItemGalleryCell

	- (void) loadThumb:(NSString *) url {
		[self.imageView sd_setImageWithURL:[NSURL URLWithString:url]
						  placeholderImage:[UIImage imageNamed:@"NoImage"]
		];
	}

@end
