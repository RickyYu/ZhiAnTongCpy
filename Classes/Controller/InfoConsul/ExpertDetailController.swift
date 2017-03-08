//
//  ExpertDetailController.swift
//  ZhiAnTongCpy
//
//  Created by Ricky on 2017/2/20.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//

import UIKit

class ExpertDetailController: BaseViewController {
    var customView1 = DetailCellView()
    var customView2 = DetailCellView()
    var customView3 = DetailCellView()
    var customView4 = DetailCellView()
    var customView5 = DetailCellView()
    var customView6 = DetailCellView()
    var customView7 = DetailCellView()
    var expertInfoModel: ExpertInfoModel!
    var sex:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavagation("专家库详情")
        initPage()
    }
    
    func initPage(){
        customView1.setLabelName("专家名称：")
        customView1.setRCenterLabel(expertInfoModel.name)
        
        customView2.setLabelName("职称：")
        customView2.setRCenterLabel(expertInfoModel.jobTitle)
        
        customView3.setLabelName("专家类别：")
        customView3.setRCenterLabel(getExpertTypeCode(expertInfoModel.category))
        
        customView4.setLabelName("性别：")
        if expertInfoModel.sex == 1{
        sex = "男"
        }else{
        sex = "女"
        }
        customView4.setRCenterLabel(sex)
        
        customView5.setLabelName("专业特长：")
        customView5.setRCenterLabel(expertInfoModel.speciality)
        
        customView6.setLabelName("移动电话：")
        customView6.setRCenterLabel(expertInfoModel.mobile)
        
        customView7.setLabelName("工作单位：")
        customView7.setRCenterLabel(expertInfoModel.unit)
        
        self.view.addSubview(customView1)
        self.view.addSubview(customView2)
        self.view.addSubview(customView3)
        self.view.addSubview(customView4)
        self.view.addSubview(customView5)
        self.view.addSubview(customView6)
        self.view.addSubview(customView7)
        
        
        customView1.snp_makeConstraints { make in
            make.top.equalTo(self.view.snp_top).offset(64)
            make.left.equalTo(self.view.snp_left)
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH-30, 45))
        }
        
        customView2.snp_makeConstraints { make in
            make.top.equalTo(self.customView1.snp_bottom)
            make.left.equalTo(self.view.snp_left)
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH-30, 45))
        }
        
        customView3.snp_makeConstraints { make in
            make.top.equalTo(self.customView2.snp_bottom)
            make.left.equalTo(self.view.snp_left)
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH-30, 45))
        }
        
        customView4.snp_makeConstraints { make in
            make.top.equalTo(self.customView3.snp_bottom)
            make.left.equalTo(self.view.snp_left)
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH-30, 45))
        }
        
        customView5.snp_makeConstraints { make in
            make.top.equalTo(self.customView4.snp_bottom)
            make.left.equalTo(self.view.snp_left)
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH-30, 45))
        }
        
        customView6.snp_makeConstraints { make in
            make.top.equalTo(self.customView5.snp_bottom)
            make.left.equalTo(self.view.snp_left)
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH-30, 45))
        }
        
        customView7.snp_makeConstraints { make in
            make.top.equalTo(self.customView6.snp_bottom)
            make.left.equalTo(self.view.snp_left)
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH-30, 45))
        }
        


    
    }
}
