//
//  KItemGalleryController.m
//  Kritikanstvo
//
//  Created by Василий Наумкин on 30.08.14.
//  Copyright (c) 2014 bezumkin. All rights reserved.
//

#import "KItemGalleryController.h"
#import "KItemGalleryCell.h"
#import "KUtils.h"

@interface KItemGalleryController ()

@end

@implementation KItemGalleryController

	- (void) viewDidLoad {
		[super viewDidLoad];
		self.Utils = [[KUtils alloc] init];
		self.images = [NSArray array];

		[self loadImages];
		[self prepareBigImage];
	}

	- (void) viewWillDisappear:(BOOL) animated {
		[super viewWillDisappear:animated];
		[self hideBigImage:nil];
		[self.Utils hideIndicator];
	}

	- (void) loadImages {
		[self.Utils showIndicator];
		[self.Utils showSpinner:self.view :YES];

		NSDictionary *data = self.parentViewController.data;
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
			// Make request in the background
			KUtils *Utils = [[KUtils alloc] init];
			NSDictionary *params = @{@"type" : data[@"type"], @"codename" : data[@"codename"]};
			NSDictionary *response = [Utils remoteRequest:@"images" :params];

			// Return to main queue and process the result
			dispatch_async(dispatch_get_main_queue(), ^{
				[self.Utils hideIndicator];
				[self.Utils hideSpinner:self.view :YES];

				BOOL success = [response[@"success"] boolValue];
				if (!success) {
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:response[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
					[alert show];
				}
				else {
					self.images = response[@"data"];
					[self.collectionView reloadData];
				}
			});
		});
	}

	- (UICollectionViewCell *) collectionView:(UICollectionView *) collectionView cellForItemAtIndexPath:(NSIndexPath *) indexPath {
		static NSString *CellIdentifier = @"cell";
		KItemGalleryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];

		NSDictionary *data = self.images[(NSUInteger) indexPath.row];
		[cell loadThumb:data[@"thumb"]];

		return cell;
	}

	- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *) collectionView {
		return 1;
	}

	- (NSInteger) collectionView:(UICollectionView *) collectionView numberOfItemsInSection:(NSInteger) section {
		return self.images.count;
	}

	- (void) collectionView:(UICollectionView *) collectionView didSelectItemAtIndexPath:(NSIndexPath *) indexPath {
		[self showBigImage:indexPath.row :@"in"];
	}

	- (void) prepareBigImage {
		// Gestures
		self.imageView.userInteractionEnabled = YES;
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideBigImage:)];
		[self.imageView addGestureRecognizer:tap];

		UISwipeGestureRecognizer *prev = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(prevBigImage:)];
		[prev setDirection:UISwipeGestureRecognizerDirectionRight];
		[self.imageView addGestureRecognizer:prev];

		UISwipeGestureRecognizer *next = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextBigImage:)];
		[next setDirection:UISwipeGestureRecognizerDirectionLeft];
		[self.imageView addGestureRecognizer:next];
	}

	- (void) showBigImage:(NSInteger) index :(NSString *) animation {
		NSDictionary *data = self.images[(NSUInteger) index];
		self.activeImage = index;

		[self.imageView setImageWithURL:[NSURL URLWithString:data[@"image"]]
			usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge
		];

		[[UIApplication sharedApplication] setStatusBarHidden:YES];
		self.navigationController.navigationBar.hidden = YES;
		self.parentViewController.tabBar.hidden = YES;
		self.imageView.alpha = 1;
		self.collectionView.alpha = 0;
		[self animateImage:animation];
	}

	- (void) nextBigImage:(UIGestureRecognizer *) recognizer {
		NSInteger index = self.activeImage + 1;
		if (index < self.images.count) {
			[self showBigImage:index :@"left"];
		}
		else {
			[self hideBigImage:recognizer];
		}
	}

	- (void) prevBigImage:(UIGestureRecognizer *) recognizer {
		NSInteger index = self.activeImage - 1;
		if (index >= 0) {
			[self showBigImage:index :@"right"];
		}
		else {
			[self hideBigImage:recognizer];
		}

	}

	- (void) hideBigImage:(UIGestureRecognizer *) recognizer {
		self.navigationController.navigationBar.hidden = NO;
		self.parentViewController.tabBar.hidden = NO;
		[[UIApplication sharedApplication] setStatusBarHidden:NO];

		[UIView beginAnimations:@"" context:nil];
		self.imageView.alpha = 0;
		self.collectionView.alpha = 1;
		[UIView commitAnimations];

		[self animateImage:@"out"];
	}

	- (void) animateImage:(NSString *) animation {
		if ([animation isEqualToString:@"left"]) {
			[self.Utils animationPush:self.imageView :@"left"];
		}
		else if ([animation isEqualToString:@"right"]) {
			[self.Utils animationPush:self.imageView :@"right"];
		}
		else if ([animation isEqualToString:@"out"]) {
			[self.Utils animationFade:self.imageView :@"in"];
		}
		else {
			[self.Utils animationFade:self.imageView :@"out"];
		}
	}

@end
