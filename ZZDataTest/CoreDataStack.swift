//
//  CoreDataStack.swift
//  ZZDataTest
//
//  Created by zry on 2019/11/8.
//  Copyright © 2019 ZRY. All rights reserved.
//

import UIKit
import CoreData

class CoreDataStack: NSObject {
    static let shared = CoreDataStack()
    
    lazy var documentDir:URL = {
        let dir = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first
        return dir!
    }()
    
    // 存储数据
    func saveStudentContext() {
        do {
            try studentContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    lazy var managedModel:NSManagedObjectModel = {
        // resource名字保持跟xcdatamodeld文件名保持一致
        let url = Bundle.main.url(forResource: "School", withExtension: "momd")
        let model = NSManagedObjectModel(contentsOf: url!)
        return model!
    }()
    
    lazy var studentCoordinator:NSPersistentStoreCoordinator = {
        let coor = NSPersistentStoreCoordinator(managedObjectModel: managedModel)
        let sqlURL = documentDir.appendingPathComponent("school.sqlite")
        let options = [NSMigratePersistentStoresAutomaticallyOption:true,
                       NSInferMappingModelAutomaticallyOption:true]
        var failureReason = "there an error when creating a coordinator for persistent store"
        do {
            try coor.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: sqlURL, options: options)
        } catch {
            // Report any error we got.
            var dict = [String: Any]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as Any?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as Any?
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 6666, userInfo: dict)
            print("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }

        return coor
    }()
    
    // 获取上下文
    lazy var studentContext:NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        context.persistentStoreCoordinator = studentCoordinator
        return context
    }()
    

    // MARK: - Student Model
    class func fetchStudentRequest()->NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        request.returnsObjectsAsFaults = false
        return request
    }
    
    
    class func insertStudent(withId id:Int,name:String,age:Int,sex:String) {
        let results = filterStudents(withPredicate: "id == \(id)")
        if !results.isEmpty {
            updateStudent(withId: id, name: name, age: age, sex: sex)
            return
        }
        
        let student = NSEntityDescription.insertNewObject(forEntityName: "Student", into: CoreDataStack.shared.studentContext) as! Student
        student.id = Int16(id)
        student.name = name
        student.age = Int16(age)
        student.sex = sex
        CoreDataStack.shared.saveStudentContext()
    }
    
    class func filterStudents(withPredicate formater:String)->[Student]{
        
        let request = fetchStudentRequest()
        let predicate = NSPredicate(format: formater)
        request.predicate = predicate
        let sortById = NSSortDescriptor(key: "id", ascending: true)
        let sortByAge = NSSortDescriptor(key: "age", ascending: true)
        request.sortDescriptors = [sortByAge,sortById]
        if let results = try? CoreDataStack.shared.studentContext.fetch(request) as? [Student] {
            return results
        }
        return []
        
    }
    
    class func updateStudent(withId id:Int,name:String,age:Int,sex:String) {
        
        let students = filterStudents(withPredicate: "id == \(id)")
        
        if !students.isEmpty {
            let student = students.first!
            student.name = name
            student.age = Int16(age)
            student.sex = sex
            CoreDataStack.shared.saveStudentContext()
        }else {
            insertStudent(withId: id, name: name, age: age, sex: sex)
        }
        
    }
    
    class func deleteStudent(withPredicate formater:String){
        let results = filterStudents(withPredicate: formater)
        if !results.isEmpty {
            for student in results {
                CoreDataStack.shared.studentContext.delete(student)
            }
            CoreDataStack.shared.saveStudentContext()
        }
    }
    
    
    
    
    // MARK: - Teacher Model
    
    
    lazy var teacherCoordinator:NSPersistentStoreCoordinator = {
        let coor = NSPersistentStoreCoordinator(managedObjectModel: managedModel)
        let sqlURL = documentDir.appendingPathComponent("teacher.sqlite")
        let options = [NSMigratePersistentStoresAutomaticallyOption:true,
                       NSInferMappingModelAutomaticallyOption:true]
        var failureReason = "there an error when creating a coordinator for persistent store"
        do {
            try coor.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: sqlURL, options: options)
        } catch {
            // Report any error we got.
            var dict = [String: Any]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as Any?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as Any?
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 6666, userInfo: dict)
            print("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }

        return coor
    }()
    
    // 获取上下文
    lazy var teacherContext:NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        context.persistentStoreCoordinator = teacherCoordinator
        return context
    }()
    
    func saveTeacherContext() {
        do {
            try teacherContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    class func fetchTeacherRequest() -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"Teacher")
        request.returnsObjectsAsFaults = false
        return request
    }
    
    class func filterTeacher(withPridicate formator:String) -> [Teacher] {
        let request = fetchTeacherRequest()
        let predicate = NSPredicate(format: formator)
        request.predicate = predicate
        let sortById = NSSortDescriptor(key: "id", ascending: true)
        request.sortDescriptors = [sortById]
        if let results = try? CoreDataStack.shared.teacherContext.fetch(request) as? [Teacher]{
            return results
        }
        return []
    }
    
    class func insertTeacher(withId id:Int, name:String, course:String) {
        let results = filterTeacher(withPridicate: "id == \(id)")
        if !results.isEmpty {
            updateTeacher(withId: id, name: name, course: course)
            return
        }
        let teacher = NSEntityDescription.insertNewObject(forEntityName: "Teacher", into: CoreDataStack.shared.teacherContext) as! Teacher
        teacher.id = Int16(id)
        teacher.name = name
        teacher.course = course
        CoreDataStack.shared.saveTeacherContext()
        
    }
    
    
    class func updateTeacher(withId id:Int, name:String, course:String) {
        let results = filterTeacher(withPridicate: "id == \(id)")
        if !results.isEmpty{
            let teacher = results.first!
            teacher.name = name
            teacher.course = course
            CoreDataStack.shared.saveTeacherContext()
            return
        }
        insertTeacher(withId: id, name: name, course: course)
    }
    
    class func deleteTeacher(withPredicate formater:String) {
        let results = filterTeacher(withPridicate: formater)
        if !results.isEmpty {
            for teacher in results {
                CoreDataStack.shared.teacherContext.delete(teacher)
            }
            CoreDataStack.shared.saveTeacherContext()
        }
    }
}
