//
//  CpyInfoController.swift
//  ZhiAnTongCpy
//
//  Created by Ricky on 2017/2/6.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//

import UIKit
import Charts
class SecurityCheckController: BaseViewController ,ChartViewDelegate,UIActionSheetDelegate{
    var  cpyInfoModal = CompanyInfoModel()
    var dataModel : ChartModel!
    var converyModels  = CheckListVo()
    @IBOutlet weak var chartView: BarChartView!
    
    @IBOutlet weak var labelQyzc: UILabel!
    @IBOutlet weak var labelZfpc: UILabel!
    @IBOutlet weak var labelWzg: UILabel!
     var mCountModels = [McountModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavagation("安全检查")
        let rightBar = UIBarButtonItem(title: "刷新", style: UIBarButtonItemStyle.Done, target: self, action: #selector(self.refresh))
        self.navigationItem.rightBarButtonItem = rightBar
        initChartView()
        getCpyInfo()

    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
    }
    
    func getCpyInfo(){
        let parameters = [String : AnyObject]()
        NetworkTool.sharedTools.loadCompanyInfo(parameters) { (data, error) in
            if error == nil{
                self.cpyInfoModal = data
                AppTools.setNSUserDefaultsValue("companyId", String(self.cpyInfoModal.id))
                self.setData()
                self.getData()
            }else{
                self.showHint("\(error)", duration: 2, yOffset: 0)
                if error == NOTICE_SECURITY_NAME {
                      self.toLogin()
                }
            }
        }
    }
    
    func getData(){
  
        
        var parameters = [String : AnyObject]()

          parameters["company.id"] = self.cpyInfoModal.id
        
        NetworkTool.sharedTools.loadCpyCount(parameters) { (data, error) in
            
            if error == nil{
                self.dataModel = data!
                self.labelQyzc.text = "企业自查隐患数量"+self.dataModel.dangerCom+"个"
                self.labelZfpc.text = "政府排查隐患数量"+self.dataModel.dangerGov+"个"
                self.labelWzg.text = "未整改隐患数量"+self.dataModel.unDangerNum+"个"
                self.mCountModels = self.dataModel.mcountModels
                self.setChartData()

            }else{
                self.showHint("\(error)", duration: 2, yOffset: 0)
                if error == NOTICE_SECURITY_NAME {
                    self.toLogin()
                }
                
            }
            
        }
        
    }
    func initChartView(){
        chartView.barData
        chartView.delegate = self
        chartView.descriptionText=""
        chartView.noDataTextDescription="获取数据失败，请稍后再试"
        //图表是否可触摸
        chartView.multipleTouchEnabled = false
        //是否可拖拽
        chartView.dragEnabled = false
        //是否可缩放
        chartView.setScaleEnabled(false)
        //双指缩放
        chartView.pinchZoomEnabled = false
        //隐藏右边坐标轴
        chartView.rightAxis.enabled = false
        //显示左边坐标轴
        chartView.leftAxis.enabled = true
        //图表背景色
        chartView.backgroundColor = UIColor.lightGrayColor()
        //设置X轴
        let xAxis = chartView.xAxis
        xAxis.labelPosition = ChartXAxis.LabelPosition.Bottom
        xAxis.drawGridLinesEnabled = true
        xAxis.spaceBetweenLabels = 2
        let leftAxis = chartView.leftAxis
        leftAxis.axisMaxValue = 20
        leftAxis.labelCount = 4
        
    }
    
    var months : [String] = []
    //1.定义数组
    var valuesYh: [Double] = [] //隐患数量
    var valuesZg: [Double] = []; //整改数量
    
    func setChartData() {
        months.removeAll()
        valuesYh.removeAll()
        valuesZg.removeAll()
        //转换数据
        for item in mCountModels{
            let month = item.dateMonth.substringFromIndex(item.dateMonth.startIndex.advancedBy(3))+"月"
            months.append(month)
            valuesYh.append(Double(item.dangerNum))
            valuesZg.append(Double(item.repairedDanger))
            
        }
        
        var dataEntriesYh: [BarChartDataEntry] = []
        for i in 0..<valuesYh.count {
            let dataEntry = BarChartDataEntry(value: valuesYh[i], xIndex: i)
            dataEntriesYh.append(dataEntry)
        }
        
        var dataEntriesZg: [BarChartDataEntry] = []
        for i in 0..<valuesZg.count {
            let dataEntry = BarChartDataEntry(value: valuesZg[i], xIndex: i)
            dataEntriesZg.append(dataEntry)
        }
        
        let sortArray = valuesYh.sort(){ $1 < $0 }
        let leftAxis = chartView.leftAxis
        //设置y轴数字
        leftAxis.axisMaxValue = sortArray[0]*1.1
        
        let chartDataSet = BarChartDataSet(yVals: dataEntriesYh, label: "隐患数量")
        let chartDataSet1 = BarChartDataSet(yVals: dataEntriesZg, label: "整改数量")
        chartDataSet.colors = [ UIColor.blueColor()]
        chartDataSet1.colors = [UIColor.yellowColor()]
        
        //创建数组
        //        var chartDataSets = [BarChartDataSet]()
        //        chartDataSets.append(chartDataSet)
        //        chartDataSets.append(chartDataSet1)
        // 加上动画
        chartView.animate(yAxisDuration: 1.0, easingOption: .EaseInBounce)
        //赋值  xVals x轴数据    dataSet 图标内值
        
        let chartData = BarChartData(xVals: months, dataSet: chartDataSet)
        chartData.addDataSet(chartDataSet1)
        chartView.data = chartData
        
    }

    func refresh(){
       getData()
//       self.navigationController?.pushViewController(TestController(), animated: true)

        
    }
    
    func setData(){
        self.converyModels.companyId = String(self.cpyInfoModal.id)
        self.converyModels.companyname = self.cpyInfoModal.companyName
        self.converyModels.companyadress = self.cpyInfoModal.address
        self.converyModels.fdDelegate = self.cpyInfoModal.fdDelegate
        self.converyModels.businessRegNumber  = self.cpyInfoModal.businessRegNumber
    }
    
    @IBAction func yhllClick(sender: AnyObject) {
        let controller = RecordHideenPassController()
        controller.converyModels = converyModels
        controller.titleName = "隐患录入"
     self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func aqjcClick(sender: AnyObject) {
        let controller = SecCheckListController()
        controller.companyId = String(self.cpyInfoModal.id)
        controller.passType = "1"
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    @IBAction func yhzgClick(sender: AnyObject) {
        let controller = RecordHideenPassController()
        controller.converyModels = converyModels
        controller.titleName = "隐患整改"
        controller.repairId = "4"
        controller.isGorover = "0"
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func jcbClick(sender: AnyObject) {
        let controller = SecCheckListController()
        controller.companyId = String(self.cpyInfoModal.id)
        controller.passType = "2"
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func lsjlClick(sender: AnyObject) {
        let controller = HistoryRecordController()
        controller.converyModels = converyModels
        controller.companyId = String(self.cpyInfoModal.id)
        self.navigationController?.pushViewController(controller, animated: true)
    }
  
}
