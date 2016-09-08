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



    var bluetoothManager = BluetoothManager()
    
    lazy var tableView: UITableView = {
        
        let temporaryTableView = UITableView()
        temporaryTableView.backgroundColor = UIColor.white
        temporaryTableView.backgroundView = nil
        temporaryTableView.dataSource = self
        temporaryTableView.delegate = self
        temporaryTableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        return temporaryTableView
    }()
    
    
    lazy var searchButton: UIButton = {
        let temporaryButton = UIButton(type: .custom)
        temporaryButton.bounds = CGRect(x: 0, y: 0, width: 80, height: 50)
        temporaryButton.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0)
        temporaryButton.setTitle("搜索中", for: UIControlState())
        temporaryButton.setTitle("停止搜索", for: .selected)
        temporaryButton.setTitleColor(UIColor.red, for: UIControlState())
        temporaryButton.setTitleColor(UIColor.red, for: .selected)
        return  temporaryButton
    }()
    
    
    lazy var printButton: UIButton = {
        let temporaryButton = UIButton(type: .custom)
        temporaryButton.bounds = CGRect(x: 0, y: 0, width: 80, height: 50)
        temporaryButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -30)
        temporaryButton.setTitle("打印", for: UIControlState())
        temporaryButton.setTitleColor(UIColor.red, for: UIControlState())
        temporaryButton.setTitleColor(UIColor.red, for: .selected)
        return  temporaryButton
    }()
    
    
    //搜索到的打印机数组
    var printerArrary: [CBPeripheral]?
    
    
    //点击搜索按钮
    func chickButton(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            bluetoothManager.startScan()
            
        } else {
            sender.isSelected = true
            bluetoothManager.stopScan()
        }
    }
    
    
    //打印
    func print() {
        
        let printTemplate = PrintTemplate(storeName: "米客互联(福建总部)", number: "A001", tableType: TableType.tableForTwo, waiting: "您前面还有:0桌在等候", time: "排队时间:03月26日10时10分", phone: "餐厅电话:13696888888", qrcode: "www.chidaoni.com")
        for peripheral in printerArrary! {
            if peripheral.state == .connected {
                
                
                let cfEnc = CFStringEncodings.GB_18030_2000
                let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEnc.rawValue))
                
                //打印商家名称
                var cmmStoreNameData = Data()
                cmmStoreNameData.append(printerInitialize)
                cmmStoreNameData.append(printer(model:0))
                cmmStoreNameData.append(printer(characterSize: 1))
                cmmStoreNameData.append(printer(alignment: 1))
                let storeNameData = printTemplate.storeName.data(using: String.Encoding(rawValue: enc))
                cmmStoreNameData.append(storeNameData!)
                cmmStoreNameData.append(printer(paperFeed: 2))
                bluetoothManager.writeValue(peripheral, data: cmmStoreNameData as Data)
                
                
                //打印排队号码以及桌子类型
                var cmmNumberData = Data()
                cmmNumberData.append(printerInitialize)
                cmmNumberData.append(printer(characterSize: 17))
                let numberData = printTemplate.number.data(using: String.Encoding(rawValue: enc))
                
                cmmNumberData.append(numberData!)
                cmmNumberData.append(printer(model:0))
                cmmNumberData.append(printer(characterSize: 0))
                cmmNumberData.append(printer(alignment: 1))
                
                let  tableTypeData = printTemplate.tableType.tableName.data(using: String.Encoding(rawValue: enc))
                cmmNumberData.append(tableTypeData!)
                cmmNumberData.append(printer(paperFeed: 2))
                bluetoothManager.writeValue(peripheral, data: cmmNumberData)
                
                
                //打印等待人数
                var cmmWaitingData = Data()
                cmmWaitingData.append(printerInitialize as Data)
                cmmWaitingData.append(printer(model: 0))
                cmmWaitingData.append(printer(characterSize: 0))
                cmmWaitingData.append(printerLeftSpacing(50, nH: 0))
                let  waitingData = printTemplate.waiting.data(using: String.Encoding(rawValue: enc))
                cmmWaitingData.append(waitingData!)
                cmmWaitingData.append(printer(paperFeed: 1))
                bluetoothManager.writeValue(peripheral, data: cmmWaitingData)
                
                
                //打印时间
                var cmmTimeData = Data()
                cmmTimeData.append(printerInitialize)
                cmmTimeData.append(printer(model: 0))
                cmmTimeData.append(printer(characterSize: 0))
                cmmTimeData.append(printerLeftSpacing(50, nH: 0))
                let  timeData = printTemplate.time.data(using: String.Encoding(rawValue: enc))
                cmmTimeData.append(timeData!)
                cmmTimeData.append(printer(paperFeed: 1))
                bluetoothManager.writeValue(peripheral, data: cmmTimeData)
                
                
                
                //打印电话号码
                var cmmPhoneData = Data()
                cmmPhoneData.append(printerInitialize)
                cmmPhoneData.append(printer(model: 0))
                cmmPhoneData.append(printer(characterSize: 0))
                cmmPhoneData.append(printerLeftSpacing(50, nH: 0))
                let  phoneData = printTemplate.phone.data(using: String.Encoding(rawValue: enc))
                cmmPhoneData.append(phoneData!)
                cmmPhoneData.append(printer(paperFeed: 2))
                bluetoothManager.writeValue(peripheral, data: cmmPhoneData)
                
                
                //打印二维码
                var cmmQrCodeData = Data()
                cmmQrCodeData.append(printerInitialize)
                cmmQrCodeData.append(printerLeftSpacing(50, nH: 0))
                if peripheral.name!.hasPrefix("D") {
                    cmmQrCodeData.append(printer(qrcode: printTemplate.qrcode))
                } else if peripheral.name!.hasPrefix("G") {
                  cmmQrCodeData.append(printerQRCode(12, ecc: 48, qrcode: printTemplate.qrcode))
                }
                cmmQrCodeData.append(printer(paperFeed: 1))
                bluetoothManager.writeValue(peripheral, data: cmmQrCodeData)
                
                
                //广告语
                var cmmAdvertisingData = Data()
                cmmAdvertisingData.append(printerInitialize)
                cmmAdvertisingData.append(printer(model: 0))
                cmmAdvertisingData.append(printer(characterSize: 0))
                cmmAdvertisingData.append(printerLeftSpacing(50, nH: 0))
                let  advertisingData = printTemplate.advertising.data(using: String.Encoding(rawValue: enc))
                cmmAdvertisingData.append(advertisingData!)
                cmmAdvertisingData.append(printer(paperFeed: 1))
                bluetoothManager.writeValue(peripheral, data: cmmAdvertisingData)
                
                
                //线
                var cmmLineData = Data()
                cmmLineData.append(printerInitialize)
                cmmLineData.append(printer(model: 0))
                cmmLineData.append(printer(characterSize: 0))
                let  lineData = "--------------------------------".data(using: String.Encoding(rawValue: enc))
                cmmLineData.append(lineData!)
                cmmLineData.append(printer(paperFeed: 1))
                bluetoothManager.writeValue(peripheral, data: cmmLineData)
                
                
                //技术支持
                var cmmTechnicalSupportData = Data()
                cmmTechnicalSupportData.append(printerInitialize)
                cmmTechnicalSupportData.append(printer(model: 0))
                cmmTechnicalSupportData.append(printer(characterSize: 0))
                cmmTechnicalSupportData.append(printerLeftSpacing(50, nH: 0))
                let  technicalSupportData = printTemplate.technicalSupport.data(using: String.Encoding(rawValue: enc))
                cmmTechnicalSupportData.append(technicalSupportData!)
                cmmTechnicalSupportData.append(printer(paperFeed: 5))
                bluetoothManager.writeValue(peripheral, data: cmmTechnicalSupportData)
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "蓝牙打印机"
        self.view.backgroundColor = UIColor.white
        
        tableView.frame = view.frame
        view.addSubview(tableView)
        
        searchButton.addTarget(self, action: #selector(ViewController.chickButton(_:)), for: .touchUpInside)
        let leftBarButtonItem = UIBarButtonItem(customView: searchButton)
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        
        printButton.addTarget(self, action: #selector(ViewController.print), for: .touchUpInside)
        let rightBarButtonItem = UIBarButtonItem(customView: printButton)
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return printerArrary?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "选择打印机"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))!
        let peripheral = printerArrary![(indexPath as NSIndexPath).row]
        cell.textLabel?.text = peripheral.name
        
        let rightLabel = UILabel(frame: CGRect(x: 0,y: 0,width: 70,height: 20))
        rightLabel.textColor = UIColor.red
            
        if peripheral.state == .connected {
            rightLabel.text = "已连接"
        } else if peripheral.state == .connecting {
            rightLabel.text = "连接中"
        } else {
            rightLabel.text = "未连接"
        }
        cell.accessoryView = rightLabel
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let peripheral = printerArrary![(indexPath as NSIndexPath).row]
        bluetoothManager.connectPeripheral(peripheral)
        self.tableView.reloadData()
    }
}


// MARK: - <#XBBluetoothCenterDelegate#>
extension ViewController: BluetoothCenterDelegate {
    
    func bluetoothCenterOff() {
        debugPrint("蓝牙关闭")
    }
    
    func bluetoothCenterOn() {
        debugPrint("蓝牙开着")
    }
    
    func bluetoothCenter(_ central: CBCentralManager, didDiscoverPeripheral peripheralArray: [CBPeripheral]) {
        self.printerArrary = peripheralArray
        tableView.reloadData()
    }
    
    func bluetoothCenter(_ central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        debugPrint("连接设备成功")
        self.tableView.reloadData()
    }
    
    func bluetoothCenter(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        self.tableView.reloadData()
        debugPrint("断开外设方法")
    }
    
    
    func bluetoothCenter(_ central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        debugPrint("连接设备失败")
    }
    
    
    func bluetoothCenter(_ peripheral: CBPeripheral, didWriteValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        
        if let error = error {
            debugPrint("打印失败\(error)")
        } else {
            debugPrint("打印成功")
        }
    }
}


