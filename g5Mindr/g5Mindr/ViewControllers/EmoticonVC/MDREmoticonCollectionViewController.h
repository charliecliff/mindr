#import <UIKit/UIKit.h>

@class MDRReminder;

@interface MDREmoticonCollectionViewController : UICollectionViewController

@property (nonatomic, strong) MDRReminder *reminder;
@property (nonatomic, strong) NSArray *emoticonUnicodeCharacters;

@end
