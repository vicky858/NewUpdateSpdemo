//
//  PatientHistry.h
//  SPdemo
//
//  Created by Manickam on 26/10/16.
//  Copyright © 2016 Solvedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PatientHistry : NSObject

@property(retain,nonatomic)NSString *patientname;
@property(retain,nonatomic)NSString *dob;
@property(retain,nonatomic)NSString *gender;
@property(retain,nonatomic)NSString *patientid;
@property(retain,nonatomic)NSString *locationName;
@property(retain,nonatomic)NSString *surveyname;
@property(retain,nonatomic)NSString *answer;
@property(retain,nonatomic)NSData *dataForImag;
@property(retain,nonatomic)NSMutableArray *Arrsurveyresult;

@end
