# XBPrint
  实现了蓝牙扫描，蓝牙连接，蓝牙断开等一些功能.<br>
  实现了基于esc-pos协议指令的蓝牙打印机的大部分命令.<br>
  实现了二维码的打印.<br>

# Requirements
  iOS8+ <br>
  Xcode7.2 <br>
  
# Example Code 

    1.BluetoothManagerCode: <br>
  
     var bluetoothManager = XBBluetoothManager() //初始化  <br>
     bluetoothManager.delegate = self  //设置代理 <br>
     bluetoothManager.startScan() //搜索附近的蓝牙设备  <br>
     bluetoothManager.connectPeripheral(peripheral) //连接蓝牙设备 <br>
     
     
    2. ESC-POS Instruction: <br>

     //初始化打印机<br>
     var printerInitialize: NSData! { <br>
      get { <br>
          let cmmData = NSMutableData.init() <br>
          cmmData.appendByte(27) <br>
          cmmData.appendByte(64) <br>
          return cmmData <br>  } <br>
     } <br>
  
  
     3. 发送打印指令: <br>
     let cfEnc = CFStringEncodings.GB_18030_2000 <br>
     let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEnc.rawValue)) <br>
                
      //打印商家名称 <br>
      let cmmStoreNameData = NSMutableData.init() <br>
      cmmStoreNameData.appendData(printerInitialize) <br>
      cmmStoreNameData.appendData(printerModel(0)) <br>
      cmmStoreNameData.appendData(printerCharacterSize(1)) <br>
      cmmStoreNameData.appendData(printerAlignment(1)) <br>
      let storeNameData = printTemplate.storeName.dataUsingEncoding(enc) <br>
      cmmStoreNameData.appendData(storeNameData!) <br>
      cmmStoreNameData.appendData(printerPaperFeed(2)) <br>
      bluetoothManager.writeValue(peripheral, data: cmmStoreNameData) <br>
  
# License
  
  XBPrint is available under the MIT license. See the LICENSE file for more info. <br>
  
  
  
  
  
  
  
  
  

