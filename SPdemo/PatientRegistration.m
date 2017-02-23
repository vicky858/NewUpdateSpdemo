//
//  PatientRegistration.m
//  SPdemo
//
//  Created by Manickam on 20/10/16.
//  Copyright © 2016 Solvedge. All rights reserved.
//

#import "PatientRegistration.h"
#import "LocationPage.h"
#import "collectionview.h"
#import "calenderView.h"
#import <QuartzCore/QuartzCore.h>
static int tapCount = 0;

@interface PatientRegistration () <colldeleggate,UITextFieldDelegate,calenderViewDelegate>
{
    NSMutableArray *PatientListArr;
    NSMutableArray *JoinDataArray;
    calenderView *vewCalender;
    NSString *strPatid;
  
}

@end

@implementation PatientRegistration

@synthesize patientImage;
@synthesize PatientName,Day,month,year;



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    patientImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
    _save_btn.layer.cornerRadius = 12;
    _save_btn.layer.borderWidth=2;
    _save_btn.layer.borderColor=[[UIColor whiteColor]CGColor];
    _save_btn.layer.cornerRadius=4;
    
    PatientName.layer.borderColor=[[UIColor whiteColor]CGColor];
    Day.layer.borderColor=[[UIColor whiteColor]CGColor];
    month.layer.borderColor=[[UIColor whiteColor]CGColor];
    year.layer.borderColor=[[UIColor whiteColor]CGColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(int)patientCount{
    int totCt = 0;
    NSString *strQry = [NSString stringWithFormat:@"select count(rowid) as totCount from PatientTable"];
    SQLiteManager *dbManage = [[SQLiteManager alloc] init];
    FMResultSet *result = [dbManage ExecuteQuery:strQry];
    if ([result next]) {
        totCt = [result intForColumn:@"totCount"];
    }
    return totCt;
}


- (IBAction)Save_Btn:(id)sender
{
    
    SQLiteManager *sqlMng=[[SQLiteManager alloc]init];
    static NSString *strQry=@"INSERT INTO PatientTable(PatientName,Dob,Gender,Patient_id,Img_data)VALUES(?,?,?,?,?)";
    
    BOOL success = NO;
    NSString *alertString = @"Data Insertion failed";
    
    //Check [and] Find Patient Name Already in DataBase.....
    FMResultSet *fmr=[sqlMng ExecuteQuery:[NSString stringWithFormat:@"select count(*) c from PatientTable where PatientName='%@'",PatientName.text]];
    NSString *strcount;
    while ([fmr next])
    {
        strcount=[NSString stringWithFormat:@"%d",[fmr intForColumn:@"c"]];
        NSLog(@"value for colume:::%@",strcount);
    }
    NSInteger myInt = [strcount integerValue];
    int i=0;
    if (myInt==i)
    {
        if (PatientName.text.length>0 &&Day.text.length>0 &&month.text.length>0 &&year.text.length>0)
        {
            NSString *StrValue;
            if ([_male1 tag]==1) {StrValue=@"Male";
            }else if ([_male1 tag]==2){StrValue=@"Female";}else{StrValue=@"Not mentined";}
            
            UIDevice *device = [UIDevice currentDevice];
            NSString  *currentDeviceId = [[device identifierForVendor]UUIDString];
            strPatid=[NSString stringWithFormat:@"%d_%@",[self patientCount] + 1,currentDeviceId];
            NSString *DDMMYYY=[NSString stringWithFormat:@"%@/%@/%@",month.text,Day.text,year.text];
            PatientListArr=[[NSMutableArray alloc]init];
            [PatientListArr addObject:[NSString stringWithFormat:@"%@",PatientName.text]];
            [PatientListArr addObject:[NSString stringWithFormat:@"%@",DDMMYYY]];
            [PatientListArr addObject:[NSString stringWithFormat:@"%@",StrValue]];
            [PatientListArr addObject:strPatid];
            [PatientListArr addObject:[NSData dataWithData:_imgData]];
            //SQLite Query.......
            success=[sqlMng ExecuteInsertQuery:strQry withCollectionOfValues:PatientListArr];
            
            
        }
        else{
            alertString = @"Enter all fields";
        }
        if (success == NO)
        {
            UIAlertController *alertNew=[UIAlertController alertControllerWithTitle:@"Patient Register" message:alertString preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *nobutton=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            }];
            
            [alertNew addAction:nobutton];
            
            [self presentViewController:alertNew animated:YES completion:nil];
        }
        if(success==YES)
        {
            UIAlertController *alertNew=[UIAlertController alertControllerWithTitle:@"Patient Register" message:@"Saved" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *nobutton=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                    {
//                                         UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                                         LocationPage *controler=[storyboard instantiateViewControllerWithIdentifier:@"selectLocation"];
//                                         [self presentViewController:controler animated:YES completion:nil];
                                     [self performSegueWithIdentifier:@"LocationView" sender:self];
                                     }];
            
            [alertNew addAction:nobutton];
            [self presentViewController:alertNew animated:YES completion:nil];
            
        }
    }
    else
    {
        UIAlertController *alertNew=[UIAlertController alertControllerWithTitle:@"Patient Register" message:@"Patient Name was already In" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *nobutton=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                 {
                                     //no action
                                     [PatientName setClearsOnBeginEditing:YES];
                                 }];
        [alertNew addAction:nobutton];
        [self presentViewController:alertNew animated:YES completion:nil];
        
        
        
        
    }
}
- (IBAction)collectinViewdisplay:(id)sender
{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    collectionview *controler=[storyboard instantiateViewControllerWithIdentifier:@"FromRegistration"];
    controler.delegate=self;
    [self presentViewController:controler animated:YES completion:nil];
    
}


