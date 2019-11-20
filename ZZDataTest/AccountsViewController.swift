//
//  AccountsViewController.swift
//  ZZDataTest
//
//  Created by zry on 2019/11/19.
//  Copyright © 2019 ZRY. All rights reserved.
//

import UIKit

class AccountsViewController: UITableViewController {

    var accounts = [[String:String]]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "accounts"
        
        let addBtn = UIBarButtonItem(title: "+", style: .done, target: self, action: #selector(addAccount))
        navigationItem.rightBarButtonItem = addBtn
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let result = KeyChainManager.shared.allDatas()
        print("result = \(result)")
        if result as? [[String:String]] != nil {
            accounts = result as! [[String:String]]
            tableView.reloadData()
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        
    }
    
    @objc func addAccount() {
        let storyboard = UIStoryboard(name: "AccountEditViewController", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AccountEditViewController") as! AccountEditViewController
        navigationController?.pushViewController(controller, animated: true)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return accounts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let account = accounts[indexPath.row]
        cell.textLabel?.text = account["name"]

        return cell
    }


    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let account = self.accounts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            guard KeyChainManager.shared.delete(dataForIdentifier: account["id"]!) else {
                fatalError("删除失败")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let account = accounts[indexPath.row]
        let storyboard = UIStoryboard(name: "\(AccountEditViewController.self)", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "\(AccountEditViewController.self)") as! AccountEditViewController
        vc.accountId = account["id"]
        vc.accountName = account["name"]
        vc.accountPassword = account["password"] 
        navigationController?.pushViewController(vc, animated: true)
        
    }
    

    
    
    

}
