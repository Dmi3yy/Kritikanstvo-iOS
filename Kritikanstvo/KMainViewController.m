//
//  KMainViewController.m
//  Kritikanstvo
//
//  Created by Василий Наумкин on 27.08.14.
//  Copyright (c) 2014 bezumkin. All rights reserved.
//

#import "KMainViewController.h"
#import "KItemViewController.h"

@interface KMainViewController ()

@end

@implementation KMainViewController

	- (void) viewDidLoad {
		[super viewDidLoad];
		self.itemsDictionary = [NSMutableDictionary dictionary];
		self.typesArray = [NSMutableArray array];
		self.Utils = [[KUtils alloc] init];

		UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
		[refreshControl addTarget:self action:@selector(getMainItems) forControlEvents:UIControlEventValueChanged];
		self.refreshControl = refreshControl;

		[self.Utils showSpinner:self.navigationController.view :YES];
		[self getMainItems];

		// For animation
		self.loaded = NO;
		//[self.Utils ClearImagesCache];
	}

	- (void) viewWillDisappear:(BOOL) animated {
		[super viewWillDisappear:animated];
		[self.Utils hideIndicator];
	}

	- (void) prepareForSegue:(UIStoryboardSegue *) segue sender:(KMainItemCell *) cell {
		self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

		if ([segue.identifier isEqualToString:@"details"]) {
			KItemViewController *itemView = segue.destinationViewController;
			itemView.data = cell.data;
		}
	}

	- (void) getMainItems {
		[self.Utils showIndicator];

		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
			NSDictionary *response = [self.Utils remoteRequest:@"home" :@{}];

			dispatch_async(dispatch_get_main_queue(), ^{
				[self.Utils hideIndicator];
				[self.Utils hideSpinner:self.navigationController.view :YES];
				[self.refreshControl endRefreshing];

				BOOL success = [response[@"success"] boolValue];
				if (!success) {
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:response[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
					[alert show];
				}
				else {
					[self.typesArray removeAllObjects];
					[self.itemsDictionary removeAllObjects];

					NSArray *searchResultsArray = response[@"data"];
					for (NSDictionary *row in searchResultsArray) {
						NSString *type = row[@"type"];
						NSMutableArray *section = self.itemsDictionary[type];
						if (!section) {
							section = [NSMutableArray array];
							[self.typesArray addObject:type];
						}

						[section addObject:row];
						self.itemsDictionary[type] = section;
					}
					[self.tableView reloadData];
					if (!self.loaded) {
						self.loaded = YES;
					}
					else {
						[self.Utils animationPush:self.tableView :@"bottom"];
					}
				}
			});
		});
	}

	- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {
		return self.typesArray.count;
	}

	- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
		NSString *type = self.typesArray[(NSUInteger) section];
		NSArray *items = self.itemsDictionary[type];

		return items.count;
	}

	- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
		static NSString *CellIdentifier = @"cell";
		KMainItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

		NSString *type = self.typesArray[(NSUInteger) indexPath.section];
		NSArray *items = self.itemsDictionary[type];
		cell.data = items[(NSUInteger) indexPath.row];
		[cell template];

		return cell;
	}

	- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger) section {
		if (self.typesArray.count == 1) {
			return @"";
		}
		else {
			NSString *type = self.typesArray[(NSUInteger) section];
			if ([type isEqualToString:@"movie"]) {
				return @"Фильмы";
			}
			else {
				return @"Игры";
			}
		}
	}

	- (CGFloat) tableView:(UITableView *) tableView heightForHeaderInSection:(NSInteger) section {
		if (self.typesArray.count == 1) {
			return 0;
		}
		else {
			return 40.0f;
		}
	}

@end
