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

@property(nonatomic, strong) IBOutlet UILabel *fancyQuoteLabel;
@property (nonatomic, strong) IBOutlet UIWebView *animationWebView;

@end

@implementation MDREmptyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildFancyQuote];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self setupAnimationWebView];
}

- (void)buildFancyQuote {
        
    UIFont *systemFont = [UIFont fontWithName:@"ProximaNovaSoftW03-Semibold" size:25];
    NSDictionary * fontAttributes = [[NSDictionary alloc] initWithObjectsAndKeys:systemFont, NSFontAttributeName, nil];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:fancyQuote attributes:fontAttributes];

    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attString.length)];

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [attString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attString.length)];

    NSRange range = [fancyQuote rangeOfString:fancyQuoteHighlightedPart];
    [attString addAttribute:NSForegroundColorAttributeName value:GOLD_COLOR range:range];
   
    self.fancyQuoteLabel.attributedText = attString;
}

#pragma mark - Animation

- (void)setupAnimationWebView {
  NSString *path = [[NSBundle mainBundle] pathForResource:@"buoy_logo_anim"
                                                   ofType:@"html"];
  NSURL *url = [NSURL fileURLWithPath:path];
  [self.animationWebView loadRequest:[NSURLRequest requestWithURL:url]];
  self.animationWebView.delegate = self;
  
  self.animationWebView.scrollView.scrollEnabled = NO;
  self.animationWebView.scalesPageToFit = YES;
  self.animationWebView.contentMode = UIViewContentModeScaleAspectFit;

  self.animationWebView.userInteractionEnabled = NO;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  
  NSLog(@"success");
//  self.webViewDoneLoading = YES;
//  
//  if (self.loadAnimation) {
    [self.animationWebView stringByEvaluatingJavaScriptFromString:@"newAnimation(seq1);"];
//    [UIView animateWithDuration:0.3 animations:^{
//      self.loadingAnimation.alpha = 1.0;
//      self.loadingRidesLabel.alpha = 1.0;
//    }];
//  }
//  else {
//    if (self.completion) {
//      [self animationModeChange:self.completion];
//    }
//  }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  
  NSLog(@"Error : %@",error);
}

@end
