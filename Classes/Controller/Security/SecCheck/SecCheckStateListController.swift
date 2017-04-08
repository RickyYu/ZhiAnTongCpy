//
//  mSDSInfoModelserverController.swift
//  ZhiAnTongGov
//
//  Created by Ricky on 2016/12/1.
//  Copyright © 2016年 safetysafetys. All rights reserved.
//

import UIKit


//隐患列表和历史复查记录页面
private let Identifier = "HiddenConfirmCell"

class SecCheckStateListController: BaseTabViewController {

    //隐患列表数据
    var hiddenModels :[SecCheckStateModel] = []
    //接受传进来的值
    var safetyCheckId:Int!
  
    // 当前页
    var currentPage : Int = 0  //加载更多时候+10
    //总条数
    var totalCount : Int = 0
    // 是否加载更多
    private var toLoadMore = false
    //从历史检查记录则为true
    var isHistory:Bool = false
    override func viewDidLoad() {
        initPage()
    }
    
    private func initPage(){
        
        // 设置tableview相关
        // tableView.registerClass(InfoDemoCell.self, forCellReuseIdentifier: InfoListReuseIdentifier)
        let nib = UINib(nibName: Identifier,bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: Identifier)
        
        tableView.rowHeight = 53;
        tableView.separatorStyle = .SingleLine
        tableView.tableFooterView = UIView()
        
        
        // 设置下拉刷新控件
        refreshControl = RefreshControl(frame: CGRectZero)
        refreshControl?.addTarget(self, action: #selector(self.getDatas), forControlEvents: .ValueChanged)
        refreshControl?.beginRefreshing()
        if isHistory {
            setNavagation("安全检查历史记录详情")
            getHistoryDatas()
        }else{
            setNavagation("安全检查")
            let rightBar = UIBarButtonItem(title: "提交", style: UIBarButtonItemStyle.Done, target: self, action: #selector(self.submit))
            self.navigationItem.rightBarButtonItem = rightBar
            getDatas()
        }
        
    }
    //是否有检查项不通过
    var isPass:Bool = false
    func submit(){
       
        
        var parameters = [String : AnyObject]()
        parameters["safetyCheck.id"] = safetyCheckId
        var array = [String]()
        for i in 0..<hiddenModels.count{
            do{ //转化为JSON 字符串
                let model:SecCheckStateModel = hiddenModels[i]
                print(model.matterState)
                if Bool(model.matterState) {
                    isPass = false
                }else{
                    isPass = true
                }
                let data = try NSJSONSerialization.dataWithJSONObject(model.getParams1(), options: .PrettyPrinted)
                array.append(NSString(data: data, encoding: NSUTF8StringEncoding) as! String)
               // print(NSString(data: data, encoding: NSUTF8StringEncoding) as! String)
            }catch{
                
            }
        }
        let temp = array.joinWithSeparator(",")
        let tempStr = "["+temp+"]"
        print(tempStr)
        parameters["result.list"] = tempStr
        NetworkTool.sharedTools.createSafetyMatter(parameters) { (id, error,totalCount) in

            if error == nil{
                if self.isPass {//检查项不通过，跳转隐患录入（后台返回JSON格式为非标准，这里暂时提交前判断）
                    self.alertNoticeWithVoid("提示", message: "保存成功，存在未通过检查项，是否添加隐患？", handSure: {
                        let controller = RecordHideenPassController()
                        print(id)
                        controller.matterHistoryId = id
                        controller.titleName = "隐患录入"
                        self.navigationController?.pushViewController(controller, animated: true)

                        }, handCancel: {
                            self.navigationController?.popViewControllerAnimated(true)
                            
                    })
                
                }else{//检查项全通过
                self.showHint("提交成功", duration: 2, yOffset: 0)
//                let viewController = self.navigationController?.viewControllers[0] as! SecurityCheckController
//                self.navigationController?.popToViewController(viewController , animated: true)
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }else{
                self.showHint("\(error)", duration: 2, yOffset: 0)
                if error == NOTICE_SECURITY_NAME {
                    self.toLogin()
                }
            }
        }

        

    
    }
    
    var isCheckHidden:Bool = false
    
    
    func getHistoryDatas(){
        if refreshControl!.refreshing{
            reSet()
            
        }
        var parameters = [String : AnyObject]()
        parameters["safetyCheckHistory.id"] = safetyCheckId
        
        NetworkTool.sharedTools.loadMatterHistoryList(parameters) { (datas, error,totalCount) in
            // 停止加载数据
            if self.refreshControl!.refreshing{
                self.refreshControl!.endRefreshing()
            }
            
            if error == nil{
                if self.currentPage>totalCount{
                    //self.showHint("已经到最后了", duration: 2, yOffset: 0)
                    self.currentPage -= PAGE_SIZE
                    return
                }
                self.toLoadMore = false
                self.hiddenModels += datas!
                self.tableView.reloadData()
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
    
    func getDatas(){
        if refreshControl!.refreshing{
            reSet()
            
        }
        var parameters = [String : AnyObject]()
        parameters["safetyCheck.id"] = safetyCheckId
        
        NetworkTool.sharedTools.loadMatterList(parameters) { (datas, error,totalCount) in
            // 停止加载数据
            if self.refreshControl!.refreshing{
                self.refreshControl!.endRefreshing()
            }
            
            if error == nil{
                if self.currentPage>totalCount{
                    //self.showHint("已经到最后了", duration: 2, yOffset: 0)
                    self.currentPage -= PAGE_SIZE
                    return
                }
                self.toLoadMore = false
                self.hiddenModels += datas!
                self.tableView.reloadData()
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
        
   
      
            return hiddenModels.count ?? 0

    }
    

    //为表视图单元格提供数据，该方法是必须实现的方法
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(Identifier, forIndexPath: indexPath) as! HiddenConfirmCell
        if cell.isEqual(nil){
            cell = HiddenConfirmCell(style: UITableViewCellStyle.Default, reuseIdentifier: Identifier)
        }
        let count :Int = hiddenModels.count
            if  count > 0 {
                let checkHidden = hiddenModels[indexPath.row]
                if isHistory {
                cell.isHistory = true
                }else{
                cell.isHistory = false
                }
                cell.hiddenModel = checkHidden
            }
      
        
        if count > 0 && indexPath.row == count-1 && !toLoadMore{
            toLoadMore = true
            currentPage += PAGE_SIZE
            getDatas()
        }
        return cell
        
    }
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if isCheckHidden{
//            let controller = NormalHiddenDetail()
//            controller.converyId = String(checkHiddenModels[indexPath.row].id)
//            self.navigationController?.pushViewController(controller, animated: true)
//            
//        }
//    }
    
    
    // Override to support conditional rearranging of the table view.
    //在编辑状态，可以拖动设置item位置
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    
    // MARK: - Navigation
    
    
    // MARK: - 内部控制方法
    /**
     重置数据
     */
    func reSet(){
        // 重置当前页
        currentPage = 0
         totalCount = 0
        // 重置数组
      
            hiddenModels.removeAll()
            hiddenModels = [SecCheckStateModel]()
        
    }
    

}


