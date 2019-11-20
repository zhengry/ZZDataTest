//
//  StudentsViewController.swift
//  ZZDataTest
//
//  Created by zry on 2019/11/19.
//  Copyright © 2019 ZRY. All rights reserved.
//

import UIKit

class StudentsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let cellId = "StudentListCell"
    var students:[String:Any?] = ["id":nil,"name":nil,"age":nil,"sex":nil]
    let keys = ["name","age","sex"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "students"
        
    }
    
    
    // MARK:- CoreData
    func coderTest() {
        let object = SomeObject(name: "an object", age: 10)
        let path = libraryURL.appendingPathComponent("objectArchive", isDirectory: false)
        NSKeyedArchiver.archiveRootObject(object, toFile: path.path)
        
        let obj = NSKeyedUnarchiver.unarchiveObject(withFile: path.path) as! SomeObject
        print("obj name = \(obj.name ?? ""),obj age = \(obj.age)")
    }
    
    func coredataTest()  {
        insertStudents()
        var students = CoreDataStack.filterStudents(withPredicate: "id > 0")
        print("all students:\(students)")

        students = CoreDataStack.filterStudents(withPredicate: "name LIKE '?ong'")
        print("name LIKE '?ong':\(students)")

        changeStudents()
        students = CoreDataStack.filterStudents(withPredicate: "name CONTAINS [cd] 'ang'")
        print("delete 003,name contains ang:\(students)")

        students = CoreDataStack.filterStudents(withPredicate: "age BETWEEN {15,17}")

        print("age between 15~17:\(students)")

        students = CoreDataStack.filterStudents(withPredicate: "name MATCHES '^H.+g$'")

        print("name lick h...g:\(students)")
    }
    
    
    func insertStudents() {
        CoreDataStack.insertStudent(withId: 001, name: "Bob", age: 16, sex: "male")
        CoreDataStack.insertStudent(withId: 002, name: "Lara", age: 18, sex: "female")
        CoreDataStack.insertStudent(withId: 003, name: "LiLei", age: 18, sex: "male")
        CoreDataStack.insertStudent(withId: 006, name: "JiangShan", age: 15, sex: "male")
        CoreDataStack.insertStudent(withId: 004, name: "YangZi", age: 17, sex: "female")
        CoreDataStack.insertStudent(withId: 07, name: "Hua Rong", age: 19, sex: "female")
        let students = CoreDataStack.filterStudents(withPredicate: "id BETWEEN {2,4}")
        
        print("id between 2~4:\(students)")

    }
    
    func changeStudents() {
        CoreDataStack.deleteStudent(withPredicate: "id == 3")
        CoreDataStack.updateStudent(withId: 6, name: "FangHua", age: 15, sex: "female")
        CoreDataStack.deleteStudent(withPredicate: "id == 003")
        
    }
    
    
    

}

extension StudentsViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keys.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let key = keys[indexPath.row]
        cell.textLabel?.text = key
        cell.detailTextLabel?.text = String(describing: students[key] ?? "")
        return cell
    }
}







