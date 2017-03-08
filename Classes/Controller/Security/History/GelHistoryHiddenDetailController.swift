//
//  GelHistoryHiddenDetailController.swift
//  ZhiAnTongCpy
//
//  Created by Ricky on 2017/2/16.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON
import UsefulPickerView

class GelHistoryHiddenDetailController: PhotoViewController {
    var customView1  = DetailCellView()
    var customView2  = DetailCellView()
    var customView3  = DetailCellView()
    var customView4  = DetailCellView()
    var customView5  = DetailCellView()
    var customView6  = DetailCellView()
    var customView7  = DetailCellView()
    var customView8  = DetailCellView()
    var customView9  = DetailCellView()
    var submitBtn = UIButton()
    var scrollView: UIScrollView!
    var generalCheckInfoModel:GeneralCheckInfoModel!
    
    override func viewDidLoad() {
      setNavagation("一般隐患整改历史记录")
          InitPage()
          getData()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.resignEdit(_:))))
        
    }
    
    override func resignEdit(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            customView1.textField.resignFirstResponder()
            customView2.textField.resignFirstResponder()
            customView3.textField.resignFirstResponder()
            customView4.textField.resignFirstResponder()
            customView5.textField.resignFirstResponder()
            customView6.textField.resignFirstResponder()
            customView7.textView.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
    
    func setData(){
        let isSelected : Bool = generalCheckInfoModel.repaired
        if isSelected {
          customView1.rightCheckBtn.selected = true
        }else{
          customView1.rightCheckBtn.selected = false
        }
         customView2.setRTextField(generalCheckInfoModel.linkMan)
         customView2.textField.enabled = false
        customView3.setRTextField(generalCheckInfoModel.linkTel)
        customView3.textField.enabled = false
        customView4.setRTextField(generalCheckInfoModel.descriptions)
        customView4.textField.enabled = false
        customView5.setRTextField(getTroubleType(String(generalCheckInfoModel.type)))
        customView5.textField.enabled = false
        customView6.setRTextField(generalCheckInfoModel.rectificationPlanTime)
        customView6.textField.enabled = false
        customView7.setRTextView(generalCheckInfoModel.remarks)
        customView7.textView.editable = false

    }
    
    func InitPage(){
        scrollView = UIScrollView(frame: CGRectMake(0, 0, SCREEN_WIDTH, 550))
        scrollView!.pagingEnabled = true
        scrollView!.scrollEnabled = true
        scrollView!.showsHorizontalScrollIndicator = true
        scrollView!.showsVerticalScrollIndicator = false
        scrollView!.scrollsToTop = true
        scrollView!.contentSize = CGSizeMake(SCREEN_WIDTH, 550)
        
        submitBtn.setTitle("保存", forState:.Normal)
        submitBtn.backgroundColor = YMGlobalDeapBlueColor()
        submitBtn.setTitleColor(UIColor.greenColor(), forState: .Highlighted) //触摸状态下文字的颜色
        submitBtn.addTarget(self, action: #selector(self.submit), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        customView1 = DetailCellView(frame:CGRectMake(0, 0, SCREEN_WIDTH, 45))
        customView1.setLabelName("企业确认整改：")
        customView1.setLabelMax()
        customView1.setRCheckBtn()
        customView1.rightCheckBtn.addTarget(self, action:#selector(majortapped1(_:)), forControlEvents:.TouchUpInside)
        
        customView2 = DetailCellView(frame:CGRectMake(0, 45, SCREEN_WIDTH, 45))
        customView2.setLabelName("联系人：")
        
        customView3 = DetailCellView(frame:CGRectMake(0, 90, SCREEN_WIDTH, 45))
        customView3.setLabelName("联系电话：")
        
        
        customView4 = DetailCellView(frame:CGRectMake(0, 135, SCREEN_WIDTH, 45))
        customView4.setLabelName("隐患描述：")
        
        
        customView5 = DetailCellView(frame:CGRectMake(0, 180, SCREEN_WIDTH, 45))
        customView5.setLabelName("隐患类别:")
        
        
        customView6 = DetailCellView(frame:CGRectMake(0, 225, SCREEN_WIDTH, 45))
        customView6.setLabelName("计划整改时间：")
        
        
        customView7 = DetailCellView(frame:CGRectMake(0, 270, SCREEN_WIDTH, 135))
        customView7.setLabelName("备注：")
        customView7.setTextViewShow()

 
        
        
        self.scrollView.addSubview(customView1)
        self.scrollView.addSubview(customView2)
        self.scrollView.addSubview(customView3)
        self.scrollView.addSubview(customView4)
        self.scrollView.addSubview(customView5)
        self.scrollView.addSubview(customView6)
        self.scrollView.addSubview(customView7)
   
        
        self.view.addSubview(submitBtn)
        self.view.addSubview(scrollView)
        submitBtn.snp_makeConstraints { make in
            make.bottom.equalTo(self.view.snp_bottom).offset(-15)
            make.left.equalTo(self.view.snp_left).offset(50)
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH-100, 35))
        }
        
        scrollView.snp_makeConstraints { make in
            make.top.equalTo(self.view.snp_top).offset(64)
            make.left.equalTo(self.view.snp_left)
            make.bottom.equalTo(submitBtn.snp_top).offset(-5)
            make.right.equalTo(self.view.snp_right)
        }
        
    }
    
    func getData(){
        var parameters = [String : AnyObject]()
        parameters["nomalDanger.id"] = generalCheckInfoModel.id
        NetworkTool.sharedTools.loadCpyNormalDanger(parameters) { (generalCheckInfoModel, error) in
            if error == nil{
                self.generalCheckInfoModel = generalCheckInfoModel
                self.setData()
            }else{
                self.showHint("\(error!)", duration: 2, yOffset: 0)
                if error == NOTICE_SECURITY_NAME {
                    self.toLogin()
                }            }
            
        }
        
    }
    
    //是否需要政府协调
    var majoris1 = false
    func majortapped1(button:UIButton){
        button.selected = !button.selected
        if button.selected{
            majoris1 = true
            print("tapped1+\(button.selected)")
        }else{
            majoris1 = false
            print("tapped1+\(button.selected)")
            
        }
        
    }
    
    func submit(){
        var parameters = [String : AnyObject]()
        parameters["deletePhoto"] = "0"
        parameters["nomalDanger.companyPassId"] = String(generalCheckInfoModel.companyPassId)
        parameters["nomalDanger.id"] = String(generalCheckInfoModel.id)
        parameters["nomalDanger.linkMan"] = generalCheckInfoModel.linkMan
        parameters["nomalDanger.linkTel"] = generalCheckInfoModel.linkTel
        parameters["nomalDanger.linkMobile"] = generalCheckInfoModel.linkMobile
        parameters["nomalDanger.danger"] = "1"
        parameters["nomalDanger.type"] = String(generalCheckInfoModel.type)
        parameters["nomalDanger.description"] = generalCheckInfoModel.descriptions
        parameters["nomalDanger.repaired"] = String(majoris1)
        parameters["nomalDanger.completedDate"] = generalCheckInfoModel.completedDate
        parameters["nomalDanger.rectificationPlanTime"] = generalCheckInfoModel.rectificationPlanTime
        parameters["nomalDanger.remarks"] = generalCheckInfoModel.remarks
        parameters["nomalDanger.check"] = "0"
        
        NetworkTool.sharedTools.updateNomalDanger(parameters,imageArrays: getListImage()) { (data, error) in
            if error == nil{
                self.showHint("保存成功", duration: 1, yOffset: 0)
                let viewController = self.navigationController?.viewControllers[0] as! SecurityCheckController
                // viewController.isRefresh = true
                self.navigationController?.popToViewController(viewController , animated: true)
                
                
            }else{
                self.showHint("\(error!)", duration: 2, yOffset: 0)
                if error == NOTICE_SECURITY_NAME {
                    self.toLogin()
                }
            }
        }
        
        
    }

    
}
