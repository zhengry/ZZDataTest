//
//  AccountEditViewController.swift
//  ZZDataTest
//
//  Created by zry on 2019/11/19.
//  Copyright © 2019 ZRY. All rights reserved.
//

import UIKit

class AccountEditViewController: UITableViewController {

    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var accountId:String?
    var accountName:String?
    var accountPassword:String?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "edit account"
        let cancelBtn = UIBarButtonItem(title: "cancel", style: .done, target: self, action: #selector(goBack))
        navigationItem.leftBarButtonItem = cancelBtn
        
        let saveBtn = UIBarButtonItem(title: "save", style: .done, target: self, action: #selector(saveAccountInfo))
        navigationItem.rightBarButtonItem = saveBtn
        
        idField.text = accountId
        nameField.text = accountName
        passwordField.text = accountPassword
        idField.isUserInteractionEnabled = (accountId == nil)
        
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func saveAccountInfo() {
        guard let identifier = idField.text,!identifier.isEmpty else { return }
        guard let name = nameField.text,!name.isEmpty else { return }
        guard let password = passwordField.text,!password.isEmpty else { return }
        
        let account = ["id":identifier,
                       "name":name,
                       "password":password]
        
        if identifier == self.accountId {
            guard KeyChainManager.shared.update(data: account, forIdentifier: identifier) else {
                print("更新失败")
                return
            }
            print("更新成功")
            goBack()
            return
        }
        
        
        if KeyChainManager.shared.save(data: account, forIdentifier: identifier){
            print("存储成功")
            goBack()
        }else {
            print("保存失败")
        }
    }
    


}
