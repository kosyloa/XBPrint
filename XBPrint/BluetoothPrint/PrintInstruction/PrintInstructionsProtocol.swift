//
//  XBPrintCommandProtocol.swift
//  XBPrint
//
//  Created by xiaobin liu on 16/3/25.
//  Copyright © 2016年 Sky. All rights reserved.
//

import Foundation

/**
 *  打印指令接口(58mm打印机编程手册)
 */
public protocol XBPrintInstructionProtocol {
    
    /*
     ⚠️:  定义用户自定义字符,选择位图模式(iOS蓝牙传输速度限制,所以不开发)
     */
    
    
    /**
     初始化打印机
     */
    var printerInitialize: Data { get }
    
    
    /**
     水平定位
     */
    var printerHorizontalPositioning: Data { get }
    
    
    /**
     打印并换行
     */
    var println: Data { get }
    

    /**
     设置字符左边距
     
     - parameter nL: 距离左边的长
     - parameter nH: 距离左边的高
     
     - returns:  NSData
     */
    func printerLeftSpacing(_ nL: UInt8, nH: UInt8) -> Data
    
    
    /**
     设置字符右间距
     
     - parameter n:  右间距距离
     
     - returns:  NSData
     */
    func printerRightSpacing(_ n: UInt8) -> Data
    
    

    /**
     选择打印模式
     
     - parameter n: n的值设置字符打印模式
     
     - returns:  NSData
     */
    func printer(model: UInt8) -> Data
    
    
    /**
     选择字符大小
     
     - parameter n: 字符大小
     
     - returns:  NSData
     */
    func printer(characterSize: UInt8) -> Data
    
    

    /**
     设置绝对打印位置
     
     - parameter nL: 横向的长度
     - parameter nH: 纵向的高度
     
     - returns:  NSData
     */
    func printerAbsolutePosition(_ nL: UInt8, nH: UInt8) -> Data

    
    /**
     选择/取消用户自定义字符
     
     - parameter isCustomCharacter: 是否用户自定义
     
     - returns:  NSData
     */
    func printer(customCharacter: Bool) -> Data

    
    /**
     选择/取消下划线模式
     
     - parameter n:  (0:取消下划线模式,1:选择下划线模式,2:选择下划线模式(2点宽))
     
     - returns: NSData
     */
    func printer(underlineMode: UInt8) -> Data

    
    /**
     设置默认行间距
     
     - returns: NSData
     */
    func printerDefaultLineSpacing() -> Data

    
    /**
     设置行间距
     
     - parameter n: 设置行间距为 [ n × 纵向或横向移动单位] 英寸
     
     - returns:  NSData
     */
    func printer(lineSpacing: UInt8) -> Data

    
    /**
     选择/取消加粗模式
     
     - parameter isBoldPatterns: 是否加粗
     
     - returns:  NSData
     */
    func printer(boldPatterns: Bool) -> Data

    

    /**
     选择/取消双重打印模式
     
     - parameter isDoublePrintMode: 是否双重打印模式
     
     - returns:  NSData
     */
    func printer(doublePrintMode: Bool) -> Data

    
    /**
     选择字体
     
     - parameter n:  0,48  选择标准ASCII码字体 (12 × 24)  1,49  选择压缩ASCII码字体 (9 × 17)
     
     - returns:  NSData
     */
    func printer(font: UInt8) -> Data

    
    /**
     选择国际字符集
     
     - parameter n: 国际字符
     
     - returns:  NSData
     */
    func printer(character: UInt8) -> Data

    
    /**
     选择对齐方式
     
     - parameter n: 0, 48  左对齐  1, 49  中间对齐  2, 50  右对齐
     
     - returns:  NSData
     */
    func printer(alignment: UInt8) -> Data

    
    /**
     打印并向前走纸 n 行
     
     - parameter n: 打印缓冲区里的数据并向前走纸n行(字符行)
     
     - returns:  NSData
     */
    func printer(paperFeed: UInt8) -> Data

    
    
    /**
     打印二维码
     
     - parameter size:   二维码大小
     - parameter ecc:    纠错等级
     - parameter qrcode: 二维码数据
     
     - returns:  NSData
     */
    func printerQRCode(_ size: UInt8, ecc: UInt8, qrcode: String) -> Data

    
    /**
     打印二维码(因为有些厂家的打印二维码的打印指令不一样,所以你懂的)
     
     - parameter qrcode: 二维码数据
     
     - returns: NSData
     */
    func printer(qrcode: String) -> Data
    

    
    /**
     查询打印机状态(仅对串口和以太网接口有效)
     
     - returns: NSData
     */
    func printerState() -> Data
}
