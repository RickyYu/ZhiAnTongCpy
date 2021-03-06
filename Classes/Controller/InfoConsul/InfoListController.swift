//
//  InfoServerController.swift
//  ZhiAnTongGov
//
//  Created by Ricky on 2016/12/1.
//  Copyright © 2016年 safetysafetys. All rights reserved.
//

import UIKit

//信息查询列表界面
private let InfoListReuseIdentifier = "InfoListReuseIdentifier"
class InfoListController: BaseTabViewController {
    
    //信息列表
    var listLawInfos:NSMutableArray!
    var infos = [Info]()
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
    override func viewDidLoad() {
        initPage()
    }
    
    private func initPage(){
        // 设置navigation
        setNavagation(self.infoName)
        self.navigationController?.navigationBar.hidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_white"), style: .Done, target: self, action: #selector(self.back))
        let nib = UINib(nibName: "InfoDemoCell",bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: InfoListReuseIdentifier)
        tableView.rowHeight = 53;
        tableView.separatorStyle = .None
        tableView.tableFooterView = UIView()
        
        getLawLists()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
        self.tabBarController?.hidesBottomBarWhenPushed = true
        if (tableView.indexPathForSelectedRow != nil) {
            tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow!, animated: true)
        }
    }
    
    func getLawLists(){
        var parameters = [String : AnyObject]()
        parameters["code"] = self.infoType
        parameters["pagination.pageSize"] = PAGE_SIZE
        parameters["pagination.itemCount"] = currentPage
        parameters["pagination.totalCount"] = totalCount
        
        NetworkTool.sharedTools.getLawInfoList(parameters) { (infos, error,totalCount) in
 
            if error == nil{
                if self.currentPage>totalCount{
                    if self.currentPage > PAGE_SIZE {
                    //self.showHint("已经到最后了", duration: 2, yOffset: 0)
                    }
                    self.currentPage -= PAGE_SIZE
                    return
                }
                
              self.toLoadMore = false
                self.infos += infos!
                self.tableView.reloadData()
            }else{
                // 获取数据失败后
                self.currentPage -= PAGE_SIZE
                if self.toLoadMore{
                    self.toLoadMore = false
                }
                
                if error == NOTICE_SECURITY_NAME {
                    self.toLogin()
                }else{
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
        return infos.count ?? 0
    }
    
    //为表视图单元格提供数据，该方法是必须实现的方法
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(InfoListReuseIdentifier, forIndexPath: indexPath) as! InfoDemoCell
        let count = infos.count ?? 0
        if count > 0 {
            let info = infos[indexPath.row]
            cell.info = info
        }
        if count > 0 && indexPath.row == count-1 && !toLoadMore && totalCount>PAGE_SIZE{
            toLoadMore = true
            currentPage += PAGE_SIZE
            getLawLists()
        }
        return cell
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            infos.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        if fromIndexPath != toIndexPath{
            let info = infos[fromIndexPath.row]
            infos.removeAtIndex(fromIndexPath.row)
            if toIndexPath.row > self.infos.count{
                infos.append(info)
            }else{
                infos.insert(info, atIndex: toIndexPath.row)
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
         let infoDetail = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("InfoDetailController") as! InfoDetailController
         let object : Info = infos[indexPath.row] as Info
         infoDetail.detailObject = object
         infoDetail.navTitle = self.infoName + "详情"
         self.navigationController?.pushViewController(infoDetail, animated: true)
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
        infos.removeAll()
        infos = [Info]()
    }
}


