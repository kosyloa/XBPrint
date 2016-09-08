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
open class BluetoothManager: NSObject {
    
    //委托
    weak var delegate: BluetoothCenterDelegate!
    
    //外设以及特征
    fileprivate var peripheral = [CBPeripheral:CBCharacteristic?]()
    
    
    //搜索到的外围设备对象集合
    lazy var peripheralArray: [CBPeripheral] = {
       return [CBPeripheral]()
    }()
    
    
    //蓝牙中央管理对象(目前只支持前台模式,暂时不支持后台模式)
    lazy var centralManager: CBCentralManager = { [unowned self] () -> CBCentralManager in
        CBCentralManager.init(delegate: self, queue: nil)
        }()
    
    
    //开始扫描
    open func startScan() {
        let options = [CBCentralManagerOptionShowPowerAlertKey:true]
        centralManager.scanForPeripherals(withServices: nil, options: options)
    }
    
    //停止扫描
    open func stopScan() {
        peripheralArray.removeAll()
        centralManager.stopScan()
    }
    
    //连接外围设备
    open func connectPeripheral(_ peripheral: CBPeripheral) {
        centralManager.connect(peripheral, options: nil)
    }
    
    //断开外围设备
    open func cancelPeripheralConnection(_ peripheral: CBPeripheral) {
       centralManager.cancelPeripheralConnection(peripheral)
    }
    
    //写入数据
    open func writeValue(_ peripheral: CBPeripheral, data: Data) {
        if let characteristic = self.peripheral[peripheral] {
           peripheral.setNotifyValue(true, for: characteristic!)
           peripheral.writeValue(data, for: characteristic!, type: .withResponse)
        }
    }
    
    //添加外围设备
    func addPeripheral(_ peripheral: CBPeripheral) {
        if peripheralArray.contains(peripheral) == false {
            peripheralArray.append(peripheral)
        }
    }
}


// MARK: - <#CBCentralManagerDelegate#>
extension BluetoothManager: CBCentralManagerDelegate {
    
    //主设备状态改变的委托
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        guard let delegate = delegate else {
            return
        }
        
        switch central.state {
        case .unknown : debugPrint("未知的")
        case .resetting : debugPrint("重置")
        case .unsupported : debugPrint("不支持的")
        case .unauthorized : debugPrint("未经授权")
        case .poweredOff : if delegate.responds(to: #selector(BluetoothCenterDelegate.bluetoothCenterOff)) {
            delegate.bluetoothCenterOff!()
            }
        case .poweredOn : if delegate.responds(to: #selector(BluetoothCenterDelegate.bluetoothCenterOn)) {
               delegate.bluetoothCenterOn!()
            }
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    
    //断开外设的委托
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
        guard let delegate = delegate else {
            return
        }
        
        //移除
        self.peripheral.removeValue(forKey: peripheral)
        
        
        if delegate.responds(to: #selector(BluetoothCenterDelegate.bluetoothCenter(_:didDisconnectPeripheral:error:))) {
            delegate.bluetoothCenter!(central, didDisconnectPeripheral: peripheral, error: error as NSError?)
        }
    }
    
    //连接外设成功的委托
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        guard let delegate = delegate else {
            return
        }
        
        //设置外设代理
        self.peripheral[peripheral] = nil
        peripheral.delegate = self
        //扫描外设Services，成功后会进入方法：-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
        peripheral.discoverServices(nil)
        
        if delegate.responds(to: #selector(BluetoothCenterDelegate.bluetoothCenter(_:didConnectPeripheral:))) {
            delegate.bluetoothCenter!(central, didConnectPeripheral: peripheral)
        }
    }
    
    //外设连接失败的委托
    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        
        guard let delegate = delegate else {
            return
        }
        
        if delegate.responds(to: #selector(BluetoothCenterDelegate.bluetoothCenter(_:didFailToConnectPeripheral:error:))) {
            delegate.bluetoothCenter!(central, didFailToConnectPeripheral: peripheral, error: error as NSError?)
        }
    }
    
    
    //找到外设的委托
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        addPeripheral(peripheral)
        
        guard let delegate = delegate else {
            return
        }
        
        if  delegate.responds(to: #selector(BluetoothCenterDelegate.bluetoothCenter(_:didConnectPeripheral:))) {
            delegate.bluetoothCenter!(central, didDiscoverPeripheral: peripheralArray)
        }
    }
}


// MARK: - <#CBPeripheralDelegate#>
extension BluetoothManager: CBPeripheralDelegate {
    
    //扫描到Services
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        if  let _ = error {
            debugPrint("出错啦")
            return
        }
        
        
        for service in peripheral.services! {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    
    //扫描到Characteristics
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        if let _ = error {
            debugPrint("失败")
            return
        }
        
        //获取Characteristic的值，读到数据会进入方法：-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
        for characteristic in service.characteristics! {
            peripheral.readValue(for: characteristic)
        }
    }
    
    
    //获取的charateristic的值
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        //找到能打印的CBCharacteristic
        if characteristic.properties.rawValue & CBCharacteristicProperties.write.rawValue > 0 {
//            debugPrint(characteristic.properties.rawValue)
            self.peripheral[peripheral] = characteristic
        }
    }
    
    
    //写入成功失败的回调
    public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        
        guard let delegate = delegate else {
            return
        }
        
        if delegate.responds(to: #selector(BluetoothCenterDelegate.bluetoothCenter(_:didWriteValueForCharacteristic:error:)))
        {
            delegate.bluetoothCenter!(peripheral, didWriteValueForCharacteristic: characteristic, error: error as NSError?)
        }
    }
}



