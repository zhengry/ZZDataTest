//
//  MineViewController.swift
//  ZZDataTest
//
//  Created by zry on 2019/11/8.
//  Copyright © 2019 ZRY. All rights reserved.
//

import UIKit

class MineViewController: UIViewController {

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .yellow
//
//        createDirectionary()
//        createFile()
//
//        DispatchQueue.global(qos: .background).asyncAfter(deadline: DispatchTime.init(uptimeNanoseconds: 300)) {
//            self.moveFile()
//            self.moveDir()
//        }
//        coderTest()

    }

    // MARK:- 存储路径
    /// 新建文件夹
    func createDirectionary() {
        let url = URL(fileURLWithPath: docPath!)
        let path = url.appendingPathComponent("zrydir")
        if !FileManager.default.fileExists(atPath: path.path) {
            do {
               try  FileManager.default.createDirectory(at: path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("create dir error:\(error.localizedDescription)")
            }
            
        }
        
    }
    
    /// 创建文件
    func createFile() {

        let contents = "zry"
        let data = contents.data(using: .utf8)
        let url = URL(fileURLWithPath: docPath!)
        let path = url.appendingPathComponent("zryfile.txt", isDirectory: false)
        if !FileManager.default.fileExists(atPath: path.path) {
            FileManager.default.createFile(atPath: path.path, contents: data, attributes: nil)
            return
        }
        do {
            try data?.write(to: path)
        } catch {
            print("create error:\(error.localizedDescription)")
        }
        // 如果zryfile.txt不存在，会自动创建这个文件，并写入数据
//        contents = "what are you doing？"
//        data?.append(contents.data(using: .utf8)!)
//        try? data?.write(to: path)
        var oldData = try? Data(contentsOf: path)
        oldData?.append(contents.data(using: .utf8)!)
        
    }
    
    /// 删除文件
    func deleteFile() {
        let url = URL(fileURLWithPath: docPath!)
        let path = url.appendingPathComponent("zryfile.txt", isDirectory: false)
        do {
            try FileManager.default.removeItem(at: path)
        } catch {
            print("deleteDir error:\(error.localizedDescription)")
        }
    }
    
    /// 删除文件夹
    func deleteDir() {
        let url = URL(fileURLWithPath: docPath!)
        let path = url.appendingPathComponent("zrydir")
        do {
            try FileManager.default.removeItem(at: path)
        } catch {
            print("deleteDir error:\(error.localizedDescription)")
        }
    }
    
    /// 移动文件
    func moveFile() {
        let url = URL(fileURLWithPath: docPath!)
        let filePath = url.appendingPathComponent("zryfile.txt", isDirectory: false)
        
        let newPath = libraryURL.appendingPathComponent("zryfile.txt", isDirectory: false)

        if FileManager.default.fileExists(atPath: filePath.path) {
            // 检查新路径是否已经存在该文件
            if FileManager.default.fileExists(atPath: newPath.path) {
                do {
                    try FileManager.default.removeItem(at: newPath)
                }catch {
                    print("newpath delete error:\(error.localizedDescription)")
                }
            }
            do {
                try FileManager.default.moveItem(at: filePath, to: newPath)
            } catch  {
                print("move error:\(error.localizedDescription)")
            }
        }
    }
    
    
    /// 移动文件夹
    func moveDir() {
        let url = URL(fileURLWithPath: docPath!)
        let dirPath = url.appendingPathComponent("zrydir", isDirectory: true)
        
        if FileManager.default.fileExists(atPath: dirPath.path) {
            let newPath = libraryURL.appendingPathComponent("zrydir", isDirectory: true)
            // 判断新路径下是否已经存在该文件夹
            if FileManager.default.fileExists(atPath: newPath.path) {
                do {
                    try FileManager.default.removeItem(at: newPath)
                } catch {
                    print("new dir delete error:\(error.localizedDescription)")
                }
            }
            do {
                try FileManager.default.moveItem(at: dirPath, to: newPath)
            } catch {
                print("move dir error:\(error.localizedDescription)")
            }
        }
    }
    
    
    
}

class SomeObject:NSObject, NSCoding,Codable {
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(age, forKey: "age")
    }
    
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as? String
        age = coder.decodeInteger(forKey: "age")
    }
    
    var name:String?
    var age:Int = 0

    init(name:String?,age:Int) {
        self.name = name
        self.age = age
    }
    
}
