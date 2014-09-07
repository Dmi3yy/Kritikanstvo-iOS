//
//  KMainViewController.h
//  Kritikanstvo
//
//  Created by Василий Наумкин on 27.08.14.
//  Copyright (c) 2014 bezumkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KUtils.h"
#import "KMainItemCell.h"

@class KUtils;

@interface KMainViewController : UITableViewController

	@property (nonatomic, strong) NSMutableArray *typesArray;
	@property (nonatomic, strong) NSMutableDictionary *itemsDictionary;
	@property KUtils *Utils;
	@property BOOL loaded;

@end
