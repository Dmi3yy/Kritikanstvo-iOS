//
//  KWebViewController.m
//  Kritikanstvo
//
//  Created by Василий Наумкин on 06.09.14.
//  Copyright (c) 2014 bezumkin. All rights reserved.
//

#import "KWebViewController.h"

@implementation KWebViewController

	- (void) viewDidLoad {
		[super viewDidLoad];
		self.Utils = [[KUtils alloc] init];
		self.webView.scrollView.delegate = self;

		NSURL *url = [NSURL URLWithString:self.url];
		NSURLRequest *request = [NSURLRequest requestWithURL:url];

		self.titleView.text = url.host;
		self.webView.ScalesPageToFit = YES;
		[self.webView loadRequest:request];
	}

	- (void) viewWillDisappear:(BOOL) animated {
		[super viewWillDisappear:animated];
		[self.Utils hideIndicator];
		[self.navigationController setNavigationBarHidden:NO animated:YES];
		[[UIApplication sharedApplication] setStatusBarHidden:NO];
	}

	- (void) webViewDidStartLoad:(UIWebView *) webView {
		[self.Utils showIndicator];
	}

	- (void) webViewDidFinishLoad:(UIWebView *) webView {
		[self.Utils hideIndicator];
	}

	- (void) scrollViewDidScroll:(UIScrollView *) scrollView {
		if (scrollView.contentOffset.y > 0 && !self.navigationController.isNavigationBarHidden) {
			[self.navigationController setNavigationBarHidden:YES animated:YES];
			[[UIApplication sharedApplication] setStatusBarHidden:YES];
		}
		else if (scrollView.contentOffset.y < 0 && self.navigationController.isNavigationBarHidden) {
			[self.navigationController setNavigationBarHidden:NO animated:YES];
			[[UIApplication sharedApplication] setStatusBarHidden:NO];
		}
	}

@end
