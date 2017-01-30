//  Copyright (c) 2012 daren david taylor. All rights reserved.
//  www.darendavidtaylor.com

#import "Products.h"
#import "Product.h"

@implementation Products

@synthesize productsArray = _productsArray;

- (void)initStoreKit {
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    NSMutableArray *productIdentifiers = [[NSMutableArray alloc] init];
    
    for(Product *product in self.productsArray){
        [productIdentifiers addObject:product.productID];
    }
    
    NSSet *identifierSet = [NSSet setWithArray:productIdentifiers];
    
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:identifierSet];
    
    request.delegate = self;
    
    [request start];
}

- (void)purchaseProduct:(NSString *)productID {
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:productID];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)restoreAllProducts {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

+ (Products *)instance {
    static Products *_instance = nil;
    
    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
            
            [_instance initStoreKit];
        }
    }
    return _instance;
}

- (void)setProductPurchased:(NSString *)productID {
    for (Product *product in self.productsArray) {
        if ([product.productID isEqualToString:productID]) {
            product.purchased = YES;
            
            [self synchronize];
        }
    }
}

- (Product *)productForProductID:(NSString *)productID {
    for (Product *product in self.productsArray) {
        if ([product.productID isEqualToString:productID]) {
            return product;
        }
    }
    
    return nil;
}

- (id)init {
    self = [super init];
    if (self) {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        NSInteger productsDataVersion = 0;
        NSNumber *productsDataVersionNumber = [userDefaults objectForKey:@"productsDataVersion"];
        NSData *data = [userDefaults objectForKey:@"products"];
        if (productsDataVersionNumber) {
            productsDataVersion = productsDataVersionNumber.integerValue;
        }
        
        if (data) {
            self.productsArray = (NSMutableArray *) [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
        else {
            self.productsArray = [[NSMutableArray alloc] init];
        }
        
        // we want fall through here
        // its for the upgrade
        switch (productsDataVersion) {
            case 0: {
                Product *pack1 = [[Product alloc] initWithProductID:@"1"
                                                         teaserImage:@"premiumgray.png"
                                               productPurchasedImage:@"premium.png"
                                                           purchased:NO
                                                               title:@"Premium"
                                                         description:@"POMODOROBAN PREMIUM is an optional yearly subscription that removes ads and supports future development."];
                
                [self.productsArray addObject:pack1];
                productsDataVersion = 1;
            }

        }
        
        // now save all the stuff back to the NSUserDefaults
        [userDefaults setObject:[NSNumber numberWithInteger:productsDataVersion] forKey:@"productsDataVersion"];
        [userDefaults synchronize];
        
        [self synchronize];
        
    }
    
    return self;
}

- (void)synchronize {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:self.productsArray];
    [userDefaults setObject:myEncodedObject forKey:@"products"];
    [userDefaults synchronize];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    
    BOOL restored = NO;
    BOOL purchased = NO;
    BOOL failed = NO;
    
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                purchased = YES;
                break;
                
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                failed = YES;
                break;
                
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                restored = YES;
                
            default:
                break;
        }
    }
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
    [self recordTransaction: transaction content:transaction.payment.productIdentifier];
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
    [self recordTransaction: transaction content:transaction.originalTransaction.payment.productIdentifier];
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

-(void) recordTransaction:(SKPaymentTransaction *)transaction content:(NSString *) content{
    Product *product = [self productForProductID:content];
    product.purchased = YES;
    
    [self synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"productsRefreshed" object:nil];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    for(SKProduct *skproduct in response.products){
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
		[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
		[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
		[numberFormatter setLocale:skproduct.priceLocale];
		NSString *price = [numberFormatter stringFromNumber:skproduct.price];
        Product *product = [self productForProductID:skproduct.productIdentifier];
        product.price = price;
        [self synchronize];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"productsRefreshed" object:nil];
}

@end
