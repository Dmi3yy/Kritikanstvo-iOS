//
//  KWebViewController.h
//  Kritikanstvo
//
//  Created by Василий Наумкин on 06.09.14.
//  Copyright (c) 2014 bezumkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KUtils.h"

@class KUtils;

@interface KWebViewController : UIViewController <UIWebViewDelegate, UIScrollViewDelegate>

	@property KUtils *Utils;
	@property IBOutlet UIWebView *webView;
	@property IBOutlet UILabel *titleView;
	@property NSString *url;

@end
