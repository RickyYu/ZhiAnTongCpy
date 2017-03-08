//
//  Info.swift
//  ZhiAnTongGov
//
//  Created by Ricky on 2016/11/30.
//  Copyright © 2016年 safetysafetys. All rights reserved.
//

import UIKit
import SwiftyJSON
//月信息vo类
class McountModel:BaseModel{
    
    var dangerNum:Int!
    var dateMonth:String!
    var repairedDanger:Int!

    
    override init() {
        super.init()
    }
    
    init(dict: [String: AnyObject]) {
        super.init()
        
        self.dangerNum = dict["dangerNum"] as? Int
        self.dateMonth = dict["dateMonth"] as? String
        self.repairedDanger = dict["repairedDanger"] as? Int

        
    }
}











