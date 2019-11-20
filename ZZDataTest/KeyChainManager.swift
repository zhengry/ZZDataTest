//
//  KeyChainManager.swift
//  ZZDataTest
//
//  Created by zry on 2019/11/18.
//  Copyright © 2019 ZRY. All rights reserved.
//

import Foundation

class KeyChainManager: NSObject {
    static let shared:KeyChainManager = KeyChainManager()
    
    /// 生成查询条件
    /// - Parameter identifier: 标识符
    func quaryOptions(forIdentifier identifier:String) -> NSMutableDictionary {
        let keyChainQuaryDict = NSMutableDictionary(capacity: 4)
        // 条件存储的类型
        keyChainQuaryDict.setValue(kSecClassGenericPassword, forKey: kSecClass as String)
        // 设置存储数据的标记
        keyChainQuaryDict.setValue(identifier, forKey: kSecAttrService as String)
        keyChainQuaryDict.setValue(identifier, forKey: kSecAttrAccount as String)
        // 设置数据访问属性
        keyChainQuaryDict.setValue(kSecAttrAccessibleAfterFirstUnlock, forKey: kSecAttrAccessible as String)
        
        return keyChainQuaryDict
    }
    
    /// 保存数据
    /// - Parameters:
    ///   - data: 要保存的数据
    ///   - identifier: 标识符
    func save(data:Any,forIdentifier identifier:String) -> Bool {
        let options = quaryOptions(forIdentifier: identifier)
        // 删除旧的存储数据
        SecItemDelete(options)
        let value = NSKeyedArchiver.archivedData(withRootObject: data)
        options.setValue(value, forKey: kSecValueData as String)
        let saveState = SecItemAdd(options, nil)
        return saveState == noErr
    }
    
    /// 更新数据
    /// - Parameters:
    ///   - data: 要更新的数据
    ///   - identifier: 标识符
    func update(data:Any,forIdentifier identifier:String) -> Bool {
        let options = quaryOptions(forIdentifier: identifier)
        let updateOptions = NSMutableDictionary(capacity: 1)
        let value = NSKeyedArchiver.archivedData(withRootObject: data)
        updateOptions.setValue(value, forKey: kSecValueData as String)
        let updateStatus = SecItemUpdate(options, updateOptions)
        
        return updateStatus == noErr
    }
    
    /// 读取数据
    /// - Parameter identifier: 标识符
    func readData(forIdentifier identifier:String) -> Any? {
        let options = quaryOptions(forIdentifier: identifier)
        options.setValue(kCFBooleanTrue, forKey: kSecReturnData as String)
        options.setValue(kSecMatchLimitOne, forKey: kSecMatchLimit as String)
        var resultObject:Any?
        var result:AnyObject?
        
        // 查询是否存在该数据
        let readStatus = withUnsafeMutablePointer(to: &result) { (pointer) -> OSStatus in
            SecItemCopyMatching(options, pointer)
        }
        if readStatus == errSecSuccess {
            if let data = result as? Data {
                if let obj = NSKeyedUnarchiver.unarchiveObject(with: data) {
                    resultObject = obj// 获取解包后的数据
                }
            }else {
                resultObject = result
            }
        }
        return resultObject
    }
    
    func allDatas() -> [Any] {
        let quary = NSMutableDictionary(capacity: 4)
        // 条件存储的类型
        quary.setValue(kSecClassGenericPassword, forKey: kSecClass as String)
        quary.setValue(kCFBooleanTrue, forKey: kSecReturnData as String)
        quary.setValue(kSecMatchLimitAll, forKey: kSecMatchLimit as String)
        
        var result:AnyObject?
        
        // 查询是否存在该数据
        let readStatus = withUnsafeMutablePointer(to: &result) { (pointer) -> OSStatus in
            SecItemCopyMatching(quary, pointer)
        }
        if readStatus == errSecSuccess {
            if let data = result as? [Data] {
                let array = data.compactMap({ (data) -> Any? in
                    return NSKeyedUnarchiver.unarchiveObject(with: data)
                }) as [Any]
                return array
            }else if let data = result as? [Any] {
                return data
            }
        }
        
        return []
    }
    
    /// 删除数据
    /// - Parameter identifier: 标识符
    func delete(dataForIdentifier identifier:String) -> Bool {
        let options = quaryOptions(forIdentifier: identifier)
        let status = SecItemDelete(options)
        return status == noErr
    }
    
    
}
