//
//  finishTaskVC.swift
//  TaskForce
//
//  Created by Daniel Stahl on 2/14/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class FinishTaskVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var addTaskButton: UIButton!
    
    var taskTitle: String!
    
    func initData(task: String) {
        self.taskTitle = task
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTaskButton.bindtoKeyboard()
        noteTextView.delegate = self
        
    }

    @IBAction func addTaskButtonPressed(_ sender: Any) {
        if noteTextView.text != "Tap to add a note" {
            self.save { (complete) in
                if complete {
                    dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        noteTextView.text = ""
    }
    
    func save(completion: (_ finished: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let task = Task(context: managedContext)
        
        task.taskTitle = taskTitle
        task.taskNotes = noteTextView.text
        
        do {
            try managedContext.save()
            completion(true)
            print("Saved task and note")
        } catch {
            debugPrint("Could not save: \(error.localizedDescription)")
            completion(false)
        }
    }
}
