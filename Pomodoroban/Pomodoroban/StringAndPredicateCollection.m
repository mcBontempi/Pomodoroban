//
//  StringAndPredicateCollection.m
//  HotWeekend
//
//  Created by Daren David Taylor on 07/08/2014.
//  Copyright (c) 2014 DDT. All rights reserved.
//

#import "StringAndPredicateCollection.h"

@implementation StringAndPredicateCollection {
    NSUInteger _index;
    NSArray *_stringAndPredicateArray;
    
}

- (instancetype)initWIthStringAndPredicateArray:(NSArray *)stringAndPredicateArray
{
    if (self = [super init]) {
        _stringAndPredicateArray = stringAndPredicateArray;
    }
    
    return self;
}

- (void)incrementIndex
{
    _index++;
    
    if(_index == _stringAndPredicateArray.count) {
        
        _index = 0;
    }
}

- (NSString *)string
{
    return [_stringAndPredicateArray[_index] string];
}

- (id)predicate
{
    return [_stringAndPredicateArray[_index] predicate];
}

@end
