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
     [格式]: ASCII码 ESC @
     十六进制码 1B 40
     十进制码 27 64
     
     [描述]: 清除打印缓冲区数据,打印模式被设为上电时的默认值模式。
     
     [注释]: • DIP开关的设置不进行再次检测。
     • 除除接收缓冲区中的数据保留。 • 宏定义保留。
     • NV位图数据不擦除。
     • 用户NV存储器数据不擦除。
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
     [格式]: ASCII码 HT
     十六进制码 09
     十进制码 9
     
     [描述]: 移动打印位置到下一个水平定位点的位置。
     
     [注释]: • 如果没有设置下一个水平定位点的位置,则该命令被忽略。
     • 如果下一个水平定位点的位置在打印区域外,则打印位置移动到为 [打印区域宽度 +1]。
     • 通过ESC D 命令设置水平定位点的位置。
     • 打印位置位于 [打印区域宽度+ 1] 处时接收到该命令,打印机执行打印缓冲区满打印当前行,并且在下一行的开始处理水平定位。
     • 默认值水平定位位置是每8个标准ASCII码字符(12×24)字符跳一格(即第9,17,25,...列)。
     • 当前行缓冲区满时,打印机执行下列动作:
     标准模式下,打印机打印当前行内容并将打印位置置于下一行的起始位置。
     页模式下,打印机进行换行并将打印位置置于下一行的起始位置。
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
     [格式]: ASCII码 LF
     十六进制码 0A
     十进制码 10
     [描述] 将打印缓冲区中的数据打印出来,并且按照当前行间距,把打印纸向前推进一行
     [注释] 该命令把打印位置设置为行的开始位置
     */
    var println: NSData! {
        get {
            let cmmData = NSMutableData.init()
            cmmData.appendByte(10)
            return cmmData
        }
    }
}


// MARK: - 扩展NSMutableData
extension NSMutableData {
    func appendByte(b: UInt8) {
        var a = b
        self.appendBytes(&a, length: 1)
    }
}