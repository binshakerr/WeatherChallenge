//
//  AppColor.swift
//  WeatherChallenge
//
//  Created by Eslam Shaker on 05/02/2021.
//  Copyright © 2021 WeatherChallenge. All rights reserved.
//

import UIKit

enum AppColor {
    
    case red
    
    var name: String {
        switch self {
        case .red:
            return "PremiseRed"
        }
    }
}



extension UIColor {
    
    convenience init(appColor: AppColor){
        self.init(named: appColor.name)!
    }
}
