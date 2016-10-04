#import "TagLabel.h"
#import "StringAndPredicateCollection.h"

@implementation TagLabel {
  
   
    __weak id<TagLabelDelegate> _delegate;
}

- (instancetype)initWithStringAndPredicateCollection:(StringAndPredicateCollection *)stringAndPredicateCollection delegate:(id<TagLabelDelegate>)delegate
{
    if (self == [super initWithFrame:CGRectZero]) {
        _delegate = delegate;
        _stringAndPredicateCollection = stringAndPredicateCollection;
        [self setupGuestureRecognizer];
    }
    
    return self;
}

- (void)setupGuestureRecognizer
{
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTappedOnLink:)];
    // if labelView is not set userInteractionEnabled, you must do so
    [self setUserInteractionEnabled:YES];
    [self addGestureRecognizer:gesture];
}



- (IBAction)userTappedOnLink:(id)sender
{
    [_stringAndPredicateCollection incrementIndex];
    
    [_delegate tappedOnTagLabel:self];
}



@end
