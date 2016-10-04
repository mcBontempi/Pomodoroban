//
//  StringAndPredicateCollection.h
//  HotWeekend
//
//  Created by Daren David Taylor on 07/08/2014.
//  Copyright (c) 2014 DDT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringAndPredicateCollection : NSObject

- (instancetype)initWIthStringAndPredicateArray:(NSArray *)stringAndPredicateArray;

- (void)incrementIndex;

- (NSString *)string;

- (id)predicate;

@end
