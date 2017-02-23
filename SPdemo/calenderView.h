//
//  calenderView.h
//  SEPRODCCP
//
//  Created by administrator on 05/12/11.
//  Copyright 2011 Solvedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol calenderViewDelegate <NSObject>

@optional
//// Delegate used to call the parent class 
-(void)calViewDateSelected:(NSString*)senderText;
-(void)calViewSurveyDateSelected:(NSDictionary*)dicSender;
@end

@interface calenderView : UIViewController {
    id<calenderViewDelegate> delegate;
    IBOutlet UIButton *btnBack;
    IBOutlet UIButton *btnNext;
    IBOutlet UIButton *btnMonth;
    IBOutlet UIButton *btnYear;
    IBOutlet UIView *vewDays;
    IBOutlet UIScrollView *scvMonth;
    IBOutlet UIView *vewYear;
    IBOutlet UIButton *btnDone;
    
    IBOutlet UILabel *lblStatus;
    IBOutlet UILabel *lblDayString;
    IBOutlet UISwitch *swMerdian;
    IBOutlet UILabel *lblDay;
    IBOutlet UIButton *btnmm;
    IBOutlet UIButton *btnHH;
    IBOutlet UISlider *sliderHour;
    IBOutlet UIView *vewSlider;
    IBOutlet UITextField *txtDate;
    IBOutlet UITextField *txtMin;
    IBOutlet UITextField *txtHour;
    IBOutlet UIButton *btnHMok;
    
//    int yearMax; int monthMax; int dayMax;
//    int yearMin; int monthMin; int dayMin;
    NSDate *dtMax;
    NSDate *dtMin;
    NSDate *dtDef;
}
@property (nonatomic,strong) NSMutableDictionary *dicSurPage;
@property (retain) id<calenderViewDelegate> delegate;
@property(nonatomic,retain) NSString*strTitle;
-(void)setMaximumDate:(NSDate*)dtMaxFrm;
-(void)setMinimumDate:(NSDate*)dtMinFrm;
- (void)setTitleStatus:(NSString*)strTitleFrm;
- (IBAction)btnExit_Touch:(id)sender;
- (IBAction)btnHMok_Touch:(id)sender;
- (IBAction)btnYear_Touch:(id)sender;
- (IBAction)btnBack_Touch:(id)sender;
- (IBAction)btnNext_Touch:(id)sender;
- (IBAction)btnMonth_Touch:(id)sender;
- (IBAction)btnDone_Touch:(id)sender;
- (IBAction)btnAllMonth_Touch:(id)sender;
- (IBAction)btnAllYear_Touch:(id)sender;
- (IBAction)btnYearBack_Touch:(id)sender;
- (IBAction)btnYearNag_Touch:(id)sender;
- (void)setDateControl:(NSDateComponents*)dateComp;
- (IBAction)btnAllDay_Touch:(id)sender;
- (IBAction)btnmmTouch:(id)sender;
- (IBAction)btnHHTouch:(id)sender;
-(calenderView*)initMinMaxDate:(NSDictionary*)dicsender;
@end
