//
//  ViewController.h
//  NVDSPExample
//
//  Created by Bart Olsthoorn on 25/04/2013.

// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//

#import <UIKit/UIKit.h>
#import "Novocaine.h"
#import "RingBuffer.h"
#import "AudioFileReader.h"
#import "AudioFileWriter.h"

#import "NVDSP.h"
#import "NVBandpassFilter.h"
#import "NVBandpassQPeakGainFilter.h"
#import "NVHighpassFilter.h"
#import "NVHighShelvingFilter.h"
#import "NVLowpassFilter.h"
#import "NVLowShelvingFilter.h"
#import "NVNotchFilter.h"
#import "NVPeakingEQFilter.h"

@interface ViewController : UIViewController
{
    RingBuffer *ringBuffer;
    Novocaine *audioManager;
    AudioFileReader *fileReader;
    AudioFileWriter *fileWriter;
    
    NVBandpassFilter *bpf;
    NVBandpassQPeakGainFilter *bpqf;
    NVHighpassFilter *hpf;
    NVHighShelvingFilter *hsf;
    NVLowpassFilter *lpf;
    NVLowShelvingFilter *lsf;
    NVNotchFilter *nf;
    NVPeakingEQFilter *peqf;
}

- (void)playSound;

@property BOOL bpf_on;
@property BOOL bpqf_on;
@property BOOL hpf_on;
@property BOOL hsf_on;
@property BOOL lpf_on;
@property BOOL lsf_on;
@property BOOL nf_on;
@property BOOL peqf_on;
@property BOOL ps_on;

@property float bpf_centerFrequency;
@property float bpf_Q;
@property float bpqf_centerFrequency;
@property float bpqf_Q;
@property float hpf_cornerFrequency;
@property float hpf_Q;
@property float hsf_centerFrequency;
@property float hsf_Q;
@property float hsf_G;
@property float lpf_cornerFrequency;
@property float lpf_Q;
@property float lsf_centerFrequency;
@property float lsf_Q;
@property float lsf_G;
@property float nf_centerFrequency;
@property float nf_Q;
@property float peqf_centerFrequency;
@property float peqf_Q;
@property float peqf_G;
@property float ps_semitones;

@property (retain, nonatomic) IBOutlet UILabel *bpf_cfLabel;
@property (retain, nonatomic) IBOutlet UILabel *bpf_qLabel;
@property (retain, nonatomic) IBOutlet UILabel *bpqf_cfLabel;
@property (retain, nonatomic) IBOutlet UILabel *bpqf_qLabel;
@property (retain, nonatomic) IBOutlet UILabel *hpf_cfLabel;
@property (retain, nonatomic) IBOutlet UILabel *hpf_qLabel;
@property (retain, nonatomic) IBOutlet UILabel *hsf_cfLabel;
@property (retain, nonatomic) IBOutlet UILabel *hsf_qLabel;
@property (retain, nonatomic) IBOutlet UILabel *hsf_gLabel;
@property (retain, nonatomic) IBOutlet UILabel *lpf_cfLabel;
@property (retain, nonatomic) IBOutlet UILabel *lpf_qLabel;
@property (retain, nonatomic) IBOutlet UILabel *lsf_cfLabel;
@property (retain, nonatomic) IBOutlet UILabel *lsf_qLabel;
@property (retain, nonatomic) IBOutlet UILabel *lsf_gLabel;
@property (retain, nonatomic) IBOutlet UILabel *nf_cfLabel;
@property (retain, nonatomic) IBOutlet UILabel *nf_qLabel;
@property (retain, nonatomic) IBOutlet UILabel *peqf_cfLabel;
@property (retain, nonatomic) IBOutlet UILabel *peqf_qLabel;
@property (retain, nonatomic) IBOutlet UILabel *peqf_gLabel;
@property (retain, nonatomic) IBOutlet UILabel *ps_stLabel;

- (IBAction)bpf_switchChanged:(id)sender;
- (IBAction)bpf_cfChanged:(id)sender;
- (IBAction)bpf_qChanged:(id)sender;

- (IBAction)bpqf_switchChanged:(id)sender;
- (IBAction)bpqf_cfChanged:(id)sender;
- (IBAction)bpqf_qChanged:(id)sender;

- (IBAction)hpf_switchChanged:(id)sender;
- (IBAction)hpf_cfChanged:(id)sender;
- (IBAction)hpf_qChanged:(id)sender;

- (IBAction)hsf_switchChanged:(id)sender;
- (IBAction)hsf_cfChanged:(id)sender;
- (IBAction)hsf_qChanged:(id)sender;
- (IBAction)hsf_gChanged:(id)sender;

- (IBAction)lpf_switchChanged:(id)sender;
- (IBAction)lpf_cfChanged:(id)sender;
- (IBAction)lpf_qChanged:(id)sender;

- (IBAction)lsf_switchChanged:(id)sender;
- (IBAction)lsf_cfChanged:(id)sender;
- (IBAction)lsf_qChanged:(id)sender;
- (IBAction)lsf_gChanged:(id)sender;

- (IBAction)nf_switchChanged:(id)sender;
- (IBAction)nf_cfChanged:(id)sender;
- (IBAction)nf_qChanged:(id)sender;

- (IBAction)peqf_switchChanged:(id)sender;
- (IBAction)peqf_cfChanged:(id)sender;
- (IBAction)peqf_qChanged:(id)sender;
- (IBAction)peqf_gChanged:(id)sender;

- (IBAction)ps_switchChanged:(id)sender;
- (IBAction)ps_stChanged:(id)sender;

@end
