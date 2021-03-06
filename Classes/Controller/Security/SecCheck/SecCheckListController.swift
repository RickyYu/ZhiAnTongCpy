//
//  SecCheckListController
//  ZhiAnTongGov
//
//  Created by Ricky on 2017/2/1.
//  Copyright © 2016年 safetysafetys. All rights reserved.
//

import UIKit

//信息查询列表界面
private let SecCheckListReuseIdentifier = "SecCheckListReuseIdentifier"
class SecCheckListController: BaseTabViewController {
    
    var companyId:String!
    //信息列表
    var listLawInfos:NSMutableArray!
    var secCheckModels = [SecCheckModel]()
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
    //传输过来的类型 1为安全检查  2为检查表
    var passType :String!
    //
    var refresh  = false
    
    override func viewDidLoad() {
        initPage()
    }
    override func viewWillAppear(animated: Bool) {
        
        if (self.tableView.indexPathForSelectedRow != nil) {
           self.tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow!, animated: true)
        }
        if refresh{
            reSet()
            getDatas()
        }
        
    }
    
    private func initPage(){
        // 设置navigation
       setNavagation("检查表")
        self.navigationController?.navigationBar.hidden = false
         self.hidesBottomBarWhenPushed = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_white"), style: .Done, target: self, action: #selector(self.back))
        let nib = UINib(nibName: "InfoDemoCell",bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: SecCheckListReuseIdentifier)
        tableView.rowHeight = 53;
        tableView.separatorStyle = .None
        tableView.tableFooterView = UIView()
        // 设置下拉刷新控件
        refreshControl = RefreshControl(frame: CGRectZero)
        refreshControl?.addTarget(self, action: #selector(self.getDatas), forControlEvents: .ValueChanged)
        refreshControl?.beginRefreshing()
        if passType == "2"{
        initRightBar()
        }
        getDatas()
    }
    
    func deleteDate(id:Int!){
        var parameters = [String : AnyObject]()
        parameters["safetyCheck.id"] = String(id)
        NetworkTool.sharedTools.deleteSafetyCheck(parameters) { (generalCheckInfoModel, error) in
     
            if error == nil{
             self.showHint("删除成功", duration: 1, yOffset: 0)
            }else{
                
                if error == NOTICE_SECURITY_NAME {
                    self.toLogin()
                }else{
                self.showHint("\(error)", duration: 1, yOffset: 0)
                }
            }
        }

    }
    
    func getDatas(){
        if refreshControl!.refreshing{
            reSet()
        }
        var parameters = [String : AnyObject]()
        parameters["safetyCheck.hzCompany.id"] = companyId
        parameters["pagination.pageSize"] = PAGE_SIZE
        parameters["pagination.itemCount"] = currentPage
        
        NetworkTool.sharedTools.loadList(parameters) { (secCheckModels, error,totalCount) in
            // 停止加载数据
            if self.refreshControl!.refreshing{
                self.refreshControl!.endRefreshing()
            }
            if error == nil{
                self.totalCount = totalCount
                if totalCount == 0{
                    self.alertNotice("提示", message: "请先创建检查表，是否现在添加？", handler: {
                       //createTable
                        self.SkipAdd()
                    })
                
                }else{
                if self.currentPage>totalCount{
//                    self.showHint("已经到最后了", duration: 2, yOffset: 0)
                    self.currentPage -= PAGE_SIZE
                    return
                }
                self.toLoadMore = false
                self.secCheckModels += secCheckModels!
                self.tableView.reloadData()
                }
            }else{
                
                // 获取数据失败后
                self.currentPage -= PAGE_SIZE
                if self.toLoadMore{
                    self.toLoadMore = false
                }
                self.showHint("\(error)", duration: 2, yOffset: 0)
                if error == NOTICE_SECURITY_NAME {
                    self.toLogin()
                }
            }
        }
        
    }
    
    func initRightBar(){
        let rightBar = UIBarButtonItem(title: "新增", style: UIBarButtonItemStyle.Done, target: self, action: #selector(self.SkipAdd))
        self.navigationItem.rightBarButtonItem = rightBar
    
    }
    
    func SkipAdd(){
        let controller = AddCheckTableController()
        controller.companyId = self.companyId
        self.navigationController?.pushViewController(controller, animated: true)
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
        let cell = tableView.dequeueReusableCellWithIdentifier(SecCheckListReuseIdentifier, forIndexPath: indexPath) as! InfoDemoCell
        let count = secCheckModels.count ?? 0
        if count > 0 {
            let info = secCheckModels[indexPath.row]
            cell.secCheckModel = info
        }
        if count > 0 && indexPath.row == count-1 && !toLoadMore && self.totalCount > PAGE_SIZE {
            toLoadMore = true
            currentPage += PAGE_SIZE
            getDatas()
        }
        return cell
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
        let object : SecCheckModel = secCheckModels[indexPath.row] as SecCheckModel
        if passType == "1" {
        let controller = SecCheckStateListController()
        controller.safetyCheckId = object.id
        self.navigationController?.pushViewController(controller, animated: true)
        }else{
            let controller = AddCheckTableController()
            controller.safetyCheckId = String(object.id)
            controller.secCheckModel = object
            controller.companyId = self.companyId
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            secCheckModels.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            deleteDate(secCheckModels[indexPath.row].id)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    // MARK: - 内部控制方法
    /**
     重置数据
     */
    func reSet(){
        // 重置当前页
        currentPage = 0
         totalCount = 0
        // 重置数组
        secCheckModels.removeAll()
        secCheckModels = [SecCheckModel]()
    }
}


