//
//  PopVC.swift
//  TaskForce
//
//  Created by Daniel Stahl on 4/19/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import UIKit

class PopVC: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var taskTitle: UITextView!
    @IBOutlet weak var taskNote: UITextView!
    
    var passedTitle: String = ""
    var passedNote: String = ""
    
    func initData(title: String, note: String) {
        self.passedTitle = title
        self.passedNote = note
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTitle.text = passedTitle
        taskNote.text = passedNote
        swipeToClose()
    }
    
    func swipeToClose() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(close))
        swipe.direction = .right
        view.addGestureRecognizer(swipe)
    }
    
    @objc func close() {
        dismissDetail()
    }
    
    @IBAction func completeTaskButtonPressed(_ sender: Any) {
        
    }
}
