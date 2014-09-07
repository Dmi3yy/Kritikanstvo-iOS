//
//  KSearchViewController.m
//  Kritikanstvo
//
//  Created by Василий Наумкин on 26.08.14.
//  Copyright (c) 2014 bezumkin. All rights reserved.
//

#import "KSearchViewController.h"
#import "KItemViewController.h"


@interface KSearchViewController ()

@end

@implementation KSearchViewController

	- (void) viewDidLoad {
		[super viewDidLoad];
		self.itemsDictionary = [NSMutableDictionary dictionary];
		self.typesArray = [NSMutableArray array];

		self.Utils = [[KUtils alloc] init];
	}

	- (void) viewWillAppear:(BOOL) animated {
		if (self.typesArray.count == 0) {
			[self.searchBar becomeFirstResponder];
		}
	}

	- (void) viewWillDisappear:(BOOL) animated {
		[super viewWillDisappear:animated];
		[self.Utils hideIndicator];
		[self.searchBar resignFirstResponder];
	}

	- (void) searchBarSearchButtonClicked:(UISearchBar *) searchBar {
		[self mainSearch:searchBar.text];
	}

	- (void) searchBar:(UISearchBar *) searchBar textDidChange:(NSString *) searchText {
		// Clear search text
		if ([searchText isEqualToString:@""] && self.itemsDictionary.count > 0) {
			[self.itemsDictionary removeAllObjects];
			[self.typesArray removeAllObjects];
			[self.tableView reloadData];
		}
	}

	- (void) prepareForSegue:(UIStoryboardSegue *) segue sender:(KMainItemCell *) cell {
		self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

		if ([segue.identifier isEqualToString:@"details"]) {
			KItemViewController *itemView = segue.destinationViewController;
			itemView.data = cell.data;
		}
	}

	- (void) mainSearch:(NSString *) searchText {
		[self.searchBar resignFirstResponder];
		[self.typesArray removeAllObjects];
		[self.itemsDictionary removeAllObjects];

		[self.Utils showIndicator];
		[self.Utils showSpinner:self.view :YES];

		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
			// Make request in the background
			KUtils *Utils = [[KUtils alloc] init];
			NSDictionary *response = [Utils remoteRequest:@"search" :@{@"query" : searchText}];

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

	- (CGFloat) tableView:(UITableView *) tableView heightForHeaderInSection:(NSInteger) section {
		if (self.typesArray.count == 1) {
			return 0;
		}
		else {
			return 30.0f;
		}
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

@end
