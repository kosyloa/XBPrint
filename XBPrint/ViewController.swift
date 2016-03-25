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
        temporaryButton.setTitle("搜索中", forState: .Normal)
        temporaryButton.setTitle("停止搜索", forState: .Selected)
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
        let cmmData = NSMutableData.init()
        cmmData.appendData(printerState())
//        cmmData.appendData(printerModel(1))
//        cmmData.appendByte(27)
//        cmmData.appendByte(77)
//        cmmData.appendByte(49)
//        cmmData.appendByte(0x1B)
//        cmmData.appendByte(0x61)
//        cmmData.appendByte(0x01)
        
        
//        let cfEnc = CFStringEncodings.GB_18030_2000
//        let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEnc.rawValue))
//        let data = "Swift测试打印".dataUsingEncoding(enc)
//        cmmData.appendData(data!)
//        bluetoothManager.writeValue(cmmData)
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
    
}


