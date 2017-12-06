//
//  WordsAndQuestionsView.m
//  HotWeekend
//
//  Created by Daren David Taylor on 05/08/2014.
//  Copyright (c) 2014 DDT. All rights reserved.
//

#import "WordsAndQuestionsView.h"
#import "TagLabel.h"
#import "CALayer+Animations.h"
#import "StringAndPredicateCollection.h"

const CGFloat SidePadding = 3;
const CGFloat WordPadding = 3;

const NSUInteger fontSize = 27;

@interface WordsAndQuestionsView () <TagLabelDelegate>

@property (nonatomic, strong) NSMutableArray *itemsOnCurrentRow;
@property (nonatomic, assign) CGFloat rowContentWidth;

@end

@implementation WordsAndQuestionsView



- (void)awakeFromNib {
    [super awakeFromNib];
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self redrawWordsAndQuestions];
    
}

- (void)hideKeyBoard
{
    [self endEditing:YES];
}

- (void)centreRow
{
    self.rowContentWidth-=WordPadding;
    CGFloat totalSidePadding = self.frame.size.width - self.rowContentWidth;
    __block CGFloat runningx = totalSidePadding/2;
    
    [self.itemsOnCurrentRow enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        CGRect frame = view.frame;
        frame.origin.x = runningx;
        view.frame = frame;
        runningx += WordPadding + frame.size.width;
    }];
    
    self.itemsOnCurrentRow = [@[] mutableCopy];
    self.rowContentWidth = 0;
}

- (void)addView:(UIView *)view atPoint:(CGPoint *)point
{
    [view sizeToFit];
    
    if ((*point).x + view.frame.size.width + WordPadding > self.frame.size.width - (SidePadding*2)) {
        (*point).y+=view.frame.size.height + WordPadding;
        (*point).x=SidePadding;
        
        [self centreRow];
    }
    
    CGRect frame = view.frame;
    frame.origin = CGPointMake((*point).x,(*point).y);
    view.frame = frame;
    (*point).x+=view.frame.size.width + WordPadding;
    
    [self.itemsOnCurrentRow addObject:view];
    self.rowContentWidth += view.frame.size.width+WordPadding;
    
}

- (void)setWordsAndQuestions:(NSArray *)wordsAndQuestions
{
    _wordsAndQuestions = wordsAndQuestions;
    
    [self redrawWordsAndQuestions];
    
}

- (void)redrawWordsAndQuestions
{
    
    NSMutableArray *wordsAndQuestionsCopy = [_wordsAndQuestions mutableCopy];
    
    StringAndPredicateCollection *useLongBreaks = _wordsAndQuestions[17];
    
//    NSString *val = useLongBreaks.string;
    
    NSNumber *remove = (NSNumber*)useLongBreaks.predicate;
    
    if (remove.boolValue) {
        
        NSUInteger count = wordsAndQuestionsCopy.count;
        
        for (NSInteger i = 18 ; i < count ; i ++)
        {
            [wordsAndQuestionsCopy removeLastObject];
        }
    }
    
    
    [self.layer animateWithType:kCATransitionFade duration:0.1];
    
    
    [self.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        
        
        if (![view isKindOfClass:[UITextField class]]) {
            [view removeFromSuperview];
        }
        else {
            view.hidden = YES;
        }
        
    }];
    
    self.itemsOnCurrentRow = [@[] mutableCopy];
    self.rowContentWidth = 0;
    
    __block CGPoint point = CGPointMake(0, 0);
    
    [wordsAndQuestionsCopy enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ;
        
        if ([obj isKindOfClass:[NSString class]]) {
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            
            label.font = [UIFont fontWithName:@"HelveticaNeue" size:fontSize];
            label.backgroundColor= [UIColor clearColor];
            label.alpha = 0.8;
            label.textColor = [UIColor whiteColor];
            
            label.text = [NSString stringWithFormat:@" %@ ",obj];
            
            label.layer.cornerRadius =2;
            label.clipsToBounds = YES;
            [self addView:label atPoint:&point];
            
            
            [self addSubview:label];
            
        }
        else if ([obj isKindOfClass:[StringAndPredicateCollection class]]) {
            
            
            
            TagLabel *tagLabel = [[TagLabel alloc] initWithStringAndPredicateCollection:obj delegate:self];
            
            tagLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:fontSize];
            tagLabel.backgroundColor= [UIColor whiteColor];
            tagLabel.alpha = 0.8;
            
            tagLabel.text = [NSString stringWithFormat:@" %@ ",[obj string]];
            
            tagLabel.layer.cornerRadius =2;
            tagLabel.clipsToBounds = YES;
            [self addView:tagLabel atPoint:&point];
            
            
            [self addSubview:tagLabel];
        }
        else {
            assert (0);
        }
        
        
    }];
    
    [self centreRow];
    
    [self centreHeight];
    
    
    
}

- (void)centreHeight
{
    CGFloat bottom = [self.subviews.lastObject frame].origin.y + [self.subviews.lastObject frame].size.height;
    
    CGFloat screenHeight = self.frame.size.height;
    
    CGFloat offset = (screenHeight - bottom) /2;
    
    [self.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        view.frame = CGRectOffset(view.frame, 0, offset);
    }];
}

- (void)tappedOnTagLabel:(TagLabel *)tagLabel
{
    [self endEditing:YES];
    
    [self redrawWordsAndQuestions];
    [self.delegate userChangedWordsAndQuestionsView:self];
}


@end
