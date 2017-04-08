//
//  RecordHiddenNormalController.swift
//  ZhiAnTongGov
//
//  Created by Ricky on 2017/1/4.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//

import UIKit
import SnapKit
import UsefulPickerView
import SwiftyJSON

class RecordHiddenNormalController: SinglePhotoViewController {
    
    var normalType : String = ""
    var linkMan:String = ""
    var normalTypeCode : String = ""
    //联系电话
    var telephone : String = ""
    //手机
    var mobile : String = ""
    var normalDes : String = ""
    var normalPlanTime : String = ""
    var converyModels : CheckListVo!
    var secCheckStateModels = [SecCheckStateModel]()
    //隐患类别
    var customView1normal  = DetailCellView()
    //发送整改通知书
    var customView2normal = DetailCellView()
    //存在隐患
    var customView3normal = DetailCellView()
    //责令整改日期
    var customView4normal  = DetailCellView()
    //发送整改通知书
    var customView5normal = DetailCellView()
    //存在隐患
    var customView6normal = DetailCellView()
    
    var customView7 = DetailCellView()
    var customView8 = DetailCellView()
    var customView9 = DetailCellView()
    var customView10 = DetailCellView()
    var customView11 = DetailCellView()
    var customView12 = DetailCellView()
    var customView13 = DetailCellView()
    var customView14 = DetailCellView()
  
