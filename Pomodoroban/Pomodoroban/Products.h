//  Copyright (c) 2012 daren david taylor. All rights reserved.
//  www.darendavidtaylor.com

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@class Product;

@interface Products : NSObject <SKPaymentTransactionObserver, SKProductsRequestDelegate>
@property(nonatomic, retain) NSMutableArray *productsArray;

+ (Products *)instance;
- (void)purchaseProduct:(NSString *)productID;
- (void)restoreAllProducts;
- (void)setProductPurchased:(NSString *)productID;
- (Product *)productForProductID:(NSString *)productID;

@end