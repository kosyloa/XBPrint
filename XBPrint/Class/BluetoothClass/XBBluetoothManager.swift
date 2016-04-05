//
//  XBBluetoothManager.swift
//  XBPrint
//
//  Created by xiaobin liu on 16/3/24.
//  Copyright © 2016年 Sky. All rights reserved.
//

import Foundation
import CoreBluetooth

/// 蓝牙助手类
public class XBBluetoothManager: NSObject {
    
    //委托
    weak var delegate: XBBluetoothCenterDelegate!
    
    //外设以及特征
    private var peripheral = [CBPeripheral:CBCharacteristic?]()
    
    
    //搜索到的外围设备对象集合
    lazy var peripheralArray: [CBPeripheral] = {
       return [CBPeripheral]()
    }()
    
    
    //蓝牙中央管理对象(目前只支持前台模式,暂时不支持后台模式)
    lazy var centralManager: CBCentralManager = { [unowned self] () -> CBCentralManager in
        CBCentralManager.init(delegate: self, queue: nil)
        }()
    
    
    //开始扫描
    public func startScan() {
        let options = [CBCentralManagerOptionShowPowerAlertKey:true]
        centralManager.scanForPeripheralsWithServices(nil, options: options)
    }
    
    //停止扫描
    public func stopScan() {
        peripheralArray.removeAll()
        centralManager.stopScan()
    }
    
    //连接外围设备
    public func connectPeripheral(peripheral: CBPeripheral) {
        centralManager.connectPeripheral(peripheral, options: nil)
    }
    
    //断开外围设备
    public func cancelPeripheralConnection(peripheral: CBPeripheral) {
       centralManager.cancelPeripheralConnection(peripheral)
    }
    
    //写入数据
    public func writeValue(peripheral: CBPeripheral, data: NSData) {
        if let characteristic = self.peripheral[peripheral] {
           peripheral.setNotifyValue(true, forCharacteristic: characteristic!)
           peripheral.writeValue(data, forCharacteristic: characteristic!, type: .WithResponse)
        }
    }
    
    //添加外围设备
    func addPeripheral(peripheral: CBPeripheral) {
        if peripheralArray.contains(peripheral) == false {
            peripheralArray.append(peripheral)
        }
    }
}


// MARK: - <#CBCentralManagerDelegate#>
extension XBBluetoothManager: CBCentralManagerDelegate {
    
    //主设备状态改变的委托
    public func centralManagerDidUpdateState(central: CBCentralManager) {
        
        guard let delegate = delegate else {
            return
        }
        
        switch central.state {
        case .Unknown : debugPrint("未知的")
        case .Resetting : debugPrint("重置")
        case .Unsupported : debugPrint("不支持的")
        case .Unauthorized : debugPrint("未经授权")
        case .PoweredOff : if delegate.respondsToSelector(#selector(XBBluetoothCenterDelegate.bluetoothCenterOff)) {
            delegate.bluetoothCenterOff!()
            }
        case .PoweredOn : if delegate.respondsToSelector(#selector(XBBluetoothCenterDelegate.bluetoothCenterOn)) {
               delegate.bluetoothCenterOn!()
            }
            centralManager.scanForPeripheralsWithServices(nil, options: nil)
        }
    }
    
    
    //断开外设的委托
    public func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        
        guard let delegate = delegate else {
            return
        }
        
        //移除
        self.peripheral.removeValueForKey(peripheral)
        
        
        if delegate.respondsToSelector(#selector(XBBluetoothCenterDelegate.bluetoothCenter(_:didDisconnectPeripheral:error:))) {
            delegate.bluetoothCenter!(central, didDisconnectPeripheral: peripheral, error: error)
        }
    }
    
    //连接外设成功的委托
    public func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        guard let delegate = delegate else {
            return
        }
        
        //设置外设代理
        self.peripheral[peripheral] = nil
        peripheral.delegate = self
        //扫描外设Services，成功后会进入方法：-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
        peripheral.discoverServices(nil)
        
        if delegate.respondsToSelector(#selector(XBBluetoothCenterDelegate.bluetoothCenter(_:didConnectPeripheral:))) {
            delegate.bluetoothCenter!(central, didConnectPeripheral: peripheral)
        }
    }
    
    //外设连接失败的委托
    public func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        
        guard let delegate = delegate else {
            return
        }
        
        if delegate.respondsToSelector(#selector(XBBluetoothCenterDelegate.bluetoothCenter(_:didFailToConnectPeripheral:error:))) {
            delegate.bluetoothCenter!(central, didFailToConnectPeripheral: peripheral, error: error)
        }
    }
    
    
    //找到外设的委托
    public func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        
        addPeripheral(peripheral)
        
        guard let delegate = delegate else {
            return
        }
        
        if  delegate.respondsToSelector(#selector(XBBluetoothCenterDelegate.bluetoothCenter(_:didConnectPeripheral:))) {
            delegate.bluetoothCenter!(central, didDiscoverPeripheral: peripheralArray)
        }
    }
}


// MARK: - <#CBPeripheralDelegate#>
extension XBBluetoothManager: CBPeripheralDelegate {
    
    //扫描到Services
    public func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        
        if  let _ = error {
            debugPrint("出错啦")
            return
        }
        
        
        for service in peripheral.services! {
            peripheral.discoverCharacteristics(nil, forService: service)
        }
    }
    
    
    //扫描到Characteristics
    public func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        
        if let _ = error {
            debugPrint("失败")
            return
        }
        
        //获取Characteristic的值，读到数据会进入方法：-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
        for characteristic in service.characteristics! {
            peripheral.readValueForCharacteristic(characteristic)
        }
    }
    
    
    //获取的charateristic的值
    public func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        
        //找到能打印的CBCharacteristic
        if characteristic.properties.rawValue & CBCharacteristicProperties.Write.rawValue > 0 {
            self.peripheral[peripheral] = characteristic
        }
    }
    
    
    //写入成功失败的回调
    public func peripheral(peripheral: CBPeripheral, didWriteValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        
        guard let delegate = delegate else {
            return
        }
        
        if delegate.respondsToSelector(#selector(XBBluetoothCenterDelegate.bluetoothCenter(_:didWriteValueForCharacteristic:error:)))
        {
            delegate.bluetoothCenter!(peripheral, didWriteValueForCharacteristic: characteristic, error: error)
        }
    }
}



