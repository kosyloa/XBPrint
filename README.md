# XBPrint
  实现了蓝牙扫描，蓝牙连接，蓝牙断开等一些功能.<br>
  实现了基于esc-pos协议指令的蓝牙打印机的大部分命令.<br>
  实现了二维码的打印.<br>

# Requirements
  iOS8+ <br>
  Xcode7.2 <br>
  
# Example Code 

    1.BluetoothManagerCode: 
  
     var bluetoothManager = XBBluetoothManager() //初始化
     bluetoothManager.delegate = self  //设置代理 
     bluetoothManager.startScan() //搜索附近的蓝牙设备  
     bluetoothManager.connectPeripheral(peripheral) //连接蓝牙设备 
     
     
    2. ESC-POS Instruction: 

     //初始化打印机
     var printerInitialize: NSData! {
      get { 
          let cmmData = NSMutableData.init() 
          cmmData.appendByte(27) 
          cmmData.appendByte(64) 
          return cmmData   } 
     } 
  
  
     3. 发送打印指令: 
     let cfEnc = CFStringEncodings.GB_18030_2000 
     let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEnc.rawValue)) 
                
      //打印商家名称 
      let cmmStoreNameData = NSMutableData.init() 
      cmmStoreNameData.appendData(printerInitialize) 
      cmmStoreNameData.appendData(printerModel(0)) 
      cmmStoreNameData.appendData(printerCharacterSize(1)) 
      cmmStoreNameData.appendData(printerAlignment(1)) 
      let storeNameData = printTemplate.storeName.dataUsingEncoding(enc) 
      cmmStoreNameData.appendData(storeNameData!) 
      cmmStoreNameData.appendData(printerPaperFeed(2)) 
      bluetoothManager.writeValue(peripheral, data: cmmStoreNameData) 
  
# License
  
  XBPrint is available under the MIT license. See the LICENSE file for more info. <br>
  
  
  
  
  
  
  
  
  

