//  Copyright (c) 2012 daren david taylor. All rights reserved.
//  www.darendavidtaylor.com

#import <Foundation/Foundation.h>

@interface Product : NSObject <NSCoding>

@property(nonatomic, strong) NSString *productID;
@property(nonatomic, strong) NSString *teaserImage;
@property(nonatomic, assign) BOOL purchased;
@property(nonatomic, strong) NSString *productPurchasedImage;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *desc;
@property(nonatomic, strong) NSString *price;

- (id)initWithProductID:(NSString *)productID teaserImage:(NSString *)teaserImage productPurchasedImage:(NSString *)productPurchasedImage purchased:(BOOL)purchased title:(NSString *)title description:(NSString *)desc;

@end
