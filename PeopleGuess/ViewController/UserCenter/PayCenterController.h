//
//  PayCenterController.h
//  PeopleGuess
//
//  Created by mac on 17/2/13.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
@interface PayCenterController : UIViewController<SKProductsRequestDelegate,SKPaymentTransactionObserver,UITableViewDataSource,UITableViewDelegate>

@end
