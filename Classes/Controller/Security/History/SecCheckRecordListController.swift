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
class SecCheckRecordListController: BaseTabViewController {
    
    var companyId:String!
    //信息列表
    var listLawInfos:NSMutableArray!
    var secCheckRecordModels = [SecCheckRecordModel]()
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

    //
    var refresh  = false
    
    override func viewDidLoad() {
        initPage()
    }
    override func viewWillAppear(animated: Bool) {
        if refresh{
            reSet()
            getDatas()
        }
        
    }
    
    private func initPage(){
        // 设置navigation
        setNavagation("安全检查历史记录")
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
    
        getDatas()
    }
    
    func getDatas(){
        if refreshControl!.refreshing{
            reSet()
        }
        var parameters = [String : AnyObject]()
        parameters["safetyCheckHistory.hzCompany.id"] = companyId
        parameters["pagination.pageSize"] = PAGE_SIZE
        parameters["pagination.itemCount"] = currentPage
        
        NetworkTool.sharedTools.loadCheckHistoryList(parameters) { (secCheckRecordModels, error,totalCount) in
            // 停止加载数据
            if self.refreshControl!.refreshing{
                self.refreshControl!.endRefreshing()
            }
            if error == nil{
                
                if totalCount == 0{
                    self.alertNotice("提示", message: "请先创建检查表，是否现在添加？", handler: {
                        //createTable
                        self.SkipAdd()
                    })
                    
                }else{
                    if self.currentPage>totalCount{
                        self.showHint("已经到最后了", duration: 2, yOffset: 0)
                        self.currentPage -= PAGE_SIZE
                        return
                    }
                    self.toLoadMore = false
                    self.secCheckRecordModels += secCheckRecordModels
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
                }            }
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
        return secCheckRecordModels.count ?? 0
    }
    
    //为表视图单元格提供数据，该方法是必须实现的方法
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(SecCheckListReuseIdentifier, forIndexPath: indexPath) as! InfoDemoCell
        let count = secCheckRecordModels.count ?? 0
        if count > 0 {
            let info = secCheckRecordModels[indexPath.row]
            cell.secCheckRecordModel = info
        }
        if count > 0 && indexPath.row == count-1 && !toLoadMore{
            toLoadMore = true
            currentPage += PAGE_SIZE
            getDatas()
        }
        return cell
    }
    
    
    
    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        if fromIndexPath != toIndexPath{
            let info = secCheckRecordModels[fromIndexPath.row]
            secCheckRecordModels.removeAtIndex(fromIndexPath.row)
            if toIndexPath.row > self.secCheckRecordModels.count{
                secCheckRecordModels.append(info)
            }else{
                secCheckRecordModels.insert(info, atIndex: toIndexPath.row)
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
        let object : SecCheckRecordModel = secCheckRecordModels[indexPath.row] as SecCheckRecordModel
        let controller = SecCheckStateListController()
        controller.safetyCheckId = object.id
        controller.isHistory = true
        self.navigationController?.pushViewController(controller, animated: true)

    }
    
    
    // MARK: - 内部控制方法
    /**
     重置数据
     */
    func reSet(){
        // 重置当前页
        currentPage = 0
        // 重置数组
        secCheckRecordModels.removeAll()
        secCheckRecordModels = [SecCheckRecordModel]()
    }
}


