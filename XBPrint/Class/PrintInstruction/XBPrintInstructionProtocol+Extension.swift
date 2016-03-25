//
//  XBPrintInstructionProtocol+Extension.swift
//  XBPrint
//
//  Created by xiaobin liu on 16/3/25.
//  Copyright © 2016年 Sky. All rights reserved.
//

import Foundation


// MARK: - 打印指令扩展
extension XBPrintInstructionProtocol where Self: NSObject {
    
    /*⚠️: (默认情况下基本上都是一样的,除了一些比如二维码等)*/
    
    
    /**
     初始化打印机
     */
    var printerInitialize: NSData! {
        get {
            let cmmData = NSMutableData.init()
            cmmData.appendByte(27)
            cmmData.appendByte(64)
            return cmmData
        }
    }
    
    
    /**
     水平定位
     */
    var printerHorizontalPositioning: NSData! {
        get {
            let cmmData = NSMutableData.init()
            cmmData.appendByte(9)
            return cmmData
        }
    }
    
    /**
     打印并换行
     */
    var println: NSData! {
        get {
            let cmmData = NSMutableData.init()
            cmmData.appendByte(10)
            return cmmData
        }
    }
    
    
    /**
     设置字符右间距
    */
    func printerRightSpacing(n: UInt8) -> NSData! {
        let cmmData = NSMutableData.init()
        cmmData.appendByte(n)
        return cmmData
    }
    
    /**
     选择打印模式
     */
    func printerModel(n: UInt8) -> NSData! {
        
        let cmmData = NSMutableData.init()
        cmmData.appendByte(27)
        cmmData.appendByte(33)
        cmmData.appendByte(n)
        return cmmData
    }
    
    
    /**
     设置绝对打印位置
     */
    func printerAbsolutePosition(nL: UInt8, nH: UInt8) -> NSData! {
        let cmmData = NSMutableData.init()
        cmmData.appendByte(27)
        cmmData.appendByte(36)
        cmmData.appendByte(nL)
        cmmData.appendByte(nH)
        return cmmData
    }
    
    /**
     选择/取消用户自定义字符
     */
    func printerCustomCharacter(isCustomCharacter: Bool) -> NSData! {
       
        let cmmData = NSMutableData.init()
        cmmData.appendByte(27)
        cmmData.appendByte(37)
        if isCustomCharacter {
            cmmData.appendByte(1)
        } else {
           cmmData.appendByte(0)
        }
        return cmmData
    }
    
    
    /**
     选择/取消下划线模式
     */
    func printerUnderlineMode(n: UInt8) -> NSData! {
        let cmmData = NSMutableData.init()
        cmmData.appendByte(27)
        cmmData.appendByte(45)
        cmmData.appendByte(n)
        return cmmData
    }
    
    
    /**
     设置默认行间距
     */
    func printerDefaultLineSpacing() -> NSData! {
        let cmmData = NSMutableData.init()
        cmmData.appendByte(27)
        cmmData.appendByte(50)
        return cmmData
    }
    
    /**
     设置行间距
     */
    func printerSetTheLineSpacing(n: UInt8) -> NSData! {
        let cmmData = NSMutableData.init()
        cmmData.appendByte(27)
        cmmData.appendByte(51)
        cmmData.appendByte(n)
        return cmmData
    }
    
    
    /**
     选择/取消加粗模式
     */
    func printerBoldPatterns(isBoldPatterns: Bool) -> NSData! {
        
        let cmmData = NSMutableData.init()
        cmmData.appendByte(27)
        cmmData.appendByte(69)
        if isBoldPatterns {
            cmmData.appendByte(1)
        } else {
            cmmData.appendByte(0)
        }
        return cmmData
    }
   
    /**
     选择/取消双重打印模式
     */
    func printerDoublePrintMode(isDoublePrintMode: Bool) -> NSData! {
        let cmmData = NSMutableData.init()
        cmmData.appendByte(27)
        cmmData.appendByte(71)
        if isDoublePrintMode {
            cmmData.appendByte(1)
        } else {
            cmmData.appendByte(0)
        }
        return cmmData
    }
    
    
    
    /**
     选择字体
     */
    func printerFont(n: UInt8) -> NSData! {
        let cmmData = NSMutableData.init()
        cmmData.appendByte(27)
        cmmData.appendByte(77)
        cmmData.appendByte(n)
        return cmmData
    }
    
    /**
     选择国际字符集
     */
    func printerCharacter(n: UInt8) -> NSData! {
        let cmmData = NSMutableData.init()
        cmmData.appendByte(27)
        cmmData.appendByte(82)
        cmmData.appendByte(n)
        return cmmData
    }
    
    
    /**
     选择对齐方式
     */
    func printerAlignment(n: UInt8) -> NSData! {
        let cmmData = NSMutableData.init()
        cmmData.appendByte(27)
        cmmData.appendByte(97)
        cmmData.appendByte(n)
        return cmmData
    }
    
    
    /**
     打印并向前走纸 n 行
     */
    func printerPaperFeed(n: UInt8) -> NSData! {
        let cmmData = NSMutableData.init()
        cmmData.appendByte(27)
        cmmData.appendByte(100)
        cmmData.appendByte(n)
        return cmmData
    }
    
    
    /**
     查询打印机状态(仅对串口和以太网接口有效)
     */
    func printerState() -> NSData! {
        let cmmData = NSMutableData.init()
        cmmData.appendByte(27)
        cmmData.appendByte(118)
        return cmmData
    }
}


// MARK: - 扩展NSMutableData
extension NSMutableData {
    func appendByte(b: UInt8) {
        var a = b
        self.appendBytes(&a, length: 1)
    }
}