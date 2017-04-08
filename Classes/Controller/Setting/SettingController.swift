//
//  SettingController.swift
//  ZhiAnTongGov
//
//  Created by Ricky on 2016/11/28.
//  Copyright © 2016年 safetysafetys. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class SettingController: BaseViewController {

    @IBOutlet weak var userNameField: UILabel!
    @IBOutlet weak var userCompanyField: UILabel!
    
    @IBOutlet weak var modify: UIButton!
    @IBOutlet weak var tel: UIButton!
    var cpyName:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        modify.backgroundColor = UIColor.orangeColor()
        tel.backgroundColor = UIColor.orangeColor()
        let user = AppTools.loadNSUserDefaultsClassValue("user") as! User
        
        userNameField.text = user.factName as String
        cpyName = user.userCompany as String
        userCompanyField.text = cpyName
        
    }
    
    
    @IBAction func modifyPwd(sender: AnyObject) {
//        self.alert("修改密码")
    }
    
    @IBAction func showCpyName(sender: AnyObject) {
        self.alert(cpyName)
    }

    @IBAction func callPhone(sender: AnyObject) {
        let url = NSURL(string: "tel://0574-87364008")
        self.alert("拨号") {
            UIApplication.sharedApplication().openURL(url!)
        }
    }
}

