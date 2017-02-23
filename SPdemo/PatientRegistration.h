//
//  PatientRegistration.h
//  SPdemo
//
//  Created by Manickam on 20/10/16.
//  Copyright © 2016 Solvedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLiteManager.h"
#import "FMDatabase.h"
#import <QuartzCore/QuartzCore.h>
@interface PatientRegistration : UIViewController


@property(strong,nonatomic)NSData *imgData;

@property (strong, nonatomic) IBOutlet UITextField *PatientName;
@property (strong, nonatomic) IBOutlet UITextField *Day;
@property (strong, nonatomic) IBOutlet UITextField *month;
@property (strong, nonatomic) IBOutlet UITextField *year;
@property (strong, nonatomic) IBOutlet UIButton *save_btn;
@property (strong, nonatomic) IBOutlet UIImageView *patientImage;
@property (strong, nonatomic) IBOutlet UIButton *addImage_btn;
@property (strong, nonatomic) IBOutlet UIImageView *addImgPng;
@property (strong, nonatomic) IBOutlet UILabel *addimgLal;
@property (strong, nonatomic) IBOutlet UIButton *male1;
@property (strong, nonatomic) IBOutlet UIButton *female1;


- (IBAction)male_btn:(id)sender;
- (IBAction)back_BtnDismiss:(id)sender;
- (IBAction)Save_Btn:(id)sender;
- (IBAction)female_btn:(id)sender;
@end
