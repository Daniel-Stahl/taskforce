//
//  PopVC.swift
//  TaskForce
//
//  Created by Daniel Stahl on 4/19/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import UIKit
import CoreData

class PopVC: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var taskTitle: UITextView!
    @IBOutlet weak var taskNote: UITextView!
    @IBOutlet weak var completeButton: UIButton!
    
    var passedTitle: String = ""
    var passedNote: String = ""
    
    var tasks: [Task] = []
    
    func initData(title: String, note: String) {
        self.passedTitle = title
        self.passedNote = note
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTitle.text = passedTitle
        taskNote.text = passedNote
        swipeToClose()
        longPressDeleteTask()
    }
    
    func swipeToClose() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(close))
        swipe.direction = .right
        view.addGestureRecognizer(swipe)
    }
    
    @objc func close() {
        dismissDetail()
    }
    
    func longPressDeleteTask() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(deleteTask(press:)))
        longPress.minimumPressDuration = 3.0
        completeButton.addGestureRecognizer(longPress)
    }
    
    @objc func deleteTask(press: UILongPressGestureRecognizer) {
        self.fetch { (success) in
            if success {
                print(tasks)
            }
        }
    }
    
    func fetch(completion: (_ complete: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let fetchRequest = NSFetchRequest<Task>(entityName: "Task")
        
        do {
            tasks = try managedContext.fetch(fetchRequest)
            print("fetched task")
            completion(true)
        } catch {
            debugPrint("Could not fetch: \(error.localizedDescription)")
            completion(false)
        }
    }
    
//    func removeGoal(atIndexPath indexPath: IndexPath) {
//        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
//
//        managedContext.delete(tasks[indexPath.row])
//
//        do {
//            try managedContext.save()
//            print("successfully removed goal")
//        } catch {
//            debugPrint("Could not remove: \(error.localizedDescription)")
//        }
//    }
}
