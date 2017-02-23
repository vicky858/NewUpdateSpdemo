//
//  PatientReport.m
//  SPdemo
//
//  Created by Manickam on 20/10/16.
//  Copyright © 2016 Solvedge. All rights reserved.
//

#import "PatientReport.h"
#import "PatientListTable.h"
#import "SQLiteManager.h"

@interface PatientReport ()

@end

@implementation PatientReport

@synthesize SurveyName,Answer,home_out,patientImage,genderLbl;

@synthesize PatientName,DateOfBirth,Location;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
    
    patientImage.layer.masksToBounds = YES;
    patientImage.layer.cornerRadius = 20.0;
    UILabel *newl= [[UILabel alloc] initWithFrame:CGRectMake(0, patientImage.bounds.size.width-15.5f, patientImage.bounds.size.width, 28)];
    newl.backgroundColor = [UIColor colorWithRed:(73/255.0f) green:(73/255.0f) blue:(73/255.0f) alpha:1.0];
    newl.textColor = [UIColor whiteColor];
    newl.textAlignment = NSTextAlignmentCenter;
    newl.text=_Phishiory.patientname;
    [patientImage addSubview:newl];
    PatientName.text=_Phishiory.patientname;
    DateOfBirth.text=_Phishiory.dob;
    Location.text=_Phishiory.locationName;
    genderLbl.text=_Phishiory.gender;
    
    
    PatientName.layer.borderWidth=1.5;
    PatientName.layer.borderColor=[UIColor colorWithRed:0/255. green:0/255. blue:0/255. alpha:1.0].CGColor;
    PatientName.layer.cornerRadius=5;
    
    DateOfBirth.layer.borderWidth=1.5;
    DateOfBirth.layer.borderColor=[UIColor colorWithRed:0/255. green:0/255. blue:0/255. alpha:1.0].CGColor;
    DateOfBirth.layer.cornerRadius=5;
    
    Location.layer.borderWidth=1.5;
    Location.layer.borderColor=[UIColor colorWithRed:0/255. green:0/255. blue:0/255. alpha:1.0].CGColor;
    Location.layer.cornerRadius=5;
    
    SurveyName.layer.borderWidth=1.5;
    SurveyName.layer.borderColor=[UIColor colorWithRed:0/255. green:0/255. blue:0/255. alpha:1.0].CGColor;
    SurveyName.layer.cornerRadius=5;
    
    Answer.layer.borderWidth=1.5;
    Answer.layer.borderColor=[UIColor colorWithRed:0/255. green:0/255. blue:0/255. alpha:1.0].CGColor;
    Answer.layer.cornerRadius=5;
    
    home_out.layer.borderWidth=1.5;
    home_out.layer.borderColor=[UIColor colorWithRed:0/255. green:0/255. blue:0/255. alpha:1.0].CGColor;
    home_out.layer.cornerRadius=5;
    
    genderLbl.layer.borderWidth=1.5;
    genderLbl.layer.borderColor=[UIColor colorWithRed:0/255. green:0/255. blue:0/255. alpha:1.0].CGColor;
    genderLbl.layer.cornerRadius=5;
    
    UIImage *imgfromdata=[UIImage imageWithData:_Phishiory.dataForImag];
    patientImage.image=imgfromdata;
    int x=50;
    int y=0;
    for (SurveyResult *srres in _Phishiory.Arrsurveyresult) {
        UILabel *lblsurvyname=[[UILabel alloc]initWithFrame:CGRectMake(x, y, 200, 30)];
        lblsurvyname.text=@"SurveyName: ";
        lblsurvyname.font=[UIFont fontWithName:@"Helvetica Neue-Bold" size:18.0];
        lblsurvyname.textColor=[UIColor redColor];
        
        [_scrreport addSubview:lblsurvyname];
        x=x+250;
       
        UILabel *lblsurveyval=[[UILabel alloc]initWithFrame:CGRectMake(x, y, 200, 30)];
        lblsurveyval.text=srres.surveyname;
        [_scrreport addSubview:lblsurveyval];
       
        x=50;
        y=y+40;
        UILabel *lblchoices=[[UILabel alloc]initWithFrame:CGRectMake(x, y, 200, 30)];
        lblchoices.text=@"Answers: ";
        lblchoices.font=[UIFont fontWithName:@"Helvetica Neue-Bold" size:18.0];
        lblchoices.textColor=[UIColor redColor];
        [_scrreport addSubview:lblchoices];
        x=x+250;
        
        for (Choices *chic in srres.Arrchoices) {
            
            UILabel *lblansval=[[UILabel alloc]initWithFrame:CGRectMake(x, y, 200, 30)];
            lblansval.text= chic.choice;
            [_scrreport addSubview:lblansval];
            y=y+40;
        }
        x=50;
        y=y+40;
    }
    [_scrreport setContentSize:CGSizeMake(_scrreport.frame.size.width, y+100)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)home_btn_action:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end

