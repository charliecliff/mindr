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

@interface MDREmptyViewController ()

@property(nonatomic, strong) IBOutlet UILabel *fancyQuoteLabel;

@end

@implementation MDREmptyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildFancyQuote];
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

@end
