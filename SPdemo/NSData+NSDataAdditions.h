//
//  NSData+NSDataAdditions.h
//  SPdemo
//
//  Created by Manickam on 28/11/16.
//  Copyright © 2016 Solvedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSString;

@interface NSData (NSDataAdditions)

+ (NSData *) base64DataFromString:(NSString *)string;

@end
