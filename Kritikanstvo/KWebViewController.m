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
		self.barHidden = NO;
		self.barHeight = 0;
	}

	- (void) viewWillDisappear:(BOOL) animated {
		[self showNavigation];
	}

	- (void) webViewDidStartLoad:(UIWebView *) webView {
		[self.Utils showIndicator];
	}

	- (void) webViewDidFinishLoad:(UIWebView *) webView {
		[self.Utils hideIndicator];
	}

	- (void) scrollViewDidScroll:(UIScrollView *) scrollView {
		if (self.barHeight == 0) {
			CGRect navigationFrame = self.navigationController.navigationBar.frame;
			self.barHeight = navigationFrame.size.height;
		}

		if (scrollView.contentOffset.y > 0 && !self.barHidden) {
			[self hideNavigation];
		}
		else if (scrollView.contentOffset.y < 0 && self.barHidden) {
			[self showNavigation];
		}
	}

	- (void) hideNavigation {
		CGRect navigationFrame = self.navigationController.navigationBar.frame;

		self.navigationItem.titleView.hidden = YES;
		self.navigationItem.hidesBackButton = YES;

		navigationFrame.size.height = 0;
		self.navigationController.navigationBar.frame = navigationFrame;
		self.barHidden = YES;
	}

	- (void) showNavigation {
		CGRect navigationFrame = self.navigationController.navigationBar.frame;

		self.navigationItem.titleView.hidden = NO;
		self.navigationItem.hidesBackButton = NO;

		navigationFrame.size.height = self.barHeight;
		self.navigationController.navigationBar.frame = navigationFrame;
		self.barHidden = NO;
	}

@end
