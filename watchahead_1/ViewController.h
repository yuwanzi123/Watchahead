//
//  ViewController.h
//  watchahead_1
//
//  Created by Ziyu.Wang on 05/03/2016.
//  Copyright © 2016 Ziyu.Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController<UINavigationBarDelegate, UIImagePickerControllerDelegate, AVAudioPlayerDelegate>{

    IBOutlet UIImageView *PhotoView;
    
    UIImagePickerController *picker;
    UIImage *image;
    
    //add picture to code to get RGB values of the picture
    NSMutableArray * colours;
    CGImageRef imageRef;
    //unsigned char = rawData;
}

- (IBAction)takephoto:(id)sender;

@end

