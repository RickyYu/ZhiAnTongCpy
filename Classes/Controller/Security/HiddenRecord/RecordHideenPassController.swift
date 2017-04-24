//
//  RecordHiddenController.swift
//  ZhiAnTongGov
//
//  Created by Ricky on 2017/1/4.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//

import UIKit

class RecordHideenPassController:BaseViewController {
    
    var converyModels  = CheckListVo()
    var titleName: String!
    //一般隐患所需
    var  repairId:String!
    //重大隐患所需
    var isGorover:String!
    //来源 从哪个页面跳转来
    var matterHistoryId:String!
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.whiteColor()
        setNavagation(titleName)
        initView()
        if matterHistoryId != nil{
          getCpyInfo()
        }
    }
    
    func initView(){
        self.hidesBottomBarWhenPushed = true
        let imageView = UIImageView(frame: CGRectMake(0, 64, SCREEN_WIDTH, 225))
        imageView.image = UIImage(named: "banner_hidden")
        self.view.addSubview(imageView)
        
        let buttonNormal = UIButton(frame:CGRectMake(10, 300, SCREEN_WIDTH/2-20, 100))
        buttonNormal.setBackgroundImage(UIImage(named: "bg_general_hidden"), forState: .Normal)
        buttonNormal.setTitleColor(UIColor.greenColor(), forState: .Highlighted) //触摸状态下文字的颜色
        buttonNormal.addTarget(self, action: #selector(self.showNormal), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        let buttonMajor = UIButton(frame:CGRectMake(SCREEN_WIDTH/2+7, 300, SCREEN_WIDTH/2-20, 100))
        buttonMajor.setBackgroundImage(UIImage(named: "bg_major_hidden"), forState: .Normal)
        buttonMajor.setTitleColor(UIColor.greenColor(), forState: .Highlighted) //触摸状态下文字的颜色
        buttonMajor.addTarget(self, action: #selector(self.showMajor), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(buttonNormal)
        self.view.addSubview(buttonMajor)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
        self.tabBarController?.hidesBottomBarWhenPushed = true
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    func getCpyInfo(){
        let parameters = [String : AnyObject]()
        NetworkTool.sharedTools.loadCompanyInfo(parameters) { (data, error) in
            if error == nil{
                self.setData(data)
            }else{
                self.showHint("\(error)", duration: 2, yOffset: 0)
                if error == NOTICE_SECURITY_NAME {
                    self.toLogin()
                }
            }
        }
    }
    func setData(cpyInfoModal:CompanyInfoModel){
        self.converyModels.companyId = String(cpyInfoModal.id)
        self.converyModels.companyname = cpyInfoModal.companyName
        self.converyModels.companyadress = cpyInfoModal.address
        self.converyModels.fdDelegate = cpyInfoModal.fdDelegate
        self.converyModels.businessRegNumber  = cpyInfoModal.businessRegNumber
    }
    
    override func viewWillLayoutSubviews() {
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    func showNormal(){
        if titleName == "隐患录入"{
            let controller = RecordHiddenNormalController()
             if matterHistoryId != nil{
                controller.matterHistoryId = self.matterHistoryId
            }
            controller.converyModels = converyModels
            self.navigationController?.pushViewController(controller, animated: true)
        }else{
            let controller = GeneralHiddenListController()
            controller.companyId = converyModels.companyId
            controller.repairId = self.repairId
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func showMajor(){
        if titleName == "隐患录入"{
            let controller = RecordHiddenMajorController()
             if matterHistoryId != nil{
                controller.matterHistoryId = self.matterHistoryId
            }
            controller.converyModels = converyModels
            self.navigationController?.pushViewController(controller, animated: true)
        }else{
            let controller = MajorHiddenListController()
            controller.companyId = converyModels.companyId
            controller.isGorover = self.isGorover
            self.navigationController?.pushViewController(controller, animated: true)
            
        }
    }
}
