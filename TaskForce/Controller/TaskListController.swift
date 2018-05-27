//
//  TaskListController.swift
//  TaskForce
//
//  Created by Daniel Stahl on 4/30/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import UIKit
import CoreData

class TaskListController: UICollectionViewController {
    private var indexOfCellBeforeDragging = 0
    private var collectionViewFlowLayout: UICollectionViewFlowLayout {
        return collectionViewLayout as! UICollectionViewFlowLayout
    }
    
    var tasks: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForPreviewing(with: self, sourceView: collectionView!)
        collectionViewFlowLayout.minimumLineSpacing = 0
    }
    
//    func checkDevice() {
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            
//        } else {
//            registerForPreviewing(with: self, sourceView: collectionView!)
//        }
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchTasks()
        collectionView?.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureCollectionViewLayoutItemSize()
    }
    
    func fetchTasks() {
        self.fetch { (complete) in
            if complete {
                if tasks.count >= 1 {
                    collectionView?.isHidden = false
                } else {
                    collectionView?.isHidden = true
                }
            }
        }
    }
    
    private func configureCollectionViewLayoutItemSize() {
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionViewFlowLayout.itemSize = CGSize(width: collectionViewLayout.collectionView!.frame.size.width, height: collectionViewLayout.collectionView!.frame.size.height)
    }
    
    private func indexOfMajorCell() -> Int {
        let itemWidth = collectionViewFlowLayout.itemSize.width
        let proportionalOffset = collectionViewLayout.collectionView!.contentOffset.x / itemWidth
        return Int(round(proportionalOffset))
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        indexOfCellBeforeDragging = indexOfMajorCell()
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset
        
        let indexOfMajorCell = self.indexOfMajorCell()
        
        let dataSourceCount = collectionView(collectionView!, numberOfItemsInSection: 0)
        let swipeVelocityThreshold: CGFloat = 0.5
        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < dataSourceCount && velocity.x > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
        let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
        
        if didUseSwipeToSkipCell {
            
            let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
            let toValue = collectionViewFlowLayout.itemSize.width * CGFloat(snapToIndex)
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
                scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                scrollView.layoutIfNeeded()
            }, completion: nil)
            
        } else {
            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
            collectionViewLayout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "taskCell", for: indexPath) as? TaskCell else { return UICollectionViewCell() }
        let task = tasks[indexPath.row]
        cell.configureCell(task: task)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            guard let popVC = storyboard?.instantiateViewController(withIdentifier: "PopVC") as? PopVC else { return }
            
            let choosenTask = tasks[indexPath.row]
            
            popVC.initData(title: choosenTask.taskTitle!, note: choosenTask.taskNotes!, row: indexPath.row)
            
            presentDetail(popVC)
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

extension TaskListController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = collectionView?.indexPathForItem(at: location), let cell = collectionView?.cellForItem(at: indexPath) else { return nil }
        
        guard let popVC = storyboard?.instantiateViewController(withIdentifier: "PopVC") as? PopVC else { return nil }
        
        let choosenTask = tasks[indexPath.row]
        
        popVC.initData(title: choosenTask.taskTitle!, note: choosenTask.taskNotes!, row: indexPath.row)
        
        previewingContext.sourceRect = cell.contentView.frame
        return popVC
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
}
