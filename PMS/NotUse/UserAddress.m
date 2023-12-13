//
//  UserAddress.m
//  Mangkud
//
//  Created by Firststep Consulting on 14/3/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "UserAddress.h"

@interface UserAddress () <GMSAutocompleteViewControllerDelegate>
{
    
}
@end

@implementation UserAddress

@synthesize mode,addressNo,addressTumbol,addressAmphor,addressCity,addressPostal,titleLabel,addressLabel1,addressLabel2,addressLabel3,addressLabel4,addressLabel5,addressLabel6,addressField1,addressField2,addressField3,addressField4,addressField5,addressField6,submitBtn;

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    titleLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+8];
    titleLabel.textColor = [UIColor darkGrayColor];
    
    NSString *fontName = delegate.fontRegular;
    float fontSize = delegate.fontSize;
    addressLabel1.font = [UIFont fontWithName:fontName size:fontSize];
    addressLabel2.font = [UIFont fontWithName:fontName size:fontSize];
    addressLabel3.font = [UIFont fontWithName:fontName size:fontSize];
    addressLabel4.font = [UIFont fontWithName:fontName size:fontSize];
    addressLabel5.font = [UIFont fontWithName:fontName size:fontSize];
    addressLabel6.font = [UIFont fontWithName:fontName size:fontSize];
    
    addressField1.font = [UIFont fontWithName:fontName size:fontSize];
    addressField2.font = [UIFont fontWithName:fontName size:fontSize];
    addressField3.font = [UIFont fontWithName:fontName size:fontSize];
    addressField4.font = [UIFont fontWithName:fontName size:fontSize];
    addressField5.font = [UIFont fontWithName:fontName size:fontSize];
    addressField6.font = [UIFont fontWithName:fontName size:fontSize];
    
    addressField1.text = addressNo;
    //addressField2.text = ...;
    addressField2.tag = 22;
    addressField2.delegate = self;
    addressField3.text = addressTumbol;
    addressField4.text = addressAmphor;
    addressField5.text = addressCity;
    addressField6.text = addressPostal;
    
    submitBtn.titleLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+3];
    submitBtn.backgroundColor = delegate.mainThemeColor;
    submitBtn.layer.cornerRadius = submitBtn.frame.size.height/2;
    submitBtn.layer.masksToBounds = YES;
    
    [self addbottomBorder:addressField1 withColor:nil];
    [self addbottomBorder:addressField2 withColor:nil];
    [self addbottomBorder:addressField3 withColor:nil];
    [self addbottomBorder:addressField4 withColor:nil];
    [self addbottomBorder:addressField5 withColor:nil];
    [self addbottomBorder:addressField6 withColor:nil];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"Start");
    
    if (textField.tag == 22) {
        GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
        acController.delegate = self;
        acController.tableCellBackgroundColor = [UIColor whiteColor];
        GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
        filter.type = kGMSPlacesAutocompleteTypeFilterAddress;
        filter.country = @"TH";
        acController.autocompleteFilter = filter;
        [self presentViewController:acController animated:YES completion:nil];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"End");
    
    if (textField.tag == 22) {
        
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{    
    [textField resignFirstResponder];
    return YES;
}

// Handle the user's selection.
- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
    [self dismissViewControllerAnimated:YES completion:nil];
    // Do something with the selected place.
    //NSLog(@"Place %@", place);
    //NSLog(@"Place name %@", place.name);
    //NSLog(@"Place address %@", place.formattedAddress);
    //NSLog(@"Place attributions %@", place.attributions.string);
    /*
    for (int i = 0; i < [place.addressComponents count]; i++)
    {
        NSLog(@"name %@ = type %@", place.addressComponents[i].name, place.addressComponents[i].type);
    }
    */
    
    addressField3.text = @"";
    addressField4.text = @"";
    addressField5.text = @"";
    addressField6.text = @"";
    
    for (GMSAddressComponent * component in place.addressComponents)
    {
        //NSLog(@"name %@ = type %@", component.name,component.type);
        
        if ([component.type isEqual:@"sublocality_level_2"])//แขวง
        {
            addressField3.text = component.name;
            addressField3.text = [addressField3.text stringByReplacingOccurrencesOfString:@"แขวง " withString:@""];
        }
        if ([component.type isEqual:@"sublocality_level_1"])//เขต
        {
            addressField4.text = component.name;
            addressField4.text = [addressField4.text stringByReplacingOccurrencesOfString:@"เขต " withString:@""];
        }
        if ([component.type isEqual:@"administrative_area_level_1"])//จังหวัด
        {
            addressField5.text = component.name;
        }
        if ([component.type isEqual:@"postal_code"])//รหัสไปรษณีย์
        {
            addressField6.text = component.name;
        }
    }
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    // TODO: handle the error.
    NSLog(@"Error: %@", [error description]);
}

