//
//  XBBluetoohProtocol.swift
//  XBPrint
//
//  Created by xiaobin liu on 16/3/24.
//  Copyright © 2016年 Sky. All rights reserved.
//

import Foundation
import CoreBluetooth

/**
 *  蓝牙中心协议
 */
@objc protocol BluetoothCenterDelegate: NSObjectProtocol {
    
    //蓝牙关闭方法
    @objc optional func bluetoothCenterOff()
    
    //蓝牙开启方法
    @objc optional func bluetoothCenterOn()
    
    //找到外设方法
    @objc optional func bluetoothCenter(_ central: CBCentralManager, didDiscoverPeripheral peripheralArray: [CBPeripheral])
    
    //外设连接失败方法
    @objc optional func bluetoothCenter(_ central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?)
    
    //断开外设方法
    @objc optional func bluetoothCenter(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?)
    
    //连接外设成功方法
    @objc optional func bluetoothCenter(_ central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral)
    
    //写入成功/失败方法
    @objc optional func bluetoothCenter(_ peripheral: CBPeripheral,didWriteValueForCharacteristic characteristic: CBCharacteristic, error: NSError?)
    
}
