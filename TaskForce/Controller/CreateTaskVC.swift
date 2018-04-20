//
//  CreateTaskVC.swift
//  TaskForce
//
//  Created by Daniel Stahl on 2/12/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import UIKit
import CoreData

class CreateTaskVC: UIViewController, UITextViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var taskTextView: UITextView!
    @IBOutlet weak var buttonStack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTextView.delegate = self
        buttonStack.bindtoKeyboard()
        swipeToClose()
    }
    
    @IBAction func addTaskButtonPressed(_ sender: Any) {
        if taskTextView.text != "" && taskTextView.text != "Tap to add a task" {
            self.save { (complete) in
                if complete {
                    dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func addNoteButtonPressed(_ sender: Any) {
        if taskTextView.text != "" && taskTextView.text != "Tap to add a task" {
            guard let finishTaskVC = storyboard?.instantiateViewController(withIdentifier: "FinishTaskVC") as? FinishTaskVC else { return }
            finishTaskVC.initData(task: taskTextView.text!)
            presentingViewController?.presentSecondaryDetail(finishTaskVC)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        taskTextView.text = ""
    }
    
    func save(completion: (_ finished: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let task = Task(context: managedContext)
        
        task.taskTitle = taskTextView.text
        task.taskNotes = ""
        
        do {
            try managedContext.save()
            completion(true)
        } catch {
            debugPrint("Could not save: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func swipeToClose() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(close))
        swipe.direction = .right
        view.addGestureRecognizer(swipe)
    }
    
    @objc func close() {
        dismissDetail()
    }
}
