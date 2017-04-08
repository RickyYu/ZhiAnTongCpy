//
//  MajorHiddenListController.swift
//  ZhiAnTongCpy
//
//  Created by Ricky on 2017/2/8.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//

import UIKit

//信息查询列表界面
private let SecCheckListReuseIdentifier = "SecCheckListReuseIdentifier"
class MajorHiddenListController: BaseTabViewController {
    
    var companyId:String!
    //信息列表
    var listLawInfos:NSMutableArray!
    var secCheckModels = [MajorCheckInfoModel]()
    // 当前页
    var currentPage : Int = 0  //加载更多时候+10
    //总条数
    var totalCount : Int = 0
    // 是否加载更多
    private var toLoadMore = false
    //信息类型name
    var infoName :String!
    //信息类型value
    var infoType :String!
    var tempNum:Int = 0
    //重大隐患所需
    var isGorover:String!
    override func viewDidLoad() {
        initPage()
    }
    
    private func initPage(){
        // 设置navigation
        switch isGorover {
        case "0":
            setNavagation("重大隐患整改")
        case "100":
            setNavagation("重大隐患记录")
        case "1":
            setNavagation("重大隐患整改历史记录")
        default:
            print("error")
        }
        self.navigationController?.navigationBar.hidden = false
        self.hidesBottomBarWhenPushed = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_white"), style: .Done, target: self, action: #selector(self.back))
        let nib = UINib(nibName: "CheckInfoViewCell",bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: SecCheckListReuseIdentifier)
        tableView.rowHeight = 53;
        tableView.separatorStyle = .SingleLine
        tableView.tableFooterView = UIView()
        // 设置下拉刷新控件
//        refreshControl = RefreshControl(frame: CGRectZero)
//        refreshControl?.addTarget(self, action: #selector(self.getDatas), forControlEvents: .ValueChanged)
//        refreshControl?.beginRefreshing()
        
        getDatas()
    }
    
    func getDatas(){
//        if refreshControl!.refreshing{
//            reSet()
//        }
        var parameters = [String : AnyObject]()
        parameters["company.id"] = companyId
        //三种数据 0,100 ,1
        parameters["danger.isGorver"] = self.isGorover
        parameters["pagination.pageSize"] = PAGE_SIZE
        parameters["pagination.itemCount"] = currentPage
        parameters["pagination.totalCount"] = totalCount
        NetworkTool.sharedTools.loadDangers(parameters,pageSize: tempNum) { (secCheckModels, error,totalCount) in
        
            if error == nil{
                 self.totalCount = totalCount
                if self.currentPage>totalCount{
                    if self.toLoadMore {
                       // self.showHint("已经到最后了", duration: 2, yOffset: 0)
                    }
                    self.currentPage -= PAGE_SIZE
                    return
                }
                
                self.toLoadMore = false
                self.secCheckModels += secCheckModels!
                self.tableView.reloadData()
            }else{
                
                // 获取数据失败后
                self.currentPage -= PAGE_SIZE
                if self.toLoadMore{
                    self.toLoadMore = false
                }
    
                if error == NOTICE_SECURITY_NAME {
                    self.toLogin()
                }else {
                 self.showHint("\(error)", duration: 2, yOffset: 0)
                }
            }
        }
        
    }
    
    func back()
    {
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    //返回节的个数
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    //返回某个节中的行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        //        return listVideos.count
        return secCheckModels.count ?? 0
    }
    
    //为表视图单元格提供数据，该方法是必须实现的方法
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(SecCheckListReuseIdentifier, forIndexPath: indexPath) as! CheckInfoViewCell
        let count = secCheckModels.count ?? 0
        if count > 0 {
            let info = secCheckModels[indexPath.row]
            cell.majorCheckInfoModel = info
        }
        if count > 0 && indexPath.row == count-1 && !toLoadMore{
            toLoadMore = true
            currentPage += PAGE_SIZE
            tempNum = PAGE_SIZE
            getDatas()
        }
        return cell
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            secCheckModels.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        if fromIndexPath != toIndexPath{
            let info = secCheckModels[fromIndexPath.row]
            secCheckModels.removeAtIndex(fromIndexPath.row)
            if toIndexPath.row > self.secCheckModels.count{
                secCheckModels.append(info)
            }else{
                secCheckModels.insert(info, atIndex: toIndexPath.row)
            }
        }
    }
    
    
    // Override to support conditional rearranging of the table view.
    //在编辑状态，可以拖动设置item位置
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let object : MajorCheckInfoModel = secCheckModels[indexPath.row] as MajorCheckInfoModel
        if self.isGorover == "100"{
            let controller = MajorHiddenModifyController()
            controller.checkInfoModel = object
            controller.isGorover = self.isGorover
            self.navigationController?.pushViewController(controller, animated: true)

        }else{
            let controller = MajorHiddenDetailController()
            controller.majorCheckInfoModel = object
            controller.isGorover = self.isGorover
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
    // MARK: - 内部控制方法
    /**
     重置数据
     */
    func reSet(){
        // 重置当前页
        currentPage = 0
        // 重置数组
        secCheckModels.removeAll()
        secCheckModels = [MajorCheckInfoModel]()
    }
}
