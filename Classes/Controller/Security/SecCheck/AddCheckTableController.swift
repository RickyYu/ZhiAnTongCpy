//
//  AddCheckTableController.swift
//  ZhiAnTongCpy
//
//  Created by Ricky on 2017/2/10.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON
import UsefulPickerView

private let CheckItemCellIdentifier = "CheckItemCell"
class AddCheckTableController: BaseViewController,UITableViewDataSource,UITableViewDelegate {
    var customView1  = DetailCellView()
    var customView2  = DetailCellView()
    var tableView : UITableView!
    var checkDesModels = [CheckDesModel]()
    var companyId:String!
    var addBtn = UIButton()
    var checkName : String!
    var checkRemark : String!
    //检查表List详情点击所需参数
    var safetyCheckId:String!
    var secCheckModel : SecCheckModel!
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationItem.title = "新增检查表"
        let rightBar = UIBarButtonItem(title: "提交", style: UIBarButtonItemStyle.Done, target: self, action: #selector(self.submit))
        self.navigationItem.rightBarButtonItem = rightBar
        tableView = getTableView()
        tableView.hidden = true
        InitPage()
        //更新时
        if (secCheckModel != nil){
        customView1.textField.text = secCheckModel.checkName
        customView2.textView.text = secCheckModel.checkRemark
        tableView.hidden = false
        getDatas()
        }
    }
    
    func getDatas(){
        var parameters = [String : AnyObject]()
        parameters["safetyCheck.id"] = safetyCheckId
        NetworkTool.sharedTools.loadSafety(parameters) { (data, error) in
            if error == nil{
               self.checkDesModels = data
               self.tableView.reloadData()
            }else{
                self.showHint("\(error)", duration: 2, yOffset: 0)
                if error == NOTICE_SECURITY_NAME {
                    self.toLogin()
                }            }
        }
    
    }
    
