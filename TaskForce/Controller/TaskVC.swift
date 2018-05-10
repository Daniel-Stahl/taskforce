//
//  ViewController.swift
//  TaskForce
//
//  Created by Daniel Stahl on 2/11/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import UIKit

class TaskVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func addTaskButton(_ sender: Any) {
        guard let createTaskVC = storyboard?.instantiateViewController(withIdentifier: "CreateTaskVC") else { return }
        presentDetail(createTaskVC)
    }
}
