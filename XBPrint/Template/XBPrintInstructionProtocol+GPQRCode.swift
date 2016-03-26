//
//  XBPrintInstructionProtocol+GPQRCode.swift
//  XBPrint
//
//  Created by xiaobin liu on 16/3/26.
//  Copyright © 2016年 Sky. All rights reserved.
//

import Foundation


// MARK: - 佳博打印机的QRCode打印
extension XBPrintInstructionProtocol {
    
    /*
     [名称]: QR CODE: 设置QRCode模块大小
     [格式]: ASCII码 GS ( K pL pH cn fn n
            十六进制码 1D 28 6B 03 00 31 43 n
            十进制码 29 40 107 3 0 49 67 n 
     [范围]: (pL+pH×256)=3 (pL=3,pH=0)  cn=49 fn=67 1≤n≤16
     [默认值]: n=3
     [描述]: 设置QRCode模块大小为n dot
     [注释]: • 执行esc @或打印机掉电后,恢复默认值
            • 模块的宽度=模块的高度,因为QRCode是正方形的
    */
    func qrCodeSize(n: UInt8) -> NSData! {
        
        let cmmData = NSMutableData.init()
        cmmData.appendByte(29)
        cmmData.appendByte(40)
        cmmData.appendByte(107)
        cmmData.appendByte(3)
        cmmData.appendByte(0)
        cmmData.appendByte(49)
        cmmData.appendByte(67)
        cmmData.appendByte(n)
        return cmmData
    }
    
    
    
    /*
     [名称]: QR CODE: 选择纠错等级
     [格式]: ASCII码 GS ( K pL pH cn fn n
            十六进制码 1D 28 6B 03 00 31 45 n
            十进制码 29 40 107 3 0 49 69 n
     [范围]: (pL+pH×256)=3 (pL=3,pH=0)  cn=49   fn=69 48≤n≤51
     [默认值]: n=48
     [描述]: 选择QR CODE纠错等级
              n      功能
              48     选择纠错等级L   7
              49     选择纠错等级M   15
              50     选择纠错等级Q   25
              51     选择纠错等级H   30
     [注释]:  • 执行esc @或打印机掉电后,恢复默认值
     */
    func  qrCodeECC(n: UInt8) -> NSData! {
        let cmmData = NSMutableData.init()
        cmmData.appendByte(29)
        cmmData.appendByte(40)
        cmmData.appendByte(107)
        cmmData.appendByte(3)
        cmmData.appendByte(0)
        cmmData.appendByte(49)
        cmmData.appendByte(69)
        cmmData.appendByte(n)
        return cmmData
    }
    
    
    /*
     [名称]:  QR CODE: 存储数据到符号存储区
     [格式]:  ASCII码 GS   ( K pL pH cn fn m d1...dk
             十六进制码 1D 28 6B pL pH 31 50 30 d1...dk
             十进制码  29 40 107 pL pH 49 80 48 d1...dk
     [范围]:  4≤(pL+pH×256)≤7092 (0≤pL≤255,0≤pH≤27) cn=49  fn=80  m=48  k=(pL+pH×256)-3
     [描述]:  存储QR CODE数据(d1...dk)到符号存储区
     [注释]   • 将QRCode的数据存储到打印机中
             • 执行esc @或打印机掉电后,恢复默认值
     */
    func qrCodeData(qrcode: String) -> NSData! {
        
        let  nLength = qrcode.characters.count + 3
        let cmmData = NSMutableData.init()
        cmmData.appendByte(29)
        cmmData.appendByte(40)
        cmmData.appendByte(107)
        cmmData.appendByte(UInt8(nLength%256))
        cmmData.appendByte(UInt8(nLength/256))
        cmmData.appendByte(49)
        cmmData.appendByte(80)
        cmmData.appendByte(48)
        let printData = qrcode.dataUsingEncoding(NSUTF8StringEncoding)
        cmmData.appendData(printData!)
        return cmmData
    }
    
    
    /*
     [名称]: QR CODE: 打印符号存储区中的数据
     [格式]:  ASCII码 GS ( K pL pH cn fn m
            十六进制码 1D 28 6B 03 00 31 51 m
            十进制码 29 40 107 3 0 49 81 m  
     [范围]: (pL+pH×256)=3 (pL=3,pH=0)  cn=49 fn=81 m=48
     [描述]: 打印QRCode条码,在发送此命令之前,需通过(K< Function 180)命令将QRCode数 据存储在打印机中。
     */
    func qrCodeStorageData(m: UInt8) -> NSData! {
        
        let cmmData = NSMutableData.init()
        cmmData.appendByte(29)
        cmmData.appendByte(40)
        cmmData.appendByte(107)
        cmmData.appendByte(3)
        cmmData.appendByte(0)
        cmmData.appendByte(49)
        cmmData.appendByte(81)
        cmmData.appendByte(m)
        return cmmData
    }
    
    
    /**
     打印二维码
     - parameter qrcode:   二维码数据
     - returns:            Data
     */
    func printerQRCode(qrcode: String) -> NSData! {
    
        let cmmData = NSMutableData.init()
        cmmData.appendData(qrCodeSize(12))
        cmmData.appendData(qrCodeECC(48))
        cmmData.appendData(qrCodeData(qrcode))
        cmmData.appendData(qrCodeStorageData(48))
        return cmmData
    }
}
