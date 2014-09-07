//
//  KSearchViewController.h
//  Kritikanstvo
//
//  Created by Василий Наумкин on 26.08.14.
//  Copyright (c) 2014 bezumkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMainItemCell.h"

@class KUtils;

@interface KSearchViewController : UITableViewController <UISearchBarDelegate>

	@property KUtils *Utils;
	@property (nonatomic, assign) IBOutlet UISearchBar *searchBar;
	@property (nonatomic, strong) NSMutableArray *typesArray;
	@property (nonatomic, strong) NSMutableDictionary *itemsDictionary;

	- (void) mainSearch:(NSString *) searchText;

@end
