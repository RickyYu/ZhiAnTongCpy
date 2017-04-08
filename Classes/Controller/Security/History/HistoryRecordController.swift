//
//  HistoryRecordController.swift
//  ZhiAnTongCpy
//
//  Created by Ricky on 2017/2/14.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//

import UIKit
import SnapKit

private let HistoryRecordCellIdentifier = "HistoryRecordCell"
class HistoryRecordController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    var converyModels :CheckListVo!
    var companyId:String!
    var tableView : UITableView!
    var arrayData = [["name":"隐患记录","img":"icon_color_btn_img_yhlrblue"],["name":"安全检查记录","img":"icon_color_btn_img_aqjcblue"],["name":"隐患整改记录","img":"icon_color_btn_img_yhzgblue"]]
    override func viewDidLoad() {
        setNavagation("历史记录")
        self.view.backgroundColor = UIColor.whiteColor()
        tableView = getTableView()
        self.view.addSubview(tableView)

    }
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
        self.tabBarController?.hidesBottomBarWhenPushed = true
        self.automaticallyAdjustsScrollViewInsets = false

        if (tableView.indexPathForSelectedRow != nil) {
            tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow!, animated: true)
        }
    }
    

    
    /**
     section 数量 方法
     */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    /**
     row 数量 方法
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayData.count
    }
    
    /**
     row的高度 方法
     */
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    /**
     tableViewCell方法
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell:HistoryRecordCell = tableView.dequeueReusableCellWithIdentifier(HistoryRecordCellIdentifier, forIndexPath: indexPath) as! HistoryRecordCell
        if cell.isEqual(nil){
            cell = HistoryRecordCell(style: UITableViewCellStyle.Default, reuseIdentifier: HistoryRecordCellIdentifier)
        }
        let rowDict : NSDictionary = arrayData[indexPath.row] as NSDictionary
     
        cell.headImage.image = UIImage(named:(rowDict.objectForKey("img")as? String)!)
        cell.title.text = rowDict.objectForKey("name")as? String
        return cell
    }
    
    /**
     *  创建UITableView
     */
    func getTableView() -> UITableView{
        
        if tableView == nil{
            tableView = UITableView(frame: CGRectMake(0, 64, SCREEN_WIDTH, 270), style: UITableViewStyle.Plain)
            let nib = UINib(nibName: "HistoryRecordCell",bundle: nil)
            self.tableView.registerNib(nib, forCellReuseIdentifier: HistoryRecordCellIdentifier)
            tableView?.delegate = self
            tableView?.dataSource = self
            tableView?.showsHorizontalScrollIndicator = false
            tableView?.showsVerticalScrollIndicator = false
           tableView?.tableFooterView = UIView()
        }
        
        return tableView!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            let controller = RecordHideenPassController()
            controller.converyModels = converyModels
            controller.titleName = "隐患记录"
            controller.repairId = "2"
            controller.isGorover = "100"
            self.navigationController?.pushViewController(controller, animated: true)
        case 1:
            let controller = SecCheckRecordListController()
            controller.companyId = self.companyId
            self.navigationController?.pushViewController(controller, animated: true)
        case 2:
            let controller = RecordHideenPassController()
            controller.converyModels = converyModels
            controller.titleName = "隐患整改记录"
            controller.repairId = "3"
            controller.isGorover = "1"
            self.navigationController?.pushViewController(controller, animated: true)
            
        default:
            ""
        }
        
    }

}
