//
//  KItemReviewController.m
//  Kritikanstvo
//
//  Created by Василий Наумкин on 30.08.14.
//  Copyright (c) 2014 bezumkin. All rights reserved.
//

#import "KItemReviewController.h"
#import "KWebViewController.h"

@interface KItemReviewController ()

@end

@implementation KItemReviewController

	- (void) viewDidLoad {
		[super viewDidLoad];

		self.Utils = [[KUtils alloc] init];
		[self loadDetails];

		self.tableView.ContentInset = UIEdgeInsetsMake(0, 0, self.parentViewController.tabBar.frame.size.height, 0);
	}

	- (void) viewWillDisappear:(BOOL) animated {
		[super viewWillDisappear:animated];
		[self.Utils hideIndicator];
	}

	- (void) prepareForSegue:(UIStoryboardSegue *) segue sender:(KItemReviewCell *) cell {
		if ([segue.identifier isEqualToString:@"review"]) {
			KWebViewController *webView = segue.destinationViewController;
			webView.url = cell.data[@"link"];
		}
		else if ([segue.identifier isEqualToString:@"kritikanstvo"]) {
			KWebViewController *webView = segue.destinationViewController;
			webView.url = self.parentViewController.data[@"link"];
			self.russian.titleLabel.text = self.parentViewController.data[@"russian"];
		}
	}

	- (void) loadDetails {
		[self.Utils showIndicator];
		[self.Utils showSpinner:self.view :YES];
		self.reviewsArray = [NSArray array];

		NSDictionary *data = self.parentViewController.data;
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
			// Make request in the background
			NSDictionary *params = @{@"type" : data[@"type"], @"codename" : data[@"codename"]};
			NSDictionary *response = [self.Utils remoteRequest:@"details" :params];

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
					NSDictionary *result = response[@"data"];
					[self templateDetails:result];

					self.reviewsArray = result[@"reviews"];
					if (self.reviewsArray.count > 0) {
						[self.tableView reloadData];
					}
					else {
						self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
					}
				}
			});
		});
	}

	- (void) templateDetails:(NSDictionary *) data {
		// Poster
		[self.imageView sd_setImageWithURL:[NSURL URLWithString:data[@"thumb"]]
						  placeholderImage:[UIImage imageNamed:@"NoPoster"]
		];
		// Russian title
		if (data[@"russian"] && ![data[@"russian"] isEqualToString:@""]) {
			self.russian.titleLabel.adjustsFontSizeToFitWidth = YES;
			self.russian.titleLabel.numberOfLines = 2;
			[self.russian setTitle:data[@"russian"] forState:UIControlStateNormal];
			[self.russian setTitle:data[@"russian"] forState:UIControlStateHighlighted];
		}
		else {
			self.russian.hidden = YES;
		}
		// Original, year
		NSMutableArray *original = [NSMutableArray array];
		if (data[@"original"] && ![data[@"original"] isEqualToString:@""]) {
			[original addObject:(NSString *) data[@"original"]];
		}
		if (data[@"year"] && [data[@"year"] intValue] > 0) {
			[original addObject:[NSString stringWithFormat:@"(%i)", [data[@"year"] intValue]]];
		}
		self.original.text = [original componentsJoinedByString:@" "];
		// Genres
		if ([(NSArray *) data[@"genres"] count] > 0) {
			self.genres.text = [(NSArray *) data[@"genres"] componentsJoinedByString:@", "];
		}
		else {
			self.genres.hidden = YES;
		}
		//Other Movie
		NSMutableArray *other = [NSMutableArray array];
		if ([data[@"type"] isEqualToString:@"movie"]) {
			if (data[@"runtime"] && [data[@"runtime"] intValue] > 0) {
				[other addObject:[NSString stringWithFormat:@"%i мин.", [data[@"runtime"] intValue]]];
			}
			if (data[@"rated"] && ![data[@"rated"] isEqualToString:@""]) {
				[other addObject:(NSString *) data[@"rated"]];
			}
		}
			// Other Game
		else if ([data[@"type"] isEqualToString:@"game"]) {
			if ([(NSArray *) data[@"platforms"] count] > 0) {
				other = data[@"platforms"];
			}
		}
		self.other.text = [other componentsJoinedByString:@", "];

		// Rating
		NSInteger rating = [(NSString *) data[@"rating"] intValue];
		if (rating > 0) {
			UIColor *color = [self.Utils ratingColor:rating];
			self.ratingLabel.tintColor = color;
			self.ratingLabel.backgroundColor = color;
			self.ratingLabel.textColor = [UIColor whiteColor];
			self.ratingLabel.text = [NSString stringWithFormat:@"%li", (long) rating];
		}
		else {
			self.ratingLabel.hidden = YES;
		}
	}

	- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
		return self.reviewsArray.count;
	}

	- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
		static NSString *CellIdentifier = @"cell";
		KItemReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

		cell.data = self.reviewsArray[(NSUInteger) indexPath.row];
		cell.tableView = self;
		[cell template];

		return cell;
	}

@end
