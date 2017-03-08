//
//  SecProduceInfoController.swift
//  ZhiAnTongCpy
//
//  Created by Ricky on 2017/2/17.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON
import UsefulPickerView

class SecProduceInfoController: BaseViewController {
    var customView1  = DetailSecViewCell()
    var customView2  = DetailSecViewCell()
    var customView3  = DetailSecViewCell()
    var customView4  = DetailSecViewCell()
    var customView5  = DetailSecViewCell()
    var customView6  = DetailSecViewCell()
    var customView7  = DetailSecViewCell()
    var customView8  = DetailSecViewCell()
    var customView9  = DetailSecViewCell()
    var customView10  = DetailSecViewCell()
    var customView11  = DetailSecViewCell()
    var customView12  = DetailSecViewCell()
    var customView13  = DetailSecViewCell()
    var scrollView: UIScrollView!
    var  secProductModel = SecProductModel()
    
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.whiteColor()
        InitPage()
        getCpyInfo()
        
    }
    
    func getCpyInfo(){
        var parameters = [String : AnyObject]()
        if AppTools.isExisNSUserDefaultsKey("companyId"){
            parameters["company.id"] = AppTools.loadNSUserDefaultsValue("companyId") as! String
        }
        
        NetworkTool.sharedTools.loadCpySafetyInfo(parameters) { (data, error) in
            if error == nil{
                self.secProductModel = data
                
                self.setData()
            }else{
                self.showHint("\(error)", duration: 2, yOffset: 0)
                if error == NOTICE_SECURITY_NAME {
                    self.toLogin()
                }
            }
            
            
        }
    }
    func InitPage(){
        scrollView = UIScrollView(frame: CGRectMake(0, 0, SCREEN_WIDTH, 550))
        scrollView!.pagingEnabled = true
        scrollView!.scrollEnabled = true
        scrollView!.showsHorizontalScrollIndicator = true
        scrollView!.showsVerticalScrollIndicator = false
        scrollView!.scrollsToTop = true
        scrollView!.contentSize = CGSizeMake(SCREEN_WIDTH, 550)
        

        
        customView1 = DetailSecViewCell(frame:CGRectMake(0, 0, SCREEN_WIDTH, 30))
        customView1.setLabelName("主要负责人")
        
        customView2 = DetailSecViewCell(frame:CGRectMake(0, 30, SCREEN_WIDTH, 30))
        customView2.setLabelName("电话")
        
        
        customView3 = DetailSecViewCell(frame:CGRectMake(0, 60, SCREEN_WIDTH, 30))
        customView3.setLabelName("危险化学品种数")
        
        
        customView4 = DetailSecViewCell(frame:CGRectMake(0, 90, SCREEN_WIDTH, 30))
        customView4.setLabelName("重大危险源等级")
        
        
        customView5 = DetailSecViewCell(frame:CGRectMake(0, 120, SCREEN_WIDTH, 30))
        customView5.setLabelName("备案日期")
        
        
        customView6 = DetailSecViewCell(frame:CGRectMake(0, 150, SCREEN_WIDTH, 30))
        customView6.setLabelName("预案备案")
        
        
        customView7 = DetailSecViewCell(frame:CGRectMake(0, 180, SCREEN_WIDTH, 30))
        customView7.setLabelName("演练情况")
        
        customView8 = DetailSecViewCell(frame:CGRectMake(0, 210, SCREEN_WIDTH, 30))
        customView8.setLabelName("应急物资")
        
        customView9 = DetailSecViewCell(frame:CGRectMake(0, 240, SCREEN_WIDTH, 30))
        customView9.setLabelName("应急救援队伍")
        
        customView10 = DetailSecViewCell(frame:CGRectMake(0, 270, SCREEN_WIDTH, 30))
        customView10.setLabelName("培训情况")
        
        customView11 = DetailSecViewCell(frame:CGRectMake(0, 300, SCREEN_WIDTH, 30))
        customView11.setLabelName("未治理重大隐患数")
        
        customView12 = DetailSecViewCell(frame:CGRectMake(0, 330, SCREEN_WIDTH, 30))
        customView12.setLabelName("挂牌督办隐患")
        
        customView13 = DetailSecViewCell(frame:CGRectMake(0, 360, SCREEN_WIDTH, 30))
        customView13.setLabelName("上年度安全生产投入")
        
        self.scrollView.addSubview(customView1)
        self.scrollView.addSubview(customView2)
        self.scrollView.addSubview(customView3)
        self.scrollView.addSubview(customView4)
        self.scrollView.addSubview(customView5)
        self.scrollView.addSubview(customView6)
        self.scrollView.addSubview(customView7)
        self.scrollView.addSubview(customView8)
        self.scrollView.addSubview(customView9)
        self.scrollView.addSubview(customView10)
        self.scrollView.addSubview(customView11)
        self.view.addSubview(scrollView)

        
    }
    
    func setData(){
        customView1.setRRightLabel(secProductModel.organization_principal)
        customView2.setRRightLabel(secProductModel.organization_tel)
        customView3.setRRightLabel(String(secProductModel.hzyj_chemistry_num))
        customView4.setRRightLabel(secProductModel.hzyj_enum_name)
        customView5.setRRightLabel(secProductModel.hzyj_castTime)
        customView6.setRRightLabel(isHave(secProductModel.hzyj_pre_plan))
        customView7.setRRightLabel(isHave(secProductModel.hzyj_drill))
        customView8.setRRightLabel(isHave(secProductModel.hzyj_material))
        customView9.setRRightLabel(isHave(secProductModel.hzyj_team))
        customView10.setRRightLabel(String(secProductModel.hzyj_train))
        customView11.setRRightLabel(String(secProductModel.yhpc_danger_num))
        customView12.setRRightLabel(String(secProductModel.yhpc_rollcall_company_num))
        customView13.setRRightLabel(String(secProductModel.yhpc_money))
        
    }
    
    func isHave(num:Int)->String{
        if num == 0{
        return "无"
        }else{
        return "有"
        }
    }
    func submit(){
        
    }
    
}
