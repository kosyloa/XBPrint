//
//  XBPrintInstructionProtocol+DPQRCode.swift
//  XBPrint
//
//  Created by xiaobin liu on 16/3/26.
//  Copyright © 2016年 Sky. All rights reserved.
//

import Foundation


// MARK: - 达普打印机的QRCode打印
extension XBPrintInstructionProtocol {
    
    /*
     ⚠️: 有些厂家的二维码打印不一样呼呼。。。。。。。日了🐶了
     */
    
    
    /**
     打印二维码
     - parameter qrcode:   二维码数据
     - returns:            Data
     */
    func printerQRCode(qrcode: String) -> NSData! {
    
        
        let  nLength = qrcode.characters.count + 0
        
        let cmmData = NSMutableData.init()
        cmmData.appendByte(29)
        cmmData.appendByte(119)
        cmmData.appendByte(11)//二维码大小设置
        
        cmmData.appendByte(29)
        cmmData.appendByte(107)
        cmmData.appendByte(97)
        cmmData.appendByte(0)
        cmmData.appendByte(1)
        cmmData.appendByte(UInt8(nLength))//二维码大小
        let printData = qrcode.dataUsingEncoding(NSUTF8StringEncoding)
        cmmData.appendData(printData!)
        return cmmData
    }
}