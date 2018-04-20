//
//  ViewController.swift
//  TaskForce
//
//  Created by Daniel Stahl on 2/11/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import UIKit
import CoreData

class TaskVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var tasks: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        registerForPreviewing(with: self, sourceView: collectionView!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTasks()
        collectionView.reloadData()
    }
    
    func fetchTasks() {
        self.fetch { (complete) in
            if complete {
                if tasks.count >= 1 {
                    collectionView.isHidden = false
                } else {
                    collectionView.isHidden = true
                }
            }
        }
    }

    @IBAction func addTaskButton(_ sender: Any) {
        guard let createTaskVC = storyboard?.instantiateViewController(withIdentifier: "CreateTaskVC") else { return }
        presentDetail(createTaskVC)
    }
}

extension TaskVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "taskCell", for: indexPath) as? TaskCell else { return UICollectionViewCell() }
        let task = tasks[indexPath.row]
        cell.configureCell(task: task)
        return cell
    }
}

extension TaskVC {
    func removeTask(atIndexPath indexPath: IndexPath) {
        guard let managedConext = appDelegate?.persistentContainer.viewContext else { return }
        
        managedConext.delete(tasks[indexPath.row])
        
        do {
            try managedConext.save()
            print("Successfully removed task")
        } catch {
            debugPrint("Could not remove: \(error.localizedDescription)")
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
}

extension TaskVC: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = collectionView?.indexPathForItem(at: location), let cell = collectionView?.cellForItem(at: indexPath) else { return nil }
        
        guard let popVC = storyboard?.instantiateViewController(withIdentifier: "PopVC") as? PopVC else { return nil }
        
        let choosenTask = tasks[indexPath.row]

        popVC.initData(title: choosenTask.taskTitle!, note: choosenTask.taskNotes!)
        
        
        previewingContext.sourceRect = cell.contentView.frame
        return popVC
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
}




