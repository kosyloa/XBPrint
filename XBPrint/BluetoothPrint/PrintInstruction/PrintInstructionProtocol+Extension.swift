//
//  XBPrintInstructionProtocol+Extension.swift
//  XBPrint
//
//  Created by xiaobin liu on 16/3/25.
//  Copyright © 2016年 Sky. All rights reserved.
//

import Foundation


// MARK: - 打印指令扩展
extension XBPrintInstructionProtocol {
    
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
    var printerInitialize: Data {
        get {
            var cmmData = Data()
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
    var printerHorizontalPositioning: Data {
        get {
            var cmmData = Data()
            cmmData.appendByte(9)
            return cmmData
        }
    }
    
    
    
    /**
     打印并换行
     [格式]: ASCII码 LF
     十六进制码 0A
     十进制码 10
     [描述]: 将打印缓冲区中的数据打印出来,并且按照当前行间距,把打印纸向前推进一行
     [注释]: 该命令把打印位置设置为行的开始位置
     */
    var println: Data {
        get {
            var cmmData = Data()
            cmmData.appendByte(10)
            return cmmData 
        }
    }
    
    
    /**
     设置左边距
     [格式]: ASCII码 GS L nL nH
            十六进制码 1D 4C nL nH
            十进制码 29 76 nL nH
     [范围]: 0≤nL≤255  0 ≤ nH ≤ 255
     [描述]: • 用 nL 和 nH设置左边距;
            • 左边距设置为 [( nL + nH × 256) × 横向移动单位]] 英寸。
     
            ----------------------------------------------------
            ||||||||||||||||]
            ||||||||||||||||]            可打印区域
            ||||||||||||||||]
            ----------------------------------------------------
            <-    左边距    ->
     [注释]: • 在标准模式下,该命令只有在行首才有效。
            • 如果设置超出了最大可用打印宽度,则取最大可用打印宽度
            • 横向和纵向移动单位是由 GS P命令设置的,改变纵向和横向移动单位不影响当前的
              左边距。
     [默认值] nL = 0, nH = 0
     */
    func printerLeftSpacing(_ nL: UInt8, nH: UInt8) -> Data {
        var cmmData = Data()
        cmmData.appendByte(29)
        cmmData.appendByte(76)
        cmmData.appendByte(nL)
        cmmData.appendByte(nH)
        return cmmData 
    }
    
    
    /**
     设置字符右间距
     [格式]: ASCII码 ESC SP n
     十六进制码 1B 20 n
     十进制码 27 32 n
     [范围]: 0 ≤ n≤255
     [描述]: 设置字符的右间距为[n×横向移动单位或纵向移动单位]英寸。
     [注释]: • 当字符放大时,右间距随之放大相同的倍数。
     • 此命令设置的值在页模式和标准模式下是相互独立的。
     • 横向或纵向移动单位由GS P指定。改变横向或纵向移动单位不改变当前右间距。
     • GS P 命令可改变水平(和垂直)运动单位。但是该值不得小于最小水平移动量,并且
     必须为最小水平移动量的偶数单位。
     • 标准模式下,使用横向移动单位。
     • 在页模式下,根据区域的方向和起始位置来选择使用横向移动单位或纵向移动单位,
     其选择方式如下:
     1、当打印起始位置由ESC T设置为打印区域的左上角或右下角时,使用横向移动单
     位;
     2、当打印起始位置由ESC T设置为打印区域的左下角或右上角时,使用纵向移动单
     位;
     • 最大右间距是31.91毫米(255/203 英寸)。 任何超过这个值的设置都自动转换为最
     大右间距。
     [默认值]: n = 0
     - returns: NSData!
     */
    func printerRightSpacing(_ n: UInt8) -> Data {
        var cmmData = Data()
        cmmData.appendByte(27)
        cmmData.appendByte(32)
        cmmData.appendByte(n)
        return cmmData 
    }
    
    
    
    /**
     选择打印模式
     [格式]: ASCII码 ESC ! n
     十六进制码 1B 21n
     十进制码 27 33n
     [范围]: 0≤n≤255
     [描述]: 根据n的值设置字符打印模式:
     功能: 标准ASCII码字体A (12 × 24)  十六进制码: 00 十进制码: 0    位(核心): 0
     压缩ASCII码字体B (9 × 17)   十六进制码: 01  十进制码: 1    位(核心): 0
     取消加粗模式                十六进制码: 00  十进制码: 0    位(核心): 3
     选择加粗模式                十六进制码: 08  十进制码: 8    位(核心): 3
     取消倍高模式                十六进制码: 00  十进制码: 0    位(核心): 4
     选择倍高模式                十六进制码: 10  十进制码: 16    位(核心): 4
     取消倍宽模式                十六进制码: 00  十进制码: 0    位(核心): 5
     选择倍宽模式                十六进制码: 20  十进制码: 32    位(核心): 5
     取消下划线模式              十六进制码: 0   十进制码: 0    位(核心): 7
     选择下划线模式              十六进制码: 80  十进制码: 128    位(核心): 7
     
     用例⚠️ :  16 + 8 得到24，就是0x18啊，然后就是加粗和倍高
     
     [注释]: • 当倍宽和倍高模式同时选择时,字符同时在横向和纵向放大两倍。
     • 除了HT 设置的空格和顺时针旋转90° 的字符,其余任何字符都可以加下划线。
     • 下划线度由 ESC - 确定,与字符无关。
     • 当一行中部分字符为倍高或更高,所有字符以底端对齐。
     • ESC E也能选择或取消加粗模式,最后被执行的命令有效。
     • ESC – 也能选择或取消下划线模式,最后被执行的命令有效。
     • GS ! 也能设置字符大小,最后被执行的命令有效。
     • 粗体模式对英数字符和汉字都有效。除粗体模式外的所有打印模式仅对英数字符有效。
     [默认值] n = 0
     */
     func printer(model: UInt8) -> Data {
        
        var cmmData = Data()
        cmmData.appendByte(27)
        cmmData.appendByte(33)
        cmmData.appendByte(model)
        return cmmData 
        
    }
    
    
    /**
     选择字符大小
     [格式]:   ASCII码 GS ! n
     十六进制码 1D 21 n
     十进制码 29 33 n
     [范围]:   0≤n≤255  (1≤ 纵向放大倍数 ≤8,1≤ 横向放达倍数 ≤8)
     [描述]:   用 0 到 2 位选择字符高度,4 到 7 位选择字符宽度 如下所示:
     字符宽度选择:  十六进制码   十进制码   横向放大
     00          0       1(正常)
     10          16      2(2倍宽)
     20          32      3
     30          48      4
     40          64      5
     50          80      6
     60          96      7
     70          112     8
     字符高度选择:    00          0       1 (正常)
     01          1       2 (2倍高)
     02          2       3
     03          3       4
     04          4       5
     05          5       6
     06          6       7
     07          7       8
     [注释]:   • 如果 n 超出了规定的范围,则这条命令被忽略。
     • 这条命令对所有字符(ASCII码字符和汉字)都有效,但是HRI字符除外。
     • 在标准模式下,纵向是进纸方向,横向是垂直于进纸的方向。但是当字符顺时针旋转 90°时,横向和纵向颠倒。
     • 页模式下,横向和纵向取决于区域的方向。
     • 同一行字符的放大倍数不同时,所有的字符以底线对齐。
     • ESC ! 命令也可以选择或者取消字符倍宽和倍高,最后接收的命令有效
     [默认值]  n = 0
    */
    func printer(characterSize: UInt8) -> Data {
        
        var cmmData = Data()
        cmmData.appendByte(29)
        cmmData.appendByte(33)
        cmmData.appendByte(characterSize)
        return cmmData
    }
    
    
    
    /**
     设置绝对打印位置
     [格式]: ASCII码 ESC $  nL nH
     十六进制码 1B 24 nL nH
     十进制码   27 36 nL nH
     [范围]: 0≤nL ≤ 255, 0 ≤nH≤255
     [描述]: 将当前位置设置到距离行首(nL + nH×256)× (横向或纵向移动单位)处
     [注释]: • 如果设置位置在指定打印区域外,该命令被忽略。
     • 横向和纵向移动单位由GS P 设置。
     • 标准模式下使用横向移动单位。
     • 在页模式下,根据打印区域的方向和打印起始位置来选择使用横向移动单位或纵向移
     动单位,其选择方式如下:
     1、当打印起始位置由ESC T设置为打印区域的左上角或右下角时,使用横向移动单位;
     2、当打印起始位置由ESC T设置为打印区域的左下角或右上角时,使用纵向移动单位;
     */
    func printerAbsolutePosition(_ nL: UInt8, nH: UInt8) -> Data {
        var cmmData = Data()
        cmmData.appendByte(27)
        cmmData.appendByte(36)
        cmmData.appendByte(nL)
        cmmData.appendByte(nH)
        return cmmData 
    }
    
    
    
    /**
     选择/取消用户自定义字符
     [格式]: ASCII码 ESC % n
     十六进制码 1B 25 n
     十进制码 27 37 n
     [范围]: ≤n≤255
     [描述]: 选择或取消用户自定义字符
     • 当n的最低位为0时,不使用用户自定义字符
     • 当n的最低位为1时,使用用户自定义字符。
     [注释]: • 当取消使用用户自定义字符的时候,自动使用内部字库。
     • n 只有最低位有效。
     [默认值]: n = 0
     */
    func printer(customCharacter: Bool) -> Data {
        
        var cmmData = Data()
        cmmData.appendByte(27)
        cmmData.appendByte(37)
        if customCharacter {
            cmmData.appendByte(1)
        } else {
            cmmData.appendByte(0)
        }
        return cmmData
    }
    
    
    /**
     选择/取消下划线模式
     [格式]: ASCII码 ESC - n
     十六进制码 1B 2D n
     十进制码 27 45 n
     [范围]: 0≤n≤2,48≤n≤50
     [描述]: 根据n的值选择或取消下划线模式
     0, 48 取消下划线模式
     1, 49 选择下划线模式(1点宽)
     2, 50 选择下划线模式(2点宽)
     [注释]: • 下划线可加在所有字符下(包括右间距),但不包括HT设置的空格
     • 下划线不能作用在顺时针旋转90° 和反显的字符下。
     • 当取消下划线模式时,后面的字符不加下划线,下划线的宽度不改变。默认宽度是一点宽
     • 改变字符大小不影响当前下划线宽度
     • 下划线选择取消也可以由 ESC !来设置。最后执行的命令有效。
     • 该命令不影响汉字字符的设定。
     [默认值]: n = 0
     */
    func printer(underlineMode: UInt8) -> Data {
        var cmmData = Data()
        cmmData.appendByte(27)
        cmmData.appendByte(45)
        cmmData.appendByte(underlineMode)
        return cmmData 
    }
    
    
    
    /**
     设置默认行间距
     [格式]: ASCII码 ESC 2
     十六进制码 1B 32
     十进制码 27 50
     [描述]: 选择约 3.75mm 行间距。
     [注释]: • 行间距在标准模式和页模式下是独立的。
     */
    func printerDefaultLineSpacing() -> Data {
        var cmmData = Data()
        cmmData.appendByte(27)
        cmmData.appendByte(50)
        return cmmData 
    }
    
    
    
    /**
     设置行间距
     [格式]:  ASCII码 ESC 3 n
     十六进制码 1B 33 n
     十进制码 27 51 n
     [范围]:  0≤n≤255
     [描述]:  设置行间距为 [ n × 纵向或横向移动单位] 英寸。
     [注释]:  • 行间距设置在标准模式和页模式下是相互独立的。
     • 横向和纵向移动单位由 GS P 设置,改变这个设置不影响当前行间距。
     • 标准模式下,使用纵向移动单位。
     • 在页模式下,根据打印区域的方向和打印起始位置来选择使用横向移动单位或纵向移
     动单位,其选择方式如下:
     1、当打印起始位置由ESC T设置为打印区域的左上角或右下角时,使用纵向移动单位;
     2、当打印起始位置由ESC T设置为打印区域的左下角或右上角时,使用横向移动单 位;
     • 最大走纸距离是956 mm,如果超出这个距离,取最大距离。
     [默认值]: 默认值行高约为3.75mm。
     */
    func printer(lineSpacing: UInt8) -> Data {
        var cmmData = Data()
        cmmData.appendByte(27)
        cmmData.appendByte(51)
        cmmData.appendByte(lineSpacing)
        return cmmData 
    }
    
    
    
    /**
     选择/取消加粗模式
     [格式]: ASCII码  ESC E n
     十六进制码 1B 45 n
     十进制码   27 69 n
     [范围]: 0≤n≤255
     [描述]: 选择或取消加粗模式
     当n的最低位为0时,取消加粗模式。
     当n的最低位为1时,选择加粗模式。
     [注释]: • n只有最低位有效。
     • ESC ! 同样可以选择/取消加粗模式,最后接收的命令有效。
     [默认值]: n = 0
     */
    func printer(boldPatterns: Bool) -> Data {
        
        var cmmData = Data()
        cmmData.appendByte(27)
        cmmData.appendByte(69)
        if boldPatterns {
            cmmData.appendByte(1)
        } else {
            cmmData.appendByte(0)
        }
        return cmmData 
    }
   
    
    
    /**
     选择/取消双重打印模式
     [格式]: ASCII码 ESC  G  n
     十六进制码 1B 47 n
     十进制码   27 71 n
     [范围]: 0≤n≤255
     [描述]: 选择/取消双重打印模式。
     • 当n的最低位为0时,取消双重打印模式。
     • 当n的最低位为1时,选择双重打印模式。
     [注释]: • n只有最低位有效。
     • 该命令与加粗打印效果相同。
     [默认值]: n = 0
     */
    func printer(doublePrintMode: Bool) -> Data {
        var cmmData = Data()
        cmmData.appendByte(27)
        cmmData.appendByte(71)
        if doublePrintMode {
            cmmData.appendByte(1)
        } else {
            cmmData.appendByte(0)
        }
        return cmmData 
    }
    
    
    
    /**
     选择字体
     [格式]: ASCII码 ESC M  n
     十六进制码 1B 4D n
     十进制码  27  77 n
     [范围]: n=0,1,48,49
     [描述]: 0,48  选择标准ASCII码字体 (12 × 24)
     1,49  选择压缩ASCII码字体 (9 × 17)
     */
    func printer(font: UInt8) -> Data {
        var cmmData = Data()
        cmmData.appendByte(27)
        cmmData.appendByte(77)
        cmmData.appendByte(font)
        return cmmData 
    }
    
    
    
    /**
     选择国际字符集
     [格式]: ASCII码 ESC R  n
     十六进制码 1B 52 n
     十进制码 27 82 n
     [范围]: 0≤n≤15
     [描述]: 从下表选择一个国际字符集n
     0  美国
     1  法国
     2  德国
     3  英国
     4  丹麦I
     5  瑞典
     6  意大利
     7  西班牙I
     8  日本
     9  挪威
     10 丹麦II
     11 西班牙II
     12 拉丁美洲
     13 韩国
     14 斯洛维尼亚/克罗帝亚
     15 中国
     */
     func printer(character: UInt8) -> Data {
        var cmmData = Data()
        cmmData.appendByte(27)
        cmmData.appendByte(82)
        cmmData.appendByte(character)
        return cmmData 
    }
    
    
    
    /**
     选择对齐方式
     [格式]: ASCII码 ESC a n
     十六进制码 1B 61 n
     十进制码 27 97 n
     [范围]: 0≤n≤2,48≤n≤50
     [描述]: 使所有的打印数据按某一指定对齐方式排列。 n 的取值与对齐方式对应关系如下:
     n  对齐方式
     0, 48  左对齐
     1, 49  中间对齐
     2, 50  右对齐
     [注释]: • 该命令只在标准模式下的行首有效。
     • 该命令在页模式下只改变内部标志位。
     • 该命令在打印区域执行对齐。
     • 该命令根据HT, ESC $ 或 ESC \命令来调整空白区域。
     [默认值]: n = 0
     */
    func printer(alignment: UInt8) -> Data {
        var cmmData = Data()
        cmmData.appendByte(27)
        cmmData.appendByte(97)
        cmmData.appendByte(alignment)
        return cmmData 
    }
    
    
    
    /**
     打印并向前走纸 n 行
     [格式]:  ASCII码  ESC d n
     十六进制码 1B 64 n
     十进制码   27 100 n
     [范围]: 0≤n≤255
     [描述]: 打印缓冲区里的数据并向前走纸n行(字符行)
     [注释]: • 该命令将打印机的打印起始位置设置在行首。
     • 该命令不影响由ESC 2 或 ESC 3设置的行间距。
     • 最大走纸距离为1016 mm,当所设的值大于1016 mm时,取最大值。
     */
    func printer(paperFeed: UInt8) -> Data {
        var cmmData = Data()
        cmmData.appendByte(27)
        cmmData.appendByte(100)
        cmmData.appendByte(paperFeed)
        return cmmData 
    }
    
    
    
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
    func printerQRCodeSize(_ n: UInt8) -> Data! {
        
        var cmmData = Data()
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
    func  printerQRCodeECC(_ n: UInt8) -> Data! {
        var cmmData = Data()
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
    func printerStoringData(_ qrcode: String) -> Data! {
        
        let  nLength = qrcode.characters.count + 3
        var cmmData = Data()
        cmmData.appendByte(29)
        cmmData.appendByte(40)
        cmmData.appendByte(107)
        cmmData.appendByte(UInt8(nLength%256))
        cmmData.appendByte(UInt8(nLength/256))
        cmmData.appendByte(49)
        cmmData.appendByte(80)
        cmmData.appendByte(48)
        let printData = qrcode.data(using: String.Encoding.utf8)
        cmmData.append(printData!)
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
    func printerQRCodeStorageData() -> Data! {
        
        var cmmData = Data()
        cmmData.appendByte(29)
        cmmData.appendByte(40)
        cmmData.appendByte(107)
        cmmData.appendByte(3)
        cmmData.appendByte(0)
        cmmData.appendByte(49)
        cmmData.appendByte(81)
        cmmData.appendByte(48)
        return cmmData 
    }
    
    
    /**
     打印二维码
     */
    func printerQRCode(_ size: UInt8, ecc: UInt8, qrcode: String) -> Data {
        
        var cmmData = Data()
        cmmData.append(printerQRCodeSize(size))
        cmmData.append(printerQRCodeECC(ecc))
        cmmData.append(printerStoringData(qrcode))
        cmmData.append(printerQRCodeStorageData())
        return cmmData 
    }
    
    
    
    /**
     查询打印机状态(仅对串口和以太网接口有效)
     [格式]: ASCII码 ESC v
     十六进制码 1B 76
     十进制码 27 118
     [描述]: 查询打印机状。
     对于串口:
     当n=0时,打印机有纸;
     当n=4时,打印机缺纸。
     */
    func printerState() -> Data {
        var cmmData = Data()
        cmmData.appendByte(27)
        cmmData.appendByte(118)
        return cmmData 
    }
}


// MARK: - 扩展Data
extension Data {
    mutating func appendByte(_ b: UInt8) {
        var a = b
        self.append(&a, count: 1)
    }
}
