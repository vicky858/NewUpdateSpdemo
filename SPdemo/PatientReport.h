//
//  PatientReport.h
//  SPdemo
//
//  Created by Manickam on 20/10/16.
//  Copyright © 2016 Solvedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatientListTable.h"
#import "PatientHistry.h"
#import "SurveyResult.h"
#import "Choices.h"


@interface PatientReport : UIViewController<UITextViewDelegate, UITextFieldDelegate>


@property (strong, nonatomic) IBOutlet UIView *reportHeadView;
@property (strong, nonatomic) IBOutlet UIButton *home_out;
@property (strong, nonatomic) IBOutlet UITextField *PatientName;
@property (strong, nonatomic) IBOutlet UITextField *DateOfBirth;
@property (strong, nonatomic) IBOutlet UITextField *Location;
@property (strong, nonatomic) IBOutlet UITextField *SurveyName;
@property (strong, nonatomic) IBOutlet UITextField *Answer;
@property (strong, nonatomic) IBOutlet UIImageView *patientImage;
@property (strong, nonatomic) IBOutlet UITextField *genderLbl;
@property (strong, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet UIScrollView *scrreport;

//@property (strong, nonatomic) PatientDetails* patDetails;
@property(retain,nonatomic)PatientHistry *Phishiory;

- (IBAction)home_btn_action:(id)sender;






@end
