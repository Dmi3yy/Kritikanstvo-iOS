//
//  KItemGalleryCell.h
//  Kritikanstvo
//
//  Created by Василий Наумкин on 02.09.14.
//  Copyright (c) 2014 bezumkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KItemGalleryCell : UICollectionViewCell

	@property (weak, nonatomic) IBOutlet UIImageView *imageView;

	- (void) loadThumb:(NSString *) url;

@end
