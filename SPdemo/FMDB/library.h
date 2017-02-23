//
//  library.h
//  SPdemo
//
//  Created by Manickam on 22/02/17.
//  Copyright © 2017 Solvedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SessionContainer.h"

@interface library : NSObject

@property(nonatomic,retain) SessionContainer *sessionCont;
@property(retain,nonatomic)UIColor *ClrStr;
+(id)sharedInstance;
@end
