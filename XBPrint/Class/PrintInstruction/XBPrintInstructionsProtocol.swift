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
    var printerInitialize: NSData! { get }
    
    
    /**
     水平定位
     */
    var printerHorizontalPositioning: NSData! { get }
    
    
    /**
     打印并换行
     */
    var println: NSData! { get }
    

    /**
     设置字符左边距
     */
    func printerLeftSpacing(nL: UInt8, nH: UInt8) -> NSData!
    
    
    /**
     设置字符右间距
     */
    func printerRightSpacing(n: UInt8) -> NSData!
    
    
    /**
     选择打印模式
     */
    func printerModel(n: UInt8) -> NSData!
    
    
    /**
     选择字符大小
     */
    func printerCharacterSize(n: UInt8) -> NSData!
    
    
    /**
     设置绝对打印位置
     */
    func printerAbsolutePosition(nL: UInt8, nH: UInt8) -> NSData!
    
    
    /**
     选择/取消用户自定义字符
     */
    func printerCustomCharacter(isCustomCharacter: Bool) -> NSData!
    
    
    /**
     选择/取消下划线模式
     */
    func printerUnderlineMode(n: UInt8) -> NSData!
    
    
    /**
     设置默认行间距
     */
    func printerDefaultLineSpacing() -> NSData!
    
    
    /**
     设置行间距
     */
    func printerSetTheLineSpacing(n: UInt8) -> NSData!
    
    
    /**
     选择/取消加粗模式
     */
    func printerBoldPatterns(isBoldPatterns: Bool) -> NSData!
    
    
    /**
     选择/取消双重打印模式
     */
    func printerDoublePrintMode(isDoublePrintMode: Bool) -> NSData!
    
    
    /**
     选择字体
     */
    func printerFont(n: UInt8) -> NSData!
    
    
    /**
     选择国际字符集
     */
    func printerCharacter(n: UInt8) -> NSData!
    
    
    /**
     选择对齐方式
     */
    func printerAlignment(n: UInt8) -> NSData!
    
    
    /**
     打印并向前走纸 n 行
     */
    func printerPaperFeed(n: UInt8) -> NSData!
    
    
    /**
     打印二维码
     */
    func printerQRCode(qrcode: String) -> NSData!
    
    
    /**
     查询打印机状态(仅对串口和以太网接口有效)
     */
    func printerState() -> NSData!
}
