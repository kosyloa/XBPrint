//
//  PrintTemplate.swift
//  XBPrint
//
//  Created by xiaobin liu on 16/3/25.
//  Copyright © 2016年 Sky. All rights reserved.
//

import Foundation

/**
 *  打印模版
 */
public struct PrintTemplate {
   
    /// 商店名称
    public var storeName: String!
    
    /// 排队号码
    public var number: String!
    
    /// 桌子类型
    public var tableType: TableType!
    
    /// 等待
    public var waiting: String!
    
    /// 排队时间
    public var time: String!
    
    /// 电话
    public var phone: String!
    
    /// 二维码
    public var qrcode: String!
    
    /// 广告
    public var advertising: String {
        return "扫码查看排队情况提前点菜"
    }
    
    /// 技术支持
    public var technicalSupport: String {
        return "技术支持 0591-XXXXXX"
    }
}


/**
 桌子类型
 */
public enum TableType: Int {
    
    case tableForTwo
    case tableForFour
    case tableForSix
    case tableForEight
    
    
    var tableName: String {
        switch self {
        case .tableForTwo:
            return "2人桌"
        case .tableForFour:
            return "4人桌"
        case .tableForSix:
            return "6人桌"
        case .tableForEight:
            return "8人桌"
        }
    }
}
