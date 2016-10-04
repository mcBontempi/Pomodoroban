//
//  StringAndPredicate.h
//  HotWeekend
//
//  Created by Daren David Taylor on 05/08/2014.
//  Copyright (c) 2014 DDT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringAndPredicate : NSObject

@property (nonatomic, strong) NSString *string;
@property (nonatomic, strong) id predicate;

- (instancetype)initWithString:(NSString *)string predicate:(id)predicate;

@end
