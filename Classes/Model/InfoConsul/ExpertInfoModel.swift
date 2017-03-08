//
//  ExpertInfoModel.swift
//  ZhiAnTongCpy
//
//  Created by Ricky on 2017/2/20.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//

import UIKit
import SwiftyJSON
//检查记录基本信息vo类
class ExpertInfoModel:BaseModel{
    
    var category:String!
    var mobile:String!
    var speciality:String!
    var id:Int!
    var unit:String!
    var jobTitle:String!
    var sex:Int!
    var name:String!
    var new:Bool!
    
    override init() {
        super.init()
    }
    init(dict: [String: AnyObject]) {
        self.category = dict["category"] as? String
        self.mobile = dict["mobile"] as? String
        
        self.speciality = dict["speciality"] as? String
        self.id = dict["id"] as? Int
        
        self.unit = dict["unit"] as? String
        self.jobTitle = dict["jobTitle"] as? String

        self.sex = dict["sex"] as? Int
        self.name = dict["name"] as? String
        self.new = dict["new"] as? Bool
        
    }
}

