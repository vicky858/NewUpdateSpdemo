//
//  SurveyResult.h
//  SPdemo
//
//  Created by Manickam on 15/02/17.
//  Copyright © 2017 Solvedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SurveyResult : NSObject
@property(retain,nonatomic)NSString *Resultid;
@property(retain,nonatomic)NSString *Patientid;
@property(retain,nonatomic)NSString *surveyname;
@property(retain,nonatomic)NSMutableArray *Arrchoices;
@end
