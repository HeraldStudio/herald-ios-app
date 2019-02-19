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

#define GRH_HYBRID_BASEURL @"http://192.168.1.102:8080/"
#define GRH_HYBRID_DEBUG YES

///-----------
/// UserDefualts
///-----------

#define GRH_USERINFO_DEFUALTS @"herald-userInfo"
#define GRH_HYBRID_PACKAGE_INFO_DEFAULTS @"hybridService-fileList"
#endif /* GRHConfig_h */
