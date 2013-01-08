//
//  NavigationController.m
//  CcAccelerometer
//
//  Created by Ian Fan on 27/12/12.
//
//

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController

-(NSUInteger)supportedInterfaceOrientations{
  return UIInterfaceOrientationMaskLandscape;
//  return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate {
  self.interfaceOrientation = [[UIDevice currentDevice] orientation];
  return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
