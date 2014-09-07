//
//  KItemViewController.m
//  Kritikanstvo
//
//  Created by Василий Наумкин on 27.08.14.
//  Copyright (c) 2014 bezumkin. All rights reserved.
//

#import "KItemViewController.h"

@interface KItemViewController ()

@end

@implementation KItemViewController

	- (void) viewDidLoad {
		[super viewDidLoad];

		self.titleView.text = self.data[@"russian"];
		self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
	}

@end
