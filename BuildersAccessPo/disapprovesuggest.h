//
//  disapprovesuggest.h
//  BuildersAccess
//
//  Created by amy zhao on 13-5-15.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "fathercontroller.h"


@interface disapprovesuggest : fathercontroller


//xUpdQASaveAndFail
//xUpdateUserChangeOrder
//xUpdateContract
//xUpdQANotReady
//xUpdQASaveAndFinish
//xUpdQASaveAndFail
//xCompleteSchedule
//xSendEmail
//xSendMessage（oldemail）
//xApproveBustOut
//xDisapproveBustOut
//xUpdateCalendarDisApprove
//xSubmitSuggestPrice
//xApproveSuggest
//xDisApproveSuggest
//xUpdQAResubmit
//xAprroveRequestedPOWithEmail
//xDisAprroveRequestedPOWithEmail
//xVoidRequestedPOWithEmail
//xHoldRequestedPOWithEmail
//xCompleteSchedule

@property (nonatomic, retain) NSString *idnumber;
@property (nonatomic, retain) NSString *xidproject;
@property (nonatomic, retain) NSString *xidcia;
@property (nonatomic, retain) NSString *xemail;
@property (nonatomic, retain) NSString *xsqft1;
@property (nonatomic, retain) NSString *xsuggestprice1;
@end