    var normalIsReform :Bool  = false//是否整改
    var submitBtnnormal = UIButton()
    var singleData = ["人","物","管理"]
    var singleDatanormal = ["无"]
    var majorScrollView: UIScrollView!
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.whiteColor()
        setNavagation("一般隐患录入")
        initNormalPageTest()
        if matterHistoryId != nil{
         self.getMatterHistorys()
            
            customView14 = DetailCellView(frame:CGRectMake(0, 540, SCREEN_WIDTH, 45))
            customView14.setLabelName("关联检查事项：")
            customView14.setRRightLabel("无")
            customView14.addOnClickListener(self, action: #selector(self.choiceCheckItem))
            
            customView6normal = DetailCellView(frame:CGRectMake(0, 585, SCREEN_WIDTH, 45))
            customView6normal.setLabelName("现场图片：")
            customView6normal.setRRightLabel("")
            customView6normal.addOnClickListener(self, action: #selector(self.choiceNormalImage))
            setImageViewLoc(0, y: 625)
            self.majorScrollView.addSubview(customView14)
            self.majorScrollView.addSubview(customView6normal)
        }else{

            
            customView6normal = DetailCellView(frame:CGRectMake(0, 540, SCREEN_WIDTH, 45))
            customView6normal.setLabelName("现场图片：")
            customView6normal.setRRightLabel("")
            customView6normal.addOnClickListener(self, action: #selector(self.choiceNormalImage))
            setImageViewLoc(0, y: 580)
            self.majorScrollView.addSubview(customView6normal)
        
        
        }
        self.majorScrollView.addSubview(scrollView)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.resignEdit(_:))))

    }
    
    override func resignEdit(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            customView10.textField.resignFirstResponder()
            customView11.textField.resignFirstResponder()
            customView12.textField.resignFirstResponder()
            customView2normal.textField.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
    func getMatterHistorys(){

        var parameters = [String : AnyObject]()
        parameters["safetyCheckHistory.id"] = self.matterHistoryId!
        
        NetworkTool.sharedTools.loadMatterHistoryList(parameters) { (datas, error,totalCount) in
            // 停止加载数据
            if error == nil{
                    self.secCheckStateModels = datas
                    for model in self.secCheckStateModels{
                        self.createData(model)
                    }
                
            }else{
              
                self.showHint("\(error)", duration: 2, yOffset: 0)
                if error == NOTICE_SECURITY_NAME {
                    self.toLogin()
                }
            }
        
        }
    }

    func createData(model:SecCheckStateModel){
        singleDatanormal.append(model.matterName)
    }
    func getIdByName(name:String)-> String{
        for model in self.secCheckStateModels{
            if model.matterName == name {
                return String(model.id)
            }
        }
        return ""
    }
    
    func keyboardWillShow1(notification: NSNotification) {
        adjustInsetForKeyboardShow(true, notification: notification)
    }
    func keyboardWillHide1(notification: NSNotification) {
        adjustInsetForKeyboardShow(false, notification: notification)
    }
    
    
    func adjustInsetForKeyboardShow(show:Bool,notification:NSNotification){
        let userInfo = notification.userInfo ?? [:]
        let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        let adjustmentHeight = (CGRectGetHeight(keyboardFrame)) * (show ? 1:-1)
        print("adjustmentHeight = \(adjustmentHeight)")
        majorScrollView.contentInset.bottom += adjustmentHeight
        majorScrollView.scrollIndicatorInsets.bottom += adjustmentHeight
        
        print("majorScrollView.contentSize.height = \(majorScrollView.contentSize.height)")
        
        
    }
    
    

    
    func initNormalPageTest(){
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillShow1(_:)), name:UIKeyboardWillShowNotification, object: nil)
//        //当键盘收起的时候会向系统发出一个通知，
//        //这个时候需要注册另外一个监听器响应该通知
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillHide1(_:)), name:UIKeyboardWillHideNotification, object: nil)
        
        majorScrollView = UIScrollView(frame: CGRectMake(0, 0, SCREEN_WIDTH, 715))
       // majorScrollView!.pagingEnabled = true
        majorScrollView!.scrollEnabled = true
        majorScrollView!.showsHorizontalScrollIndicator = true
        majorScrollView!.showsVerticalScrollIndicator = false
        majorScrollView!.scrollsToTop = true
        majorScrollView!.contentSize = CGSizeMake(SCREEN_WIDTH, 715)
        
        submitBtnnormal.setTitle("保存", forState:.Normal)
        submitBtnnormal.backgroundColor = YMGlobalDeapBlueColor()
        submitBtnnormal.setTitleColor(UIColor.greenColor(), forState: .Highlighted) //触摸状态下文字的颜色
        submitBtnnormal.addTarget(self, action: #selector(self.normalSubmit), forControlEvents: UIControlEvents.TouchUpInside)
        
        customView7 = DetailCellView(frame:CGRectMake(0, 45, SCREEN_WIDTH, 45))
        customView7.setLabelName("单位名称：")
        customView7.setRCenterLabel(converyModels.companyname)
        
        customView8 = DetailCellView(frame:CGRectMake(0, 90, SCREEN_WIDTH, 45))
        customView8.setLabelName("单位地址：")
        customView8.setRCenterLabel(converyModels.companyadress)
        
        customView9 = DetailCellView(frame:CGRectMake(0, 135, SCREEN_WIDTH, 45))
        customView9.setLabelName("企业法人：")
        customView9.setRCenterLabel(converyModels.fdDelegate)
        
        customView10 = DetailCellView(frame:CGRectMake(0, 180, SCREEN_WIDTH, 45))
        customView10.setLabelName("联系人：")
        customView10.setRTextField( "")
        customView10.textField.addTarget(self, action: #selector(self.textDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        customView11 = DetailCellView(frame:CGRectMake(0, 225, SCREEN_WIDTH, 45))
        customView11.setLabelName("联系电话：")
        customView11.setRTextField( "")
         customView11.textField.addTarget(self, action: #selector(self.textDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        customView12 = DetailCellView(frame:CGRectMake(0, 270, SCREEN_WIDTH, 45))
        customView12.setLabelName("手 机：")
        customView12.setRTextField( "")
         customView12.textField.addTarget(self, action: #selector(self.textDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        customView13 = DetailCellView(frame:CGRectMake(0, 315, SCREEN_WIDTH, 45))
        customView13.setLabelName("工商注册号：")
        customView13.setRCenterLabel(converyModels.businessRegNumber)
        
        
        customView1normal = DetailCellView(frame:CGRectMake(0, 360, SCREEN_WIDTH, 45))
        customView1normal.setLabelName("隐患类别：")
        customView1normal.setRRightLabel("物")
        customView1normal.addOnClickListener(self, action: #selector(self.normalHiddenType))
        
        customView2normal = DetailCellView(frame:CGRectMake(0, 405, SCREEN_WIDTH, 45))
        customView2normal.setLabelName("隐患描述：")
        customView2normal.setRTextField( "")
        
        customView3normal = DetailCellView(frame:CGRectMake(0, 450, SCREEN_WIDTH, 45))
        customView3normal.setLabelName("计划整改时间：")
        customView3normal.setRRightLabel("")
        customView3normal.setTimeImg()
        customView3normal.addOnClickListener(self, action: #selector(self.normalChoicePlanTime))
        
        customView4normal = DetailCellView(frame:CGRectMake(0, 495, SCREEN_WIDTH, 45))
        customView4normal.setLabelName("录入时间：")
        getSystemTime({ (time) in
            self.customView4normal.setRCenterLabel(time)
        })
        customView4normal.setTimeImg()
        

        
        
        
        self.view.addSubview(submitBtnnormal)
           self.view.addSubview(majorScrollView)
        self.majorScrollView.addSubview(customView1normal)
        self.majorScrollView.addSubview(customView2normal)
        self.majorScrollView.addSubview(customView3normal)
        self.majorScrollView.addSubview(customView4normal)
        self.majorScrollView.addSubview(customView5normal)
        self.majorScrollView.addSubview(customView7)
        self.majorScrollView.addSubview(customView8)
        self.majorScrollView.addSubview(customView9)
        self.majorScrollView.addSubview(customView10)
        self.majorScrollView.addSubview(customView11)
        self.majorScrollView.addSubview(customView12)
        self.majorScrollView.addSubview(customView13)
 
        
        
        submitBtnnormal.snp_makeConstraints { make in
            make.bottom.equalTo(self.view.snp_bottom).offset(-15)
            make.left.equalTo(self.view.snp_left).offset(50)
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH-100, 35))
        }
        
        majorScrollView.snp_makeConstraints { make in
            make.top.equalTo(self.view.snp_top).offset(20)
            make.left.equalTo(self.view.snp_left)
            make.bottom.equalTo(submitBtnnormal.snp_top).offset(-5)
            make.right.equalTo(self.view.snp_right)
        }
        
        
    }

    
    
    func initNormalPage(){
        
        majorScrollView = UIScrollView(frame: CGRectMake(0, 0, SCREEN_WIDTH, 1000))
       // majorScrollView!.pagingEnabled = true
        majorScrollView!.scrollEnabled = true
        majorScrollView!.showsHorizontalScrollIndicator = true
        majorScrollView!.showsVerticalScrollIndicator = false
        majorScrollView!.scrollsToTop = true
        majorScrollView!.contentSize = CGSizeMake(SCREEN_WIDTH, 1000)

        submitBtnnormal.setTitle("保存", forState:.Normal)
        submitBtnnormal.backgroundColor = YMGlobalDeapBlueColor()
        submitBtnnormal.setTitleColor(UIColor.greenColor(), forState: .Highlighted) //触摸状态下文字的颜色
        submitBtnnormal.addTarget(self, action: #selector(self.normalSubmit), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        customView7.setLabelName("单位名称：")
        customView7.setRCenterLabel(converyModels.companyname)
        
        customView8.setLabelName("单位地址：")
        customView8.setRCenterLabel(converyModels.companyadress)
        
        customView9.setLabelName("企业法人：")
        customView9.setRCenterLabel(converyModels.fdDelegate)
        
        customView10.setLabelName("联系人：")
        customView10.setRTextField( "")
        
        customView11.setLabelName("联系电话：")
        customView11.setRTextField( "")
        
        customView12.setLabelName("手机：")
        customView12.setRTextField( "")
        customView12.textField.keyboardType = UIKeyboardType.NumberPad
        
        customView13.setLabelName("工商注册号：")
        customView13.setRCenterLabel(converyModels.businessRegNumber)
      
        customView1normal.setLabelName("隐患类别：")
        customView1normal.setRRightLabel("物")
        customView1normal.addOnClickListener(self, action: #selector(self.normalHiddenType))
        
        customView2normal.setLabelName("隐患描述：")
        customView2normal.setRTextField( "")

        customView3normal.setLabelName("计划整改时间：")
        customView3normal.setRRightLabel("")
        customView3normal.setTimeImg()
        customView3normal.addOnClickListener(self, action: #selector(self.normalChoicePlanTime))
        
        customView4normal.setLabelName("录入时间：")
        getSystemTime({ (time) in
          self.customView4normal.setRCenterLabel(time)
        })
        customView4normal.setTimeImg()
        customView6normal.setLabelName("现场图片：")
        customView6normal.setRRightLabel("")
        customView6normal.addOnClickListener(self, action: #selector(self.choiceNormalImage))
        
        customView14.setLabelName("关联检查事项：")
        customView14.setRRightLabel("无")
        customView14.addOnClickListener(self, action: #selector(self.choiceCheckItem))
        
        self.view.addSubview(submitBtnnormal)
        self.view.addSubview(customView1normal)
        self.view.addSubview(customView2normal)
        self.view.addSubview(customView3normal)
        self.view.addSubview(customView4normal)
        self.view.addSubview(customView5normal)
        self.view.addSubview(customView6normal)
        self.view.addSubview(customView7)
        self.view.addSubview(customView8)
        self.view.addSubview(customView9)
        self.view.addSubview(customView10)
        self.view.addSubview(customView11)
        self.view.addSubview(customView12)
        self.view.addSubview(customView13)
        self.view.addSubview(customView14)
        
        customView7.snp_makeConstraints { make in
            make.top.equalTo(self.view.snp_top).offset(64)
            make.left.equalTo(self.view.snp_left)
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH-30, 45))
        }
        
        customView8.snp_makeConstraints { make in
            make.top.equalTo(self.customView7.snp_bottom)
            make.left.equalTo(self.view.snp_left)
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH-30, 45))
        }
        
        customView9.snp_makeConstraints { make in
            make.top.equalTo(self.customView8.snp_bottom)
            make.left.equalTo(self.view.snp_left)
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH-30, 45))
        }
        
        customView10.snp_makeConstraints { make in
            make.top.equalTo(self.customView9.snp_bottom)
            make.left.equalTo(self.view.snp_left)
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH-30, 45))
        }
        
        customView11.snp_makeConstraints { make in
            make.top.equalTo(self.customView10.snp_bottom)
            make.left.equalTo(self.view.snp_left)
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH-30, 45))
        }
        
        customView12.snp_makeConstraints { make in
            make.top.equalTo(self.customView11.snp_bottom)
            make.left.equalTo(self.view.snp_left)
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH-30, 45))
        }
        
        customView13.snp_makeConstraints { make in
            make.top.equalTo(self.customView12.snp_bottom)
            make.left.equalTo(self.view.snp_left)
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH-30, 45))
        }
        
        customView1normal.snp_makeConstraints { make in
            make.top.equalTo(self.customView13.snp_bottom)
            make.left.equalTo(self.view.snp_left)
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH-30, 45))
        }
        
        customView2normal.snp_makeConstraints { make in
            make.top.equalTo(self.customView1normal.snp_bottom)
            make.left.equalTo(self.view.snp_left)
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH-30, 45))
        }
        
        customView3normal.snp_makeConstraints { make in
            make.top.equalTo(self.customView2normal.snp_bottom)
            make.left.equalTo(self.view.snp_left)
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH-30, 45))
        }
        
        customView4normal.snp_makeConstraints { make in
            make.top.equalTo(self.customView3normal.snp_bottom)
            make.left.equalTo(self.view.snp_left)
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH-30, 45))
        }

        
        customView6normal.snp_makeConstraints { make in
            make.top.equalTo(self.customView4normal.snp_bottom)
            make.left.equalTo(self.view.snp_left)
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH-30, 45))
        }
        
        customView14.snp_makeConstraints { make in
            make.top.equalTo(self.customView6normal.snp_bottom)
            make.left.equalTo(self.view.snp_left)
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH-30, 45))
        }

        submitBtnnormal.snp_makeConstraints { make in
            make.bottom.equalTo(self.view.snp_bottom).offset(-15)
            make.left.equalTo(self.view.snp_left).offset(50)
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH-100, 35))
        }

    
    }
   
    func choiceNormalImage(){
        self.takeImage()
        customView6normal.setLineViewHidden()
    }
    
    func normalSubmit(){
    
        normalType = customView1normal.rightLabel.text!
        normalTypeCode = getTroubleType(normalType)
        normalDes = customView2normal.textField.text!
        telephone = customView11.textField.text!
        mobile = customView12.textField.text!
        linkMan = customView10.textField.text!
        
        if AppTools.isEmpty(linkMan) {
            alert("联系人不可为空", handler: {
                self.customView10.textField.becomeFirstResponder()
            })
            return
        }
        
        if AppTools.isEmpty(telephone) {
            alert("联系电话不可为空", handler: {
                self.customView11.textField.becomeFirstResponder()
            })
            return
        }
        
        if !ValidateEnum.phoneNum(telephone).isRight {
            alert("联系电话格式错误，请重新输入!", handler: {
                self.customView12.textField.becomeFirstResponder()
            })
            return
        }
        
        if AppTools.isEmpty(mobile) {
            alert("手机号码不可为空", handler: {
                self.customView12.textField.becomeFirstResponder()
            })
            return
        }
        if !ValidateEnum.phoneNum(mobile).isRight {
            alert("手机号码格式错误，请重新输入!", handler: {
                self.customView12.textField.becomeFirstResponder()
            })
            return
        }
        
        if AppTools.isEmpty(normalDes) {
            alert("隐患描述不可为空", handler: {
                self.customView5normal.textField.becomeFirstResponder()
            })
            return
        }
        normalPlanTime = customView3normal.rightLabel.text!
        if AppTools.isEmpty(normalPlanTime) {
            alert("计划整改时间不可为空", handler: {
                self.customView3normal.textField.becomeFirstResponder()
            })
            return
        }
        
        alertNotice("提示", message: "确认提交后，本次检查信息及隐患无法再更改") {
            self.submitGeneralTrouble()
        }

    }

    func normalTapped1(button:UIButton){
        button.selected = !button.selected
        if button.selected{
            normalIsReform = true
        }else{
            normalIsReform = false
        }
    }
    
    func normalHiddenType(){
    
        UsefulPickerView.showSingleColPicker("请选择", data: singleData, defaultSelectedIndex: 0) {[unowned self] (selectedIndex, selectedValue) in
            self.customView1normal.setRRightLabel(selectedValue)
        }
        
    }
    
    func normalChoicePlanTime(){
        choiceTime { (time) in
            self.customView3normal.setRRightLabel(time)
            self.customView3normal.becomeFirstResponder()
        }
        
    }

    var notedIdStr:String = ""
    var matterHistoryId:String!//获取历史Matter 
    var historyId:String!//matterId
    //上传一般隐患，等新增上传完毕后上传
    func submitGeneralTrouble(){
        var parameters = [String : AnyObject]()
        parameters["nomalDanger.companyPassId"] = converyModels.companyId
        parameters["nomalDanger.linkMan"] = customView10.textField.text
        parameters["nomalDanger.linkTel"] = telephone
        parameters["nomalDanger.linkMobile"] = mobile
        parameters["nomalDanger.danger"] = String(true)
        parameters["nomalDanger.type"] = normalTypeCode
        parameters["nomalDanger.description"] = normalDes
        parameters["nomalDanger.repaired"] = String(normalIsReform)
        parameters["nomalDanger.rectificationPlanTime"] = normalPlanTime
        if historyId != nil{
           parameters["nomalDanger.safetyMatterHistory.id"] = historyId
        }
        
        
        NetworkTool.sharedTools.creatNormalDanger(parameters,imageArrays: getTakeImages()) { (data, error) in
            if error == nil{
                self.showHint("一般隐患添加成功", duration: 1, yOffset: 0)
                let viewController = self.navigationController?.viewControllers[0] as! SecurityCheckController
               // viewController.isRefresh = true
                self.navigationController?.popToViewController(viewController , animated: true)

                
            }else{
                self.showHint("\(error!)", duration: 2, yOffset: 0)
                if error == NOTICE_SECURITY_NAME {
                    self.toLogin()
                }            }
        }
    }
    
    func choiceCheckItem(){
        UsefulPickerView.showSingleColPicker("请选择", data: singleDatanormal, defaultSelectedIndex: 0) {[unowned self] (selectedIndex, selectedValue) in
            self.historyId = self.getIdByName(selectedValue)
            self.customView14.setRRightLabel(selectedValue)
        }
        
    }
}
