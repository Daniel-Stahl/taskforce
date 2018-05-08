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

    
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var taskNote: UITextView!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var progressBar: ProgressBarView!
    
    var passedTitle: String = ""
    var passedNote: String = ""
    var passedRow: Int = 0
    
    var tasks: [Task] = []
    
    var progressCounter: Float = 0
    let duration: Float = 3
    var progressIncrement: Float = 0
    var timer: Timer!

    func initData(title: String, note: String, row: Int) {
        self.passedTitle = title
        self.passedNote = note
        self.passedRow = row
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTask()
        taskTitle.text = passedTitle
        taskNote.text = passedNote
        swipeToClose()
        longPressDeleteTask()
        progressIncrement = 1.0/duration
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.showProgress), userInfo: nil, repeats: true)
    }
    
    @objc func showProgress() {
        
            progressBar.progress = progressCounter
            progressCounter = progressCounter + progressIncrement
    }
    
    func swipeToClose() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(close))
        swipe.direction = .right
        view.addGestureRecognizer(swipe)
    }
    
    @objc func close() {
        dismissDetail()
    }
    
    @IBAction func buttonHeldDown(_ sender: Any) {
        self.progressBar.isHidden = false
        timer.fire()
    }
    
    @IBAction func buttonCancled(_ sender: Any) {
        self.progressBar.isHidden = true
        timer.invalidate()
    }
    
    
    func longPressDeleteTask() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(deleteTask(press:)))
        longPress.minimumPressDuration = 3.0
        completeButton.addGestureRecognizer(longPress)
    }
    
    @objc func deleteTask(press: UILongPressGestureRecognizer) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        managedContext.delete(tasks[passedRow])
        do {
            try managedContext.save()
            print("successfully removed goal")
        } catch {
            debugPrint("Could not remove: \(error.localizedDescription)")
        }
        
        dismissDetail()
    }
    
    func fetchTask() {
        self.fetch { (true) in
            
        }
    }
    
    func fetch(completion: (_ complete: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let fetchRequest = NSFetchRequest<Task>(entityName: "Task")
        
        do {
            tasks = try managedContext.fetch(fetchRequest)
            print("tasks added to array")
            completion(true)
        } catch {
            debugPrint("Could not fetch: \(error.localizedDescription)")
            completion(false)
        }
    }
}
