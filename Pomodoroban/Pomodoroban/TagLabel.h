#import <UIKit/UIKit.h>
#import "TagLabelDelegate.h"

@class StringAndPredicateCollection;

@interface TagLabel : UILabel

- (instancetype)initWithStringAndPredicateCollection:(StringAndPredicateCollection *)stringAndPredicateCollection delegate:(id<TagLabelDelegate>)delegate;

@property (nonatomic, strong) StringAndPredicateCollection *stringAndPredicateCollection;

@end
