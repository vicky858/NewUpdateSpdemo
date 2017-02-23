//
//  NSString+NSStringAdditions.h
//  SPdemo
//
//  Created by Manickam on 28/11/16.
//  Copyright © 2016 Solvedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSStringAdditions)

+ (NSString *) base64StringFromData:(NSData *)data length:(int)length;
+ (NSData *) base64DataFromString:(NSString *)string;
@end
