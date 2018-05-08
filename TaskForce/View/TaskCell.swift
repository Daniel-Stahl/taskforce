//
//  TaskCell.swift
//  TaskForce
//
//  Created by Daniel Stahl on 2/15/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import UIKit

class TaskCell: UICollectionViewCell {
    
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var taskNote: UITextView!
    
    func configureCell(task: Task) {
        self.taskTitle.text = task.taskTitle
        self.taskNote.text = task.taskNotes
    }
}
