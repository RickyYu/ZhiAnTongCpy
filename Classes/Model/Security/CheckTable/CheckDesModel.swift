//
//  CheckDesModel.swift
//  ZhiAnTongCpy
//
//  Created by Ricky on 2017/2/10.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//

import UIKit
import SwiftyJSON

class CheckDesModel:BaseModel{
    
    var id :Int!
    var matterName :String!
    var matterRemark :String!
    var deleted:Bool!
    init(checkDes:String,remark:String) {
        self.matterName  = checkDes
        self.matterRemark  = remark
    }
    
    
    init(dict: [String: AnyObject]) {
        super.init()
        self.id = dict["id"] as? Int
        self.matterName = dict["matterName"] as? String
        let mr = dict["matterRemark"] as? String!
        if (mr != nil) {
          self.matterRemark = dict["matterRemark"] as? String!
        }else{
          self.matterRemark = ""
        }
        self.deleted = false
    }
    
    func getParams1() -> Dictionary<String, AnyObject> {
        var params = Dictionary<String, AnyObject>()
        if self.id == nil{
         id = -1
        }
        params = [
            "deleted":self.deleted,
            "id":self.id,
            "matterName":self.matterName,
            "matterRemark":self.matterRemark,
            "matterState":false
        ]
        return  params
    }
}