-(void)getdatacollection:(NSData *)imgdata
{
    
    _imgData=imgdata;
    UIImage *image = [UIImage imageWithData:_imgData];
    patientImage.image=image;
    _addimgLal.hidden=YES;
    _addImage_btn.hidden=YES;
    _addImgPng.hidden=YES;
    
    
}

- (IBAction)back_BtnDismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//get date of birth from Calendar...
- (IBAction)btnDate_Touch:(id)sender
{
    NSMutableDictionary *mdict = [[NSMutableDictionary alloc] init];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekdayOrdinal fromDate:[NSDate date]];
    int day = (int)[components day];
    int month = (int)[components month];
    int year = (int)[components year];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *tmpDate = [formatter dateFromString:[NSString stringWithFormat:@"%d/%d/%d",month,day,year-1]];
    [mdict setObject:tmpDate forKey:@"maxdate"];
    tmpDate = [formatter dateFromString:@"01/01/1860"];
    [mdict setObject:tmpDate forKey:@"mindate"];
    [mdict setObject:@"Select Date of Birth" forKey:@"header"];
    vewCalender = [[calenderView alloc] initMinMaxDate:mdict];
    vewCalender.delegate = self;
    [self.view addSubview:vewCalender.view];
}

-(void)calViewDateSelected:(NSString*)senderText{
    if (![senderText isEqualToString:@"exit"]) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM/dd/yyyy HH:mm"];
        NSDate *date = [dateFormat dateFromString:senderText];
        [dateFormat setDateFormat:@"MM"];
        month.text = [NSString stringWithFormat:@"%@",[dateFormat stringFromDate:date]];
        [dateFormat setDateFormat:@"dd"];
        Day.text = [NSString stringWithFormat:@"%@",[dateFormat stringFromDate:date]];
        [dateFormat setDateFormat:@"yyyy"];
        year.text = [NSString stringWithFormat:@"%@",[dateFormat stringFromDate:date]];
    }
} 

- (BOOL)isDateValid{
    BOOL isValid = YES;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekdayOrdinal fromDate:[NSDate date]];
    [components setDay:1];
    components.month=[month.text intValue];
    components.year=[year.text intValue];
    int  date =[Day.text intValue];
    NSRange range = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay
                                                       inUnit:NSCalendarUnitMonth
                                                      forDate:[[NSCalendar currentCalendar] dateFromComponents:components]];
    if (date>range.length){
        isValid = NO;
    }else{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        NSString *TodayString = [dateFormatter stringFromDate:[NSDate date]];
        NSString *TargetDateString = [NSString stringWithFormat:@"%@/%@/%@",month.text,Day.text,year.text];
        NSTimeInterval time = [[dateFormatter dateFromString:TodayString] timeIntervalSinceDate:[dateFormatter dateFromString:TargetDateString]];
        int days = time / 86400;
        if (days<365) {
            isValid = NO;
        }
    }
    return isValid;
}

///over calendar
- (IBAction)male_btn:(id)sender {
    UIImage *Image = [UIImage imageNamed:@"empty-radio.png"];
    [_female1 setImage:Image forState:UIControlStateNormal];
    
    UIImage *btnImage = [UIImage imageNamed:@"radio_activeBtn.png"];
    [_male1 setImage:btnImage forState:UIControlStateNormal];
    [_male1 setTag:1];
    if ([_male1 tag]==1) {
        NSLog(@"Male");
    }
    
    
}

- (IBAction)female_btn:(id)sender {
    [_male1 setTag:2];
    UIImage *btnImage1 = [UIImage imageNamed:@"empty-radio.png"];
    [_male1 setImage:btnImage1 forState:UIControlStateNormal];
    
    UIImage *btnImage = [UIImage imageNamed:@"radio_activeBtn.png"];
    [_female1 setImage:btnImage forState:UIControlStateNormal];
    if ([_male1 tag]==2) {
        NSLog(@"Female");
    }
}
#pragma prepareForSegue - methods
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"LocationView"])
    {
        LocationPage *view = [segue destinationViewController];
        view.strPatientId=strPatid;
        
    }
}

@end
