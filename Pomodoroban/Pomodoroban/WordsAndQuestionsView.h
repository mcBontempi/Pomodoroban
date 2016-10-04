//
//  WordsAndQuestionsView.h
//  HotWeekend
//
//  Created by Daren David Taylor on 05/08/2014.
//  Copyright (c) 2014 DDT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordsAndQuestionsViewDelegate.h"

@interface WordsAndQuestionsView : UIView

@property (nonatomic, strong) NSArray *wordsAndQuestions;

@property (nonatomic, weak) id<WordsAndQuestionsViewDelegate>delegate;

- (void)redrawWordsAndQuestions;

@end
