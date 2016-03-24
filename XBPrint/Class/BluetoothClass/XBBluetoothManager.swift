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
        
        if delegate.respondsToSelector(#selector(XBBluetoothCenterDelegate.bluetoothCenter(_:didDisconnectPeripheral:error:))) {
            delegate.bluetoothCenter!(central, didDisconnectPeripheral: peripheral, error: error)
        }
    }
    
    //连接外设成功的委托
    public func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        guard let delegate = delegate else {
            return
        }
        
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
        
        if  delegate.respondsToSelector(#selector(XBBluetoothCenterDelegate.bluetoothCenter(_:didDiscoverPeripheral:RSSI:))) {
            delegate.bluetoothCenter!(central, didDiscoverPeripheral: peripheral, RSSI: RSSI)
        }
    }
}

// MARK: - <#Description#>
extension  XBBluetoothManager {
    
    //添加外围设备
    func addPeripheral(peripheral: CBPeripheral) {
        if peripheralArray.contains(peripheral) == false {
            peripheralArray.append(peripheral)
        }
    }
}



