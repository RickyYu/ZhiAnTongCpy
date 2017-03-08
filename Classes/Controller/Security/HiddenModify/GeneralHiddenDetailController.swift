//
//  HiddenDetailController.swift
//  ZhiAnTongCpy
//
//  Created by Ricky on 2017/2/9.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//


import UIKit
import SnapKit
import SwiftyJSON
import UsefulPickerView

class GeneralHiddenDetailController: PhotoViewController {
  
    var submitBtn = UIButton()
    var scrollView: UIScrollView!
    var generalCheckInfoModel:GeneralCheckInfoModel!
    //历史记录入口进入则为true
    var isRead:Bool = false
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationItem.title = "一般隐患整改"
        if isRead{
        self.navigationItem.title = "一般隐患历史记录"
        }
      
        InitPage()
        //历史记录开始获取
        getData()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.resignEdit(_:))))
        
    }
    
    override func resignEdit(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            customView1.textField.resignFirstResponder()
            customView2.textField.resignFirstResponder()
            customView3.textField.resignFirstResponder()
            customView4.textField.resignFirstResponder()
            customView8.textView.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
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
                }
            }

        }
    
    }


    var customView1  = DetailCellView()
    var customView2  = DetailCellView()
    var customView3  = DetailCellView()
    var customView4  = DetailCellView()
    var customView5  = DetailCellView()
    var customView6  = DetailCellView()
    var customView7  = DetailCellView()
    var customView8  = DetailCellView()
    var customView9  = DetailCellView()
    
   let singleDatanormal = ["人", "物", "管理"]
    
    func setData(){
        customView1.setRTextField(generalCheckInfoModel.linkMan)
        customView2.setRTextField(generalCheckInfoModel.linkTel)
        customView3.setRTextField(generalCheckInfoModel.linkMobile)
        customView4.setRTextField(generalCheckInfoModel.descriptions)
        customView8.setRTextView(generalCheckInfoModel.remarks)
        if isRead {
            customView5.setRTextField(String(generalCheckInfoModel.type))
            customView6.setRTextField(generalCheckInfoModel.rectificationPlanTime)
            customView7.setLabelName("完成时间：")
            customView7.setRTextField(generalCheckInfoModel.completedDate)
            submitBtn.hidden = true
            customView9.hidden = true
        }
    }
    
    
    
    func InitPage(){
        scrollView = UIScrollView(frame: CGRectMake(0, 0, SCREEN_WIDTH, 650))
        scrollView!.pagingEnabled = true
        scrollView!.scrollEnabled = true
        scrollView!.showsHorizontalScrollIndicator = true
        scrollView!.showsVerticalScrollIndicator = false
        scrollView!.scrollsToTop = true
        scrollView!.contentSize = CGSizeMake(SCREEN_WIDTH, 650)
        
        submitBtn.setTitle("保存", forState:.Normal)
        submitBtn.backgroundColor = YMGlobalDeapBlueColor()
        submitBtn.setTitleColor(UIColor.greenColor(), forState: .Highlighted) //触摸状态下文字的颜色
        submitBtn.addTarget(self, action: #selector(self.submit), forControlEvents: UIControlEvents.TouchUpInside)
        
        customView1 = DetailCellView(frame:CGRectMake(0, 0, SCREEN_WIDTH, 45))
        customView1.setLabelName("联系人：")
        
        customView2 = DetailCellView(frame:CGRectMake(0, 45, SCREEN_WIDTH, 45))
        customView2.setLabelName("联系电话：")
        
        
        customView3 = DetailCellView(frame:CGRectMake(0, 90, SCREEN_WIDTH, 45))
        customView3.setLabelName("手机：")
        
        
        customView4 = DetailCellView(frame:CGRectMake(0, 135, SCREEN_WIDTH, 45))
        customView4.setLabelName("隐患描述:")
        
        
         customView5 = DetailCellView(frame:CGRectMake(0, 180, SCREEN_WIDTH, 45))
        customView5.setLabelName("隐患类别：")
       

        customView6 = DetailCellView(frame:CGRectMake(0, 225, SCREEN_WIDTH, 45))
        customView6.setLabelName("计划整改时间：")
       
        
        customView7 = DetailCellView(frame:CGRectMake(0, 270, SCREEN_WIDTH, 45))
        customView7.setLabelName("整改时间：")
        
        if !isRead {
            customView5.setRRightLabel("物")
            customView5.addOnClickListener(self, action: #selector(self.normalHiddenType))
            getSystemTime { (time) in
                self.customView6.setRRightLabel(time)
            }
            customView6.setTimeImg()
            customView6.addOnClickListener(self, action: #selector(self.ChoicePlanTimes))
            customView7.setRRightLabel("")
            customView7.setTimeImg()
            customView7.addOnClickListener(self, action: #selector(self.ChoiceModifyTimes))
        }
        
        customView8 = DetailCellView(frame:CGRectMake(0, 315, SCREEN_WIDTH, 145))
        customView8.setLabelName("备注：")
        customView8.setTextViewShow()
        
        customView9 = DetailCellView(frame:CGRectMake(0, 460, SCREEN_WIDTH, 45))
        customView9.setLabelName("现场图片：")
        customView9.setRRightLabel("")
        customView9.addOnClickListener(self, action: #selector(self.ChoiceImage))
        
        InitPhoto()
        
        
        self.scrollView.addSubview(customView1)
        self.scrollView.addSubview(customView2)
        self.scrollView.addSubview(customView3)
        self.scrollView.addSubview(customView4)
        self.scrollView.addSubview(customView5)
        self.scrollView.addSubview(customView6)
        self.scrollView.addSubview(customView7)
        self.scrollView.addSubview(customView8)
        self.scrollView.addSubview(customView9)

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
    
    func ChoiceImage(){
        customView9.setLineViewHidden()
        containerView.hidden = false
    }
    
    func InitPhoto(){
        setLoc(0, y: 505)
        var listImageFile = [UIImage]()
        listImageFile = getListImage()
        listImageFile.removeAll()
        checkNeedAddButton()
        renderView()
        self.scrollView.addSubview(containerView)
        containerView.hidden = true
    }
    
    func ChoicePlanTimes(){
        choiceTime { (time) in
            self.customView6.setRRightLabel(time)
            self.customView6.becomeFirstResponder()
        }
        
    }
    
    func ChoiceModifyTimes(){
        choiceTime { (time) in
            self.customView7.setRRightLabel(time)
            self.customView7.becomeFirstResponder()
        }
        
    }


    var contact = ""
    var tel = ""
    var mobile = ""
    var hiddendes = ""
    var type = ""
    var planTime = ""
    var modifyTime = ""
    var remark = ""

    func submit(){
        contact = customView1.textField.text!
        if AppTools.isEmpty(contact) {
            alert("联系人不可为空", handler: {
                self.customView1.textField.becomeFirstResponder()
            })
            return
        }
        tel = customView2.textField.text!
        if AppTools.isEmpty(tel) {
            alert("联系电话不可为空", handler: {
                self.customView2.textField.becomeFirstResponder()
            })
            return
        }
        
        mobile = customView3.textField.text!
        if AppTools.isEmpty(mobile) {
            alert("手机不可为空", handler: {
                self.customView3.textField.becomeFirstResponder()
            })
            return
        }
        hiddendes = customView4.textField.text!
        if AppTools.isEmpty(hiddendes) {
            alert("隐患描述不可为空", handler: {
                self.customView4.textField.becomeFirstResponder()
            })
            return
        }
        
        type = customView5.textField.text!
        
        planTime = customView6.rightLabel.text!
        if AppTools.isEmpty(planTime) {
            alert("计划整改时间不可为空", handler: {
                self.customView4.textField.becomeFirstResponder()
            })
            return
        }
        
        
        modifyTime = customView7.rightLabel.text!
        if AppTools.isEmpty(modifyTime) {
            alert("整改时间不可为空", handler: {
                self.customView7.textField.becomeFirstResponder()
            })
            return
        }
        
        remark = customView8.textView.text!
        if AppTools.isEmpty(remark) {
            alert("备注不可为空", handler: {
                self.customView8.textField.becomeFirstResponder()
            })
            return
        }

        
        alertNotice("提示", message: "确认提交后，本次检查信息及隐患无法再更改") {
            self.submitNormalHidden()
        }
    }
    
    func submitNormalHidden(){
        var parameters = [String : AnyObject]()
        parameters["deletePhoto"] = "0"
        parameters["nomalDanger.companyPassId"] = String(generalCheckInfoModel.companyPassId)
        parameters["nomalDanger.id"] = String(generalCheckInfoModel.id)
        parameters["nomalDanger.linkMan"] = contact
        parameters["nomalDanger.linkTel"] = tel
        parameters["nomalDanger.linkMobile"] = mobile
        parameters["nomalDanger.danger"] = "1"
        parameters["nomalDanger.type"] = type
        parameters["nomalDanger.description"] = hiddendes
        parameters["nomalDanger.repaired"] = String(generalCheckInfoModel.repair)
        parameters["nomalDanger.completedDate"] = planTime
        parameters["nomalDanger.rectificationPlanTime"] = modifyTime
        parameters["nomalDanger.remarks"] = remark
        parameters["nomalDanger.check"] = "0"

        NetworkTool.sharedTools.updateNomalDanger(parameters,imageArrays: getListImage()) { (data, error) in
            if error == nil{
                self.showHint("一般隐患修改成功", duration: 1, yOffset: 0)
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
    
    func normalHiddenType(){
        
        UsefulPickerView.showSingleColPicker("请选择", data: singleDatanormal, defaultSelectedIndex: 1) {[unowned self] (selectedIndex, selectedValue) in
            self.customView5.setRRightLabel(selectedValue)
        }
        
    }
}
