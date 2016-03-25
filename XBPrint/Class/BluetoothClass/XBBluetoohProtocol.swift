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
@objc protocol XBBluetoothCenterDelegate: NSObjectProtocol {
    
    //蓝牙关闭方法
    optional func bluetoothCenterOff()
    
    //蓝牙开启方法
    optional func bluetoothCenterOn()
    
    //找到外设方法
    optional func bluetoothCenter(central: CBCentralManager, didDiscoverPeripheral peripheralArray: [CBPeripheral])
    
    //外设连接失败方法
    optional func bluetoothCenter(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?)
    
    //断开外设方法
    optional func bluetoothCenter(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?)
    
    //连接外设成功方法
    optional func bluetoothCenter(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral)
    
    //写入成功方法
    optional func bluetoothCenter(peripheral: CBPeripheral,didWriteValueForCharacteristic characteristic: CBCharacteristic)
    
    //写入失败方法
    optional func bluetoothCenter(peripheral: CBPeripheral,didWriteValueForCharacteristic characteristic: CBCharacteristic, error: NSError?)
    
}