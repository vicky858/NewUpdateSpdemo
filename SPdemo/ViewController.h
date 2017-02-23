//
//  ViewController.h
//  SPdemo
//
//  Created by Manickam on 19/10/16.
//  Copyright © 2016 Solvedge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITextField *usernamne;
@property (weak, nonatomic) IBOutlet UITextField *passworsd;
@property (weak, nonatomic) IBOutlet UIButton *login;

- (IBAction)login_btn:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *img_view;


@end

