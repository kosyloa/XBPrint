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
protocol XBPrintInstructionProtocol {
    
    //打印机初始化属性
    var printerInitialize: NSData! { get }
    
    //打印机水平定位(一个Tab键)
    var printerHorizontalPositioning: NSData! { get }
    
    //打印并换行
    var println: NSData! { get }
    
    
    
}
