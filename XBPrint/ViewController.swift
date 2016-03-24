//
//  ViewController.swift
//  XBPrint
//
//  Created by xiaobin liu on 16/3/24.
//  Copyright © 2016年 Sky. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController {

    var bluetoothManager = XBBluetoothManager()
    
    var peripheral: CBPeripheral?
    
    var characteristic: CBCharacteristic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "蓝牙"
        self.view.backgroundColor = UIColor.whiteColor()
        bluetoothManager.delegate = self
        bluetoothManager.startScan()
        
        
        let button = UIButton(type: .Custom)
        button.frame = CGRectMake(0, 0, 50,50)
        button.backgroundColor = UIColor.redColor()
        button.center = view.center
        button.addTarget(self, action: #selector(ViewController.printer), forControlEvents: .TouchUpInside)
        view.addSubview(button)
    }
    
    
    func printer() {
        let cmmData = NSMutableData.init()
        cmmData.appendByte(0x1b)
        cmmData.appendByte(0x40)
        cmmData.appendByte(0x1d)
        cmmData.appendByte(0x21)
        cmmData.appendByte(0x01)
        cmmData.appendByte(27)
        cmmData.appendByte(77)
        cmmData.appendByte(49)
        cmmData.appendByte(0x1B)
        cmmData.appendByte(0x61)
        cmmData.appendByte(0x01)
        
        
        let cfEnc = CFStringEncodings.GB_18030_2000
        let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEnc.rawValue))
        let data = "Swift测试打印 \n".dataUsingEncoding(enc)
        cmmData.appendData(data!)
        self.peripheral?.writeValue(cmmData, forCharacteristic: self.characteristic!, type: .WithoutResponse)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

// MARK: - <#XBBluetoothCenterDelegate#>
extension ViewController: XBBluetoothCenterDelegate {
    
    func bluetoothCenterOff() {
        debugPrint("蓝牙关闭")
    }
    
    func bluetoothCenterOn() {
        debugPrint("蓝牙开")
    }
    
    func bluetoothCenter(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, RSSI: NSNumber) {
        debugPrint(bluetoothManager.peripheralArray.count)
        
        if peripheral.name!.hasPrefix("D") {
            self.peripheral = peripheral
            bluetoothManager.connectPeripheral(peripheral)
            bluetoothManager.stopScan()
        }
    }
    
    func bluetoothCenter(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        debugPrint("连接设备成功")
        
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    func bluetoothCenter(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        debugPrint("断开外设方法")
    }
    
    func bluetoothCenter(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        debugPrint("连接设备失败")
    }
    
}


// MARK: - <#CBPeripheralDelegate#>
extension ViewController: CBPeripheralDelegate {
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        
        if  let _ = error {
            print("出错啦")
            return
        }
        
        
        for service in peripheral.services! {
            peripheral.discoverCharacteristics(nil, forService: service)
        }
    }
    
    //扫描到Characteristics
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        
        if let _ = error {
            print("失败")
            return
        }
        
        
        //获取Characteristic的值，读到数据会进入方法：-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
        for characteristic in service.characteristics! {
            peripheral.readValueForCharacteristic(characteristic)
        }
        
        //搜索Characteristic的Descriptors，读到数据会进入方法：-(void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
        for characteristic in service.characteristics! {
            peripheral.discoverDescriptorsForCharacteristic(characteristic)
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        
        //找到能打印的CBCharacteristic
        if characteristic.properties.rawValue & CBCharacteristicProperties.Write.rawValue > 0 {
            self.characteristic = characteristic
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverDescriptorsForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        if characteristic.properties == .Write {
            self.characteristic = characteristic
            print("成功找到可以输出的权限")
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didWriteValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        print(characteristic)
    }
}



extension NSMutableData {
    func appendByte(b: UInt8) {
        var a = b
        self.appendBytes(&a, length: 1)
    }
}

