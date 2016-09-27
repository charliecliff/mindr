//
//  MDREmptyViewController.m
//  g5Mindr
//
//  Created by Charles Cliff on 7/21/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "MDREmptyViewController.h"
#import "g5ConfigAndMacros.h"

static NSString *const fancyQuote               = @"\"It is not the ship so much as the skillful sailing that assures the prosperous voyage.\"";
static NSString *const fancyQuoteHighlightedPart = @"skillful sailing";

@interface MDREmptyViewController () <UIWebViewDelegate>

@property (nonatomic, strong) IBOutlet UIImageView *logoImageView;
@property (nonatomic, strong) IBOutlet UIWebView *animationWebView;

@end

@implementation MDREmptyViewController

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self setupAnimationWebView];
}

#pragma mark - Animation

- (void)setupAnimationWebView {
  NSString *path = [[NSBundle mainBundle] pathForResource:@"buoy_logo_anim" ofType:@"html"];
  NSURL *url = [NSURL fileURLWithPath:path];
  [self.animationWebView loadRequest:[NSURLRequest requestWithURL:url]];
  self.animationWebView.delegate = self;
  self.animationWebView.scrollView.scrollEnabled = NO;
  self.animationWebView.scalesPageToFit = YES;
  self.animationWebView.contentMode = UIViewContentModeScaleAspectFit;
  self.animationWebView.userInteractionEnabled = NO;
  self.animationWebView.alpha = 0.0;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  
  [UIView animateWithDuration:0.3
                   animations:^{
    self.animationWebView.alpha = 1.0;
                   }
                   completion:^(BOOL finished) {
    [self.animationWebView stringByEvaluatingJavaScriptFromString:@"newAnimation(seq1);"];

                   }];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  NSLog(@"Error : %@",error);
}

@end
