//
//  StringAndPredicate.m
//  HotWeekend
//
//  Created by Daren David Taylor on 05/08/2014.
//  Copyright (c) 2014 DDT. All rights reserved.
//

#import "StringAndPredicate.h"

@implementation StringAndPredicate

- (instancetype)initWithString:(NSString *)string predicate:(id)predicate
{
    if (self = [super init]) {
        self.string = string;
        self.predicate = predicate;
    }
    return self;
}

@end