// User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Turn the network activity indicator on and off again.
- (void)didRequestAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didUpdateAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (UITextField*)addbottomBorder:(UITextField*)textField withColor:(UIColor*)color
{
    textField.delegate = self;
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f,textField.frame.size.height*0.9, textField.frame.size.width, 1.0f);
    
    if (color == nil) {
        bottomBorder.backgroundColor = [UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1].CGColor;
    }
    else{
        bottomBorder.backgroundColor = color.CGColor;
        //UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, userField.frame.size.width, 20)];
        //textField.rightView = paddingView;
        //textField.rightViewMode = UITextFieldViewModeAlways;
    }
    
    [textField.layer addSublayer:bottomBorder];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    return textField;
}

- (IBAction)submitClick:(id)sender
{
    [self updateAddress];
    /*
    if ([addressField1.text isEqualToString:@""]||[addressField3.text isEqualToString:@""]||[addressField4.text isEqualToString:@""]||[addressField5.text isEqualToString:@""]||[addressField6.text isEqualToString:@""]) {
        [self alertTitle:@"ข้อมูลไม่ครบ" detail:@"กรุณากรอกข้อมูลให้ครบทุกช่อง"];
    }
    else{
        [self updateAddress];
    }
     */
}

- (void)updateAddress
{
    //NSString *encodeStr1 = [addressField1.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSData *nsdata = [addressField1.text
                      dataUsingEncoding:NSUTF8StringEncoding];
    NSString *encodeStr1 = [nsdata base64EncodedStringWithOptions:0];
    
    NSString *encodeStr3 = [addressField3.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *encodeStr4 = [addressField4.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *encodeStr5 = [addressField5.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *encodeStr6 = [addressField6.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    NSString *addressStr = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",encodeStr1,encodeStr3,encodeStr4,encodeStr5,encodeStr6];
    
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString* url;
    if ([mode isEqualToString:@"Local"]) {
        url = [NSString stringWithFormat:@"%@UpdateUserLocalAdd/%@/%@",delegate.serverURL,delegate.userID,addressStr];
    }
    
    if ([mode isEqualToString:@"Permanent"]) {
        url = [NSString stringWithFormat:@"%@UpdateUserPermanentAdd/%@/%@",delegate.serverURL,delegate.userID,addressStr];
    }
    
    //url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:url parameters:nil headers:nil constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"UpdateAddressJSON %@",responseObject);
         if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
             [SVProgressHUD showSuccessWithStatus:[responseObject objectForKey:@"message"]];
         }
         else{
             [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"message"]];
             //[self alertTitle:@"Fail" detail:[responseObject objectForKey:@"message"]];
         }
         [SVProgressHUD dismissWithDelay:3];
     }
          failure:^(NSURLSessionDataTask *task, NSError *error)
{
         NSLog(@"Error %@",error);
         [SVProgressHUD showErrorWithStatus:@"Please check your internet connection"];
     }];
}



- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertTitle:(NSString*)title detail:(NSString*)alertDetail
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:alertDetail preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
