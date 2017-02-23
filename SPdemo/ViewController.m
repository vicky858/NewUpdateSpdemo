//
//  ViewController.m
//  SPdemo
//
//  Created by Manickam on 19/10/16.
//  Copyright © 2016 Solvedge. All rights reserved.
//

#import "ViewController.h"
#import "PatientListTable.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()
{
    NSUserDefaults *prefs;
}

@end

@implementation ViewController

@synthesize usernamne;
@synthesize passworsd;
@synthesize login,img_view;


//@synthesize view;

- (void)viewDidLoad{
    
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
        
       
        //Button Design
        
//        usernamne.layer.cornerRadius=7.0f;
//        usernamne.layer.borderWidth = 5.0f;
//        usernamne.layer.borderColor = [[UIColor grayColor]CGColor];
//        usernamne.clipsToBounds = YES;
    
        img_view.layer.borderColor=[[UIColor grayColor]CGColor];
        img_view.layer.cornerRadius=30;
        img_view.clipsToBounds = YES;
    
//        passworsd.layer.cornerRadius=7.0f;
//        passworsd.layer.borderWidth = 5.0f;
//        passworsd.layer.borderColor = [[UIColor grayColor]CGColor];
//        passworsd.clipsToBounds = YES;
    
        login.layer.borderColor=[[UIColor whiteColor]CGColor];
        login.layer.backgroundColor = [[UIColor lightGrayColor]CGColor];
        login.layer.cornerRadius = 20.0f;
        login.clipsToBounds = YES;
        
        prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:@"Admin" forKey:@"userName"];
        [prefs setObject:@"password" forKey:@"password"];
        
        [prefs synchronize];
        usernamne.text=@"Admin";
        passworsd.text=@"password";
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login_btn:(id)sender {
    NSString *savedUsername = [prefs stringForKey:@"userName"];
    NSString *savedPassword = [prefs stringForKey:@"password"];
    NSString *textfiled=usernamne.text;
    NSString *textfiled2=passworsd.text;
    
    if (usernamne.text.length>0 &&passworsd.text.length>0 )
    {
        if (([textfiled isEqualToString:savedUsername]) && ([textfiled2 isEqualToString:savedPassword]))
            
        {
            
            UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            PatientListTable *controler=[storyboard instantiateViewControllerWithIdentifier:@"PatientTableID"];
            [self presentViewController:controler animated:YES completion:nil];
            
        }
        else
        {
            UIAlertController *alertNew=[UIAlertController alertControllerWithTitle:@"Enter Correct Password And User Name" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *nobutton=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            }];
            [alertNew addAction:nobutton];
            [self presentViewController:alertNew animated:YES completion:nil];
            
        }
        
        
    }
    else
    {
        
        UIAlertController *alertNew=[UIAlertController alertControllerWithTitle:@"Enter All Filed" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *nobutton=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        }];
        [alertNew addAction:nobutton];
        [self presentViewController:alertNew animated:YES completion:nil];
        
    }

}
@end
















