//
//  ViewController.swift
//  XBPrint
//
//  Created by xiaobin liu on 16/3/24.
//  Copyright © 2016年 Sky. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController,XBPrintInstructionProtocol {

    var bluetoothManager = XBBluetoothManager()
    
    lazy var tableView: UITableView = {
        
        let temporaryTableView = UITableView()
        temporaryTableView.backgroundColor = UIColor.whiteColor()
        temporaryTableView.backgroundView = nil
        temporaryTableView.dataSource = self
        temporaryTableView.delegate = self
        temporaryTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: String(UITableViewCell.self))
        return temporaryTableView
    }()
    
    
    lazy var searchButton: UIButton = {
        let temporaryButton = UIButton(type: .Custom)
        temporaryButton.bounds = CGRectMake(0, 0, 80, 50)
        temporaryButton.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0)
        temporaryButton.setTitle("搜索中", forState: .Normal)
        temporaryButton.setTitle("停止搜索", forState: .Selected)
        temporaryButton.setTitleColor(UIColor.redColor(), forState: .Normal)
        temporaryButton.setTitleColor(UIColor.redColor(), forState: .Selected)
        return  temporaryButton
    }()
    
    
    lazy var printButton: UIButton = {
        let temporaryButton = UIButton(type: .Custom)
        temporaryButton.bounds = CGRectMake(0, 0, 80, 50)
        temporaryButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -30)
        temporaryButton.setTitle("打印", forState: .Normal)
        temporaryButton.setTitleColor(UIColor.redColor(), forState: .Normal)
        temporaryButton.setTitleColor(UIColor.redColor(), forState: .Selected)
        return  temporaryButton
    }()
    
    
    //搜索到的打印机数组
    var printerArrary: [CBPeripheral]?
    
    
    //点击搜索按钮
    func chickButton(sender: UIButton) {
        if sender.selected {
            sender.selected = false
            bluetoothManager.startScan()
            
        } else {
            sender.selected = true
            bluetoothManager.stopScan()
        }
    }
    
    
    //打印
    func print() {
        
        let printTemplate = PrintTemplate(storeName: "米客互联(福建总部)", number: "A001", tableType: TableType.tableForTwo, waiting: "您前面还有:0桌在等候", time: "排队时间:03月26日10时10分", phone: "餐厅电话:13696888888", qrcode: "www.chidaoni.com")
        for peripheral in printerArrary! {
            if peripheral.state == .Connected {
                
                
                let cfEnc = CFStringEncodings.GB_18030_2000
                let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEnc.rawValue))
                
                //打印商家名称
                let cmmStoreNameData = NSMutableData.init()
                cmmStoreNameData.appendData(printerInitialize)
                cmmStoreNameData.appendData(printerModel(0))
                cmmStoreNameData.appendData(printerCharacterSize(1))
                cmmStoreNameData.appendData(printerAlignment(1))
                let storeNameData = printTemplate.storeName.dataUsingEncoding(enc)
                cmmStoreNameData.appendData(storeNameData!)
                cmmStoreNameData.appendData(printerPaperFeed(2))
                bluetoothManager.writeValue(peripheral, data: cmmStoreNameData)
                
                
                //打印排队号码以及桌子类型
                let cmmNumberData = NSMutableData.init()
                cmmNumberData.appendData(printerInitialize)
                cmmNumberData.appendData(printerCharacterSize(17))
                let numberData = printTemplate.number.dataUsingEncoding(enc)
                cmmNumberData.appendData(numberData!)
                cmmNumberData.appendData(printerModel(0))
                cmmNumberData.appendData(printerCharacterSize(0))
                cmmNumberData.appendData(printerAlignment(1))
                let  tableTypeData = printTemplate.tableType.tableName.dataUsingEncoding(enc)
                cmmNumberData.appendData(tableTypeData!)
                cmmNumberData.appendData(printerPaperFeed(2))
                bluetoothManager.writeValue(peripheral, data: cmmNumberData)
                
                
                //打印等待人数
                let cmmWaitingData = NSMutableData.init()
                cmmWaitingData.appendData(printerInitialize)
                cmmWaitingData.appendData(printerModel(0))
                cmmWaitingData.appendData(printerCharacterSize(0))
                cmmWaitingData.appendData(printerLeftSpacing(50, nH: 0))
                let  waitingData = printTemplate.waiting.dataUsingEncoding(enc)
                cmmWaitingData.appendData(waitingData!)
                cmmWaitingData.appendData(printerPaperFeed(1))
                bluetoothManager.writeValue(peripheral, data: cmmWaitingData)
                
                
                //打印时间
                let cmmTimeData = NSMutableData.init()
                cmmTimeData.appendData(printerInitialize)
                cmmTimeData.appendData(printerModel(0))
                cmmTimeData.appendData(printerCharacterSize(0))
                cmmTimeData.appendData(printerLeftSpacing(50, nH: 0))
                let  timeData = printTemplate.time.dataUsingEncoding(enc)
                cmmTimeData.appendData(timeData!)
                cmmTimeData.appendData(printerPaperFeed(1))
                bluetoothManager.writeValue(peripheral, data: cmmTimeData)
                
                
                
                //打印电话号码
                let cmmPhoneData = NSMutableData.init()
                cmmPhoneData.appendData(printerInitialize)
                cmmPhoneData.appendData(printerModel(0))
                cmmPhoneData.appendData(printerCharacterSize(0))
                cmmPhoneData.appendData(printerLeftSpacing(50, nH: 0))
                let  phoneData = printTemplate.phone.dataUsingEncoding(enc)
                cmmPhoneData.appendData(phoneData!)
                cmmPhoneData.appendData(printerPaperFeed(2))
                bluetoothManager.writeValue(peripheral, data: cmmPhoneData)
                
                
                //打印二维码
                let cmmQrCodeData = NSMutableData.init()
                cmmQrCodeData.appendData(printerInitialize)
                cmmQrCodeData.appendData(printerLeftSpacing(50, nH: 0))
                if peripheral.name!.hasPrefix("D") {
                    cmmQrCodeData.appendData(printerQRCode(printTemplate.qrcode))
                } else if peripheral.name!.hasPrefix("G") {
                  cmmQrCodeData.appendData(printerQRCode(12, ecc: 48, qrcode: printTemplate.qrcode))
                }
                cmmQrCodeData.appendData(printerPaperFeed(1))
                bluetoothManager.writeValue(peripheral, data: cmmQrCodeData)
                
                
                //广告语
                let cmmAdvertisingData = NSMutableData.init()
                cmmAdvertisingData.appendData(printerInitialize)
                cmmAdvertisingData.appendData(printerModel(0))
                cmmAdvertisingData.appendData(printerCharacterSize(0))
                cmmAdvertisingData.appendData(printerLeftSpacing(50, nH: 0))
                let  advertisingData = printTemplate.advertising.dataUsingEncoding(enc)
                cmmAdvertisingData.appendData(advertisingData!)
                cmmAdvertisingData.appendData(printerPaperFeed(1))
                bluetoothManager.writeValue(peripheral, data: cmmAdvertisingData)
                
                
                //线
                let cmmLineData = NSMutableData.init()
                cmmLineData.appendData(printerInitialize)
                cmmLineData.appendData(printerModel(0))
                cmmLineData.appendData(printerCharacterSize(0))
                let  lineData = "--------------------------------".dataUsingEncoding(enc)
                cmmLineData.appendData(lineData!)
                cmmLineData.appendData(printerPaperFeed(1))
                bluetoothManager.writeValue(peripheral, data: cmmLineData)
                
                
                //技术支持
                let cmmTechnicalSupportData = NSMutableData.init()
                cmmTechnicalSupportData.appendData(printerInitialize)
                cmmTechnicalSupportData.appendData(printerModel(0))
                cmmTechnicalSupportData.appendData(printerCharacterSize(0))
                cmmTechnicalSupportData.appendData(printerLeftSpacing(50, nH: 0))
                let  technicalSupportData = printTemplate.technicalSupport.dataUsingEncoding(enc)
                cmmTechnicalSupportData.appendData(technicalSupportData!)
                cmmTechnicalSupportData.appendData(printerPaperFeed(5))
                bluetoothManager.writeValue(peripheral, data: cmmTechnicalSupportData)
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "蓝牙打印机"
        self.view.backgroundColor = UIColor.whiteColor()
        
        tableView.frame = view.frame
        view.addSubview(tableView)
        
        searchButton.addTarget(self, action: #selector(ViewController.chickButton(_:)), forControlEvents: .TouchUpInside)
        let leftBarButtonItem = UIBarButtonItem(customView: searchButton)
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        
        printButton.addTarget(self, action: #selector(ViewController.print), forControlEvents: .TouchUpInside)
        let rightBarButtonItem = UIBarButtonItem(customView: printButton)
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        bluetoothManager.delegate = self
        bluetoothManager.startScan()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// MARK: - <#UITableViewDataSource#>
extension ViewController: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return printerArrary?.count ?? 0
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "选择打印机"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(UITableViewCell.self))!
        let peripheral = printerArrary![indexPath.row]
        cell.textLabel?.text = peripheral.name
        
        let rightLabel = UILabel(frame: CGRectMake(0,0,70,20))
        rightLabel.textColor = UIColor.redColor()
            
        if peripheral.state == .Connected {
            rightLabel.text = "已连接"
        } else if peripheral.state == .Connecting {
            rightLabel.text = "连接中"
        } else {
            rightLabel.text = "未连接"
        }
        cell.accessoryView = rightLabel
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let peripheral = printerArrary![indexPath.row]
        bluetoothManager.connectPeripheral(peripheral)
        self.tableView.reloadData()
    }
}


// MARK: - <#XBBluetoothCenterDelegate#>
extension ViewController: XBBluetoothCenterDelegate {
    
    func bluetoothCenterOff() {
        debugPrint("蓝牙关闭")
    }
    
    func bluetoothCenterOn() {
        debugPrint("蓝牙开着")
    }
    
    
    func bluetoothCenter(central: CBCentralManager, didDiscoverPeripheral peripheralArray: [CBPeripheral]) {
        self.printerArrary = peripheralArray
        tableView.reloadData()
    }
    
    func bluetoothCenter(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        debugPrint("连接设备成功")
        self.tableView.reloadData()
    }
    
    func bluetoothCenter(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        self.tableView.reloadData()
        debugPrint("断开外设方法")
    }
    
    
    func bluetoothCenter(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        debugPrint("连接设备失败")
    }
    
    
    func bluetoothCenter(peripheral: CBPeripheral, didWriteValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        
        if let error = error {
            debugPrint("打印失败\(error)")
        } else {
            debugPrint("打印成功")
        }
        
    }
}


