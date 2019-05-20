//
//  GRHConfig.h
//  HeraldApp
//
//  Created by Wolf-Tungsten on 2019/2/12.
//  Copyright © 2019 Herald Studio. All rights reserved.
//

#ifndef GRHConfig_h
#define GRHConfig_h
///------------
/// AppDelegate
///------------

#define GRHSharedAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
///-----------
/// SSKeychain
///-----------

#define GRH_SERVICE_NAME @"cn.myseu.HeraldApp"
#define GRH_TOKEN @"token"

///-----------
/// Hybrid
///-----------

#define GRH_HYBRID_BASEURL @"https://hybrid-ios.myseu.cn/"
#define GRH_HYBRID_DEBUG NO
#define GRH_HYBRID_DEBUG_URL @"http://192.168.1.101:8080/"

///-----------
/// UserDefualts
///-----------

#define GRH_USERINFO_DEFUALTS @"herald-userInfo"
#define GRH_HYBRID_PACKAGE_INFO_DEFAULTS @"hybridService-fileList"
#endif /* GRHConfig_h */
