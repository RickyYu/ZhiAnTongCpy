//
//  ExpertLibraryController.swift
//  ZhiAnTongCpy
//
//  Created by Ricky on 2017/2/20.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//


import UIKit
import SnapKit
import SwiftyJSON
import UsefulPickerView

private let InfoListReuseIdentifier = "InfoListReuseIdentifier"
class ExpertLibraryController: BaseViewController,UITableViewDataSource,UITableViewDelegate {
    var customView1 = DetailCellView()
    var tableView : UITableView!
    //总条数
    var totalCount : Int = 0
    // 当前页
    var currentPage : Int = 0  //加载更多时候+10
    
    var expertCode : String = "companyType_02"
    let expertType = ["金属与非金属矿山","危险化学品","烟花爆竹","石油化工",
        "交通运输","医药","建材","冶金","有色","机械","建筑","旅游","纺织",
        "烟草","电力","燃气","电信","商贸","渔业","科研事业单位","文化娱乐场所",
        "体育项目经营场所","公园、风景区","安全监管监察部门",
        "其他"
        ]
  
       var expertInfoModels = [ExpertInfoModel]()
    // 是否加载更多
    private var toLoadMore = false
    //信息类型name
    var infoName :String!
    var imgView :UIImageView!
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.whiteColor()
        setNavagation(infoName)
        tableView = getTableView()
        initPage()
        getDatas()

    }
    

    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
        self.tabBarController?.hidesBottomBarWhenPushed = true
        if (tableView.indexPathForSelectedRow != nil) {
            tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow!, animated: true)
        }
    }
 
    func getDatas(){
        var parameters = [String : AnyObject]()
        parameters["expert.category"] = expertCode
        parameters["pagination.pageSize"] = PAGE_SIZE
        parameters["pagination.itemCount"] = currentPage
        parameters["pagination.totalCount"] = totalCount
        NetworkTool.sharedTools.loadExperts(parameters) { (datas, error,totalCount) in
            if error == nil{
                if self.currentPage>totalCount{
                    //self.showHint("已经到最后了", duration: 2, yOffset: 0)
                    self.currentPage -= 10
                    return
                }
                
                self.toLoadMore = false
                self.expertInfoModels += datas!
                self.tableView.reloadData()
            }else{
                // 获取数据失败后
                self.currentPage -= 10
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
    
    func initPage(){

        // self.navigationController?.navigationBar.alpha = CGFloat(0.5)
        imgView = UIImageView(frame: CGRectMake(0, 0, SCREEN_WIDTH, 210))
        imgView.image = UIImage(named: "icon_title_aqsc_bg")
        customView1 = DetailCellView(frame:CGRectMake(0, 210, SCREEN_WIDTH, 45))
        customView1.setLabelName("专家类别：")
        customView1.setRRightLabel(getExpertTypeCode(expertCode))
        customView1.rightLabel.textColor = UIColor.blackColor()
        customView1.addOnClickListener(self, action: #selector(self.choiceExpertType))

        self.view.addSubview(tableView)
        self.view.addSubview(imgView)
        self.view.addSubview(customView1)
    }
    
    func choiceExpertType(){
        
        UsefulPickerView.showSingleColPicker("请选择", data: expertType, defaultSelectedIndex: 1) {[unowned self] (selectedIndex, selectedValue) in
            self.customView1.setRRightLabel(selectedValue)
            self.expertCode = getExpertTypeCode(self.customView1.rightLabel.text!)
            self.getDatas()
        }
        
    }
    

  
    
 
    
    //为表视图单元格提供数据，该方法是必须实现的方法
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(InfoListReuseIdentifier, forIndexPath: indexPath) as! InfoDemoCell
        let count = expertInfoModels.count ?? 0
        if count > 0 {
            let info = expertInfoModels[indexPath.row]
            cell.expertInfoModel = info
        }
        if count > 0 && indexPath.row == count-1 && !toLoadMore{
            toLoadMore = true
            currentPage += 10
            getDatas()
        }
        return cell
    }
    

    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    //返回某个节中的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        //        return listVideos.count
        return expertInfoModels.count ?? 0
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
       let expertInfoModel = expertInfoModels[indexPath.row]
        let controller = ExpertDetailController()
        controller.expertInfoModel  = expertInfoModel
        self.navigationController?.pushViewController(controller, animated: true)
    }

    
    /**
     *  创建UITableView
     */
    func getTableView() -> UITableView{
        
        if tableView == nil{
            tableView = UITableView(frame: CGRectMake(0, 190, SCREEN_WIDTH, SCREEN_HEIGHT), style: UITableViewStyle.Plain)
            let nib = UINib(nibName: "InfoDemoCell",bundle: nil)
            self.tableView.registerNib(nib, forCellReuseIdentifier: InfoListReuseIdentifier)
            tableView?.delegate = self
            tableView?.dataSource = self
            tableView?.showsHorizontalScrollIndicator = false
            tableView?.showsVerticalScrollIndicator = false
            tableView.rowHeight = 53;
            tableView.separatorStyle = .None
            tableView.tableFooterView = UIView()
            
        }
        
        return tableView!
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
        expertInfoModels.removeAll()
        expertInfoModels = [ExpertInfoModel]()
    }
}
