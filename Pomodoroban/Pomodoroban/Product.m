//  Copyright (c) 2012 daren david taylor. All rights reserved.
//  www.darendavidtaylor.com

#import "Product.h"

@implementation Product
@synthesize productID = _productId;
@synthesize teaserImage = _teaserImage;
@synthesize purchased = _purchased;
@synthesize productPurchasedImage = _productPurchasedImage;
@synthesize price = _price;


- (id)initWithProductID:(NSString *)productID teaserImage:(NSString *)teaserImage productPurchasedImage:(NSString *)productPurchasedImage purchased:(BOOL)purchased title:(NSString *)title description:(NSString *)desc {
    self = [super init];
    if (self) {
        self.productID = productID;
        self.teaserImage = teaserImage;
        self.productPurchasedImage = productPurchasedImage;
        self.purchased = purchased;
        self.title = title;
        self.desc = desc;
 }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.productID forKey:@"productID"];
    [encoder encodeObject:self.teaserImage forKey:@"teaserImage"];
    [encoder encodeObject:self.productPurchasedImage forKey:@"productPurchasedImage"];
    [encoder encodeObject:[NSNumber numberWithBool:self.purchased] forKey:@"purchased"];
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.desc forKey:@"desc"];
}


- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.productID = [decoder decodeObjectForKey:@"productID"];
        self.teaserImage = [decoder decodeObjectForKey:@"teaserImage"];
        self.productPurchasedImage = [decoder decodeObjectForKey:@"productPurchasedImage"];
        self.purchased = [[decoder decodeObjectForKey:@"purchased"] boolValue];
        self.title = [decoder decodeObjectForKey:@"title"];
        self.desc = [decoder decodeObjectForKey:@"desc"];
    }
    return self;
}


@end
