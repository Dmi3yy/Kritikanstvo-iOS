//
//  KUtils.m
//  Kritikanstvo
//
//  Created by Василий Наумкин on 27.08.14.
//  Copyright (c) 2014 bezumkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KUtils.h"

@implementation KUtils

	- (instancetype) init {
		self = [super init];
		if (self) {
			self.KritikanstvoAPI = @"http://www.kritikanstvo.ru/api.php";
		}

		return self;
	}

	/*
	- (void) ClearImagesCache {
		SDImageCache *imageCache = [SDImageCache sharedImageCache];
		[imageCache clearMemory];
		[imageCache clearDisk];
	}
	*/

	- (NSDictionary *) remoteRequest:(NSString *) action :(NSDictionary *) params {
		NSMutableDictionary *Result = nil;
		Result = [[NSMutableDictionary alloc] init];

		NSMutableString *resultString = [NSMutableString string];
		for (NSString *key in [params allKeys]) {
			if ([resultString length] > 0) {
				[resultString appendString:@"&"];
			}
			[resultString appendFormat:@"%@=%@", key, params[key]];
		}

		NSString *newString = resultString;
		newString = [newString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
		NSString *UrlString = [NSString stringWithFormat:@"%@?action=%@&%@", self.KritikanstvoAPI, action, newString];

		NSURL *url = [NSURL URLWithString:UrlString];

		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

		NSURLResponse *response = nil;
		NSError *error = nil;
		NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
		if (error) {
			Result[@"success"] = @"";
			Result[@"message"] = error.localizedDescription;
		}
		else {
			NSError *jsonParseError = nil;
			NSMutableDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParseError];

			if (jsonParseError) {
				Result[@"success"] = @"";
				Result[@"message"] = jsonParseError.localizedDescription;
			}
			else {
				Result = jsonDictionary;
			}
		}

		return Result;
	}

	- (void) showSpinner:(UIView *) view :(BOOL) animated {
		if ([view isKindOfClass:[UITableView class]]) {
			UITableView *tmp = (UITableView *) view;
			tmp.separatorStyle = UITableViewCellSeparatorStyleNone;
		}

		MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:animated];
		hud.activityIndicatorColor = [UIColor blackColor];
		hud.backgroundColor = [UIColor whiteColor];
		hud.color = [UIColor whiteColor];
	}

	- (void) hideSpinner:(UIView *) view :(BOOL) animated {
		if ([view isKindOfClass:[UITableView class]]) {
			UITableView *tmp = (UITableView *) view;
			tmp.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
		}
		[MBProgressHUD hideHUDForView:view animated:animated];
	}

	- (void) showIndicator {
		[[SDNetworkActivityIndicator sharedActivityIndicator] startActivity];
	}

	- (void) hideIndicator {
		[[SDNetworkActivityIndicator sharedActivityIndicator] stopActivity];
	}

	- (void) animationFade:(UIView *) view :(NSString *) mode {
		CATransition *animation = [CATransition animation];

		if ([mode isEqualToString:@"in"]) {
			mode = kCATransitionMoveIn;
		}
		else {
			mode = kCATransitionReveal;
		}
		[animation setType:kCATransitionFade];
		[animation setSubtype:mode];
		[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
		[animation setFillMode:kCAFillModeBoth];
		[animation setDuration:.3];
		[view.layer addAnimation:animation forKey:@"UIViewAnimationIn"];
	}

	- (void) animationPush:(UIView *) view :(NSString *) from {
		CATransition *animation = [CATransition animation];

		if ([from isEqualToString:@"top"]) {
			from = kCATransitionFromBottom;
		}
		else if ([from isEqualToString:@"bottom"]) {
			from = kCATransitionFromTop;
		}
		else if ([from isEqualToString:@"left"]) {
			from = kCATransitionFromRight;
		}
		else {
			from = kCATransitionFromLeft;
		}
		[animation setType:kCATransitionPush];
		[animation setSubtype:from];
		[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
		[animation setFillMode:kCAFillModeBoth];
		[animation setDuration:.3];
		[view.layer addAnimation:animation forKey:@"UIViewAnimationBottom"];
	}

	- (UIColor *) ratingColor:(NSInteger) rating {
		UIColor *color;
		if (rating == 0) {
			color = [UIColor clearColor];
		}
		else if (rating >= 75) {
			color = [[UIColor alloc] initWithRed:0.0 green:0.7 blue:0.0 alpha:1.0];
		}
		else if (rating >= 55) {
			color = [UIColor orangeColor];
		}
		else if (rating >= 30) {
			color = [UIColor redColor];
		}
		else {
			color = [UIColor blackColor];
		}

		return color;
	}

@end

