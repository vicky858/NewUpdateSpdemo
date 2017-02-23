//
//  library.m
//  SPdemo
//
//  Created by Manickam on 22/02/17.
//  Copyright © 2017 Solvedge. All rights reserved.
//

#import "library.h"

@implementation library
+(id)sharedInstance{
    static library *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;

}
//-(id)init{
//    self = [super init];
//    if (self) {
//        _sessionCont = [[SessionContainer alloc] initw];
//    }
//    return self;
//}
@end
