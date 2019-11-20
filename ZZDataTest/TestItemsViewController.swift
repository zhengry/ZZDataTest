//
//  TestItemsViewController.swift
//  ZZDataTest
//
//  Created by zry on 2019/11/19.
//  Copyright © 2019 ZRY. All rights reserved.
//

import UIKit

class TestItemsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let cellId = "Cell"
    let items = ["CoreData","KeyChain","Sandbox"]
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "test items"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }


    

}

extension TestItemsViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
}

extension TestItemsViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let storyboard = UIStoryboard(name: "StudentsViewController", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "StudentsViewController") as! StudentsViewController
            navigationController?.pushViewController(controller, animated: true)
        case 1:
            let controller = AccountsViewController()
            navigationController?.pushViewController(controller, animated: true)
        case 2: print("sandbox")
        default: fatalError()
        }
    }
}
