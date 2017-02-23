//
//  LocationPage.h
//  SPdemo
//
//  Created by Manickam on 20/10/16.
//  Copyright © 2016 Solvedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLiteManager.h"
#import "FMDatabase.h"
#import "SurveyPage.h"

@interface LocationPage : UIViewController

@property(retain,nonatomic)NSString *strPatientId;
//List of Location Outlets....
- (IBAction)Location_Hip_btn:(id)sender;
- (IBAction)Location_Knee_btn:(id)sender;

@end
