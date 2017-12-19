//
//  ViewController.m
//  Mnemo
//
//  Created by Usman Rashid on 12/15/17.
//  Copyright © 2017 Usman Rashid. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ViewController.h"
#import "NYMnemonic.h"

//-----------------------------------------------------------------------------
@interface ViewController ()
//-----------------------------------------------------------------------------
@property (strong, nonatomic) NSString* strMnemonic;
@property (strong, nonatomic) NSString* strSeedFromMnemonic;

@property (weak, nonatomic) IBOutlet UIImageView *imgQRCode;
@property (weak, nonatomic) IBOutlet UILabel *lblMnemonic;
@property (weak, nonatomic) IBOutlet UILabel *lblSeed;
@end

//-----------------------------------------------------------------------------
@implementation ViewController
//-----------------------------------------------------------------------------


//-----------------------------------------------------------------------------
- (IBAction)getMnemonic:(UIButton *)sender
//-----------------------------------------------------------------------------
{
    self.strMnemonic = [NYMnemonic generateMnemonicString:@128 language:@"english"];
    [self.lblMnemonic setText:@""];
    [self.lblMnemonic setText:self.strMnemonic];
    
    [self.lblSeed setText:@""];
    [self.imgQRCode setImage:nil];
}

//-----------------------------------------------------------------------------
- (IBAction)genSeed:(UIButton *)sender
//-----------------------------------------------------------------------------
{
    if ([self.strMnemonic length] == 0)
        return;
    
    self.strSeedFromMnemonic = [NYMnemonic deterministicSeedStringFromMnemonicString:self.strMnemonic
                                                                          passphrase:@""
                                                                            language:@"english"];
    [self.lblSeed setText:self.strSeedFromMnemonic];
    [self.view bringSubviewToFront:self.lblSeed];
}

//-----------------------------------------------------------------------------
- (IBAction)genQRCode:(UIButton *)sender
//-----------------------------------------------------------------------------
{
    NSData* data = [self.strMnemonic dataUsingEncoding:NSISOLatin1StringEncoding];
    CIFilter* filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    CIImage *image = filter.outputImage;
    
    CGRect imageSize = CGRectIntegral(image.extent);
    CGSize displaySize = CGSizeMake(170.0, 170.0);
    CIImage* resizedImage = [image imageByApplyingTransform:
                             CGAffineTransformMakeScale(displaySize.width/CGRectGetWidth(imageSize),
                                                        displaySize.height/CGRectGetHeight(imageSize))];
    
    UIImage* qrCodeImage = [UIImage imageWithCIImage:resizedImage];
    self.imgQRCode.image = qrCodeImage;
    [self.view bringSubviewToFront:self.imgQRCode];
}

//-----------------------------------------------------------------------------
- (void)viewDidLoad
//-----------------------------------------------------------------------------
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


//-----------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
//-----------------------------------------------------------------------------
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