    func InitPage(){
        customView1 = DetailCellView(frame:CGRectMake(0, 64, SCREEN_WIDTH, 45))
        customView1.setLabelName("检查表名称：")
        customView1.setRTextField("")
        customView1.textField.becomeFirstResponder()
        customView2 = DetailCellView(frame:CGRectMake(0, 110, SCREEN_WIDTH, 145))
        customView2.setLabelName("备注：")
        customView2.setTextViewShow()
        addBtn = UIButton(frame:CGRectMake(250, 255, 100, 50))
        addBtn.setTitle("新增", forState:.Normal)
        addBtn.backgroundColor = YMGlobalDeapBlueColor()
        addBtn.setTitleColor(UIColor.greenColor(), forState: .Highlighted) //触摸状态下文字的颜色
        addBtn.addTarget(self, action: #selector(self.addCheckItem), forControlEvents: UIControlEvents.TouchUpInside)
        let lineView = UIView(frame:CGRectMake(0, 315, SCREEN_WIDTH,30 ))
        lineView.backgroundColor = YMGlobalDeapBlueColor()
        let label1 = UILabel(frame:CGRectMake(80, 5, 100, 20))
        let label2 = UILabel(frame:CGRectMake(270,5 , 100, 20))
        label1.text = "检查事项"
        label1.textColor = UIColor.blackColor()
        label2.text = "备注"
        label2.textColor = UIColor.blackColor()

        self.view.addSubview(customView1)
        self.view.addSubview(customView2)
        self.view.addSubview(addBtn)
        self.view.addSubview(tableView)
        lineView.addSubview(label1)
        lineView.addSubview(label2)
        self.view.addSubview(lineView)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.resignEdit(_:))))
        
    }
    
    override func resignEdit(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            customView1.textField.resignFirstResponder()
            customView2.textView.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
    
    

    func submit(){
        self.alertNotice("提示", message: "是否提交？", handler: {
           self.submitData()
        })
    }
    
    func submitData(){
        checkName = customView1.textField.text!
        if AppTools.isEmpty(checkName) {
            alert("检查表名称不可为空!", handler: {
                self.customView1.textField.becomeFirstResponder()
            })
            return
        }
        checkRemark = customView2.textView.text!
        if AppTools.isEmpty(checkRemark) {
            alert("备注不可为空!", handler: {
                self.customView2.textView.becomeFirstResponder()
            })
            return
        }
        
        var parameters = [String : AnyObject]()
        //更新时
        if (secCheckModel != nil){
            parameters["safetyCheck.id"] = secCheckModel.id
        }else{
            //新增时
            parameters["safetyCheck.hzCompany.id"] = companyId
        }
        parameters["safetyCheck.checkName"] = checkName
        parameters["safetyCheck.checkRemark"] = checkRemark
        var tempStr : String!
        if !checkDesModels.isEmpty{
            var array = [String]()
            for i in 0..<checkDesModels.count{
                do{ //转化为JSON 字符串
                    let data = try NSJSONSerialization.dataWithJSONObject(checkDesModels[i].getParams1(), options: .PrettyPrinted)
                    array.append(NSString(data: data, encoding: NSUTF8StringEncoding) as! String)
                }catch{
                    
                }
            }
            let temp = array.joinWithSeparator(",")
            tempStr = "["+temp+"]"
            print("tempStr = \(tempStr)")
            parameters["result.list"] = tempStr
            
        }
        if AppTools.isEmpty(tempStr) {
            alert("新增检查事项列别不可为空!", handler: {
                self.customView2.textView.becomeFirstResponder()
            })
            return
        }
        if (secCheckModel != nil){
            //更新时
            NetworkTool.sharedTools.updateSafetyCheck(parameters) { (data, error) in
                self.handle(error)
            }
        }else{
            //新增时
            NetworkTool.sharedTools.createSafetyCheck(parameters) { (data, error) in
                self.handle(error)
            }
        }
    
        
    
    }
    
    func handle(error:String!){
        if error == nil{
            self.showHint("保存成功！", duration: 2, yOffset: 0)
            let viewController = self.navigationController?.viewControllers[1] as! SecCheckListController
            viewController.refresh = true
            self.navigationController?.popToViewController(viewController , animated: true)
            
        }else{
            
            self.showHint("\(error)", duration: 2, yOffset: 0)
            if error == NOTICE_SECURITY_NAME {
                self.toLogin()
            }
        }
    }
    
    func addCheckItem(){
        tableView.hidden = false
        let alertController = UIAlertController(title: "新增",
                                                message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
            textField.placeholder = "检查事项"
        }
        alertController.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
            textField.placeholder = "备注"
        }
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        let okAction = UIAlertAction(title: "确认", style: UIAlertActionStyle.Default,
                                     handler: {
                                        action in
                                        let checkItem = alertController.textFields!.first! as UITextField
                                        let remark = alertController.textFields!.last! as UITextField
                                        let model = CheckDesModel(checkDes: checkItem.text!, remark: remark.text!)
                                        self.checkDesModels.append(model)
                                        self.tableView.reloadData()
                                        
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //为表视图单元格提供数据，该方法是必须实现的方法
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CheckItemCellIdentifier, forIndexPath: indexPath) as! CheckItemCell
        let count = checkDesModels.count ?? 0
        if count > 0 {
            let info = checkDesModels[indexPath.row]
            cell.checkDesModel = info
        }
    
        return cell
    }
    
    // Override to support editing the table view.
     func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            checkDesModels.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    //返回某个节中的行数
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkDesModels.count ?? 0
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        tableView.setEditing(editing, animated: true)
    }
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    //选中时方法
    func tableView(tableView:UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath){
        self.modifyCheckItem(indexPath.row)
    }
    
    func modifyCheckItem(row:Int!){
        let checkDesModel = checkDesModels[row]
        let alertController = UIAlertController(title: "修改",
                                                message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
            textField.placeholder = "检查事项"
            textField.text = checkDesModel.matterName
        }
        alertController.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
            textField.placeholder = "备注"
            textField.text = checkDesModel.matterRemark
        }
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        let okAction = UIAlertAction(title: "确认", style: UIAlertActionStyle.Default,
                                     handler: {
                                        action in
                                        let checkItem = alertController.textFields!.first! as UITextField
                                        let remark = alertController.textFields!.last! as UITextField
                                        checkDesModel.matterName = checkItem.text!
                                        checkDesModel.matterRemark = remark.text!
                                        self.checkDesModels.removeAtIndex(row)
                                        self.checkDesModels.insert(checkDesModel, atIndex: row)
                                        self.tableView.reloadData()
                                        
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    /**
     *  创建UITableView
     */
    func getTableView() -> UITableView{
        
        if tableView == nil{
            tableView = UITableView(frame: CGRectMake(0, 345, SCREEN_WIDTH, SCREEN_HEIGHT), style: UITableViewStyle.Plain)
            let nib = UINib(nibName: "CheckItemCell",bundle: nil)
            self.tableView.registerNib(nib, forCellReuseIdentifier: CheckItemCellIdentifier)
            tableView?.delegate = self
            tableView?.dataSource = self
            tableView?.showsHorizontalScrollIndicator = false
            tableView?.showsVerticalScrollIndicator = false
            tableView?.tableFooterView = UIView()

        }
        
        return tableView!
    }
}