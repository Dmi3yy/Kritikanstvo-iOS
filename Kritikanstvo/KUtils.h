//
//  KUtils.h
//  Kritikanstvo
//
//  Created by Василий Наумкин on 27.08.14.
//  Copyright (c) 2014 bezumkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDWebImage/UIImageView+WebCache.h"
#import "SDActivityIndicator/SDNetworkActivityIndicator.h"
#import "SDActivityIndicator/UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "MBProgressHUD.h"
#import "KMainItemCell.h"


@interface KUtils : NSObject

	@property NSString *KritikanstvoAPI;

	- (void) showSpinner:(UIView *) view :(BOOL) animated;

	- (void) hideSpinner:(UIView *) view :(BOOL) animated;

	- (void) showIndicator;

	- (void) hideIndicator;

	- (void) animationFade:(UIView *) view :(NSString *) mode;

	- (void) animationPush:(UIView *) view :(NSString *) from;

	- (UIColor *) ratingColor:(NSInteger) rating;

	- (NSDictionary *) remoteRequest:(NSString *) action :(NSDictionary *) params;

@end
