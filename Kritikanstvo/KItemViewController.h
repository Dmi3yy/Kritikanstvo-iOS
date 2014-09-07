//
//  KItemViewController.h
//  Kritikanstvo
//
//  Created by Василий Наумкин on 27.08.14.
//  Copyright (c) 2014 bezumkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KItemViewController : UITabBarController <UITabBarDelegate>

	@property (nonatomic, assign) IBOutlet UINavigationItem *itemNavigation;
	@property (nonatomic, assign) IBOutlet UILabel *titleView;
	@property NSDictionary *data;

@end
