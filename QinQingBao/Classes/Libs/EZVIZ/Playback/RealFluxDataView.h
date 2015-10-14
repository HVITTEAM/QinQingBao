//
//  RealFluxData.h
//  VideoGo
//
//  Created by yudan on 14-6-19.
//
//

#import <UIKit/UIKit.h>

@interface RealFluxDataView : UIView


/**
 *  实时数据视图刷新
 *
 *  @param fData 实时数据
 */
- (void)updateData:(float)fData;

@end
