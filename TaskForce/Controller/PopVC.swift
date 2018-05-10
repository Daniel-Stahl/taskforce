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

    let shapeLayer = CAShapeLayer()
    let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
    
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var taskNote: UITextView!
    @IBOutlet weak var completeButton: UIButton!
    
    var passedTitle: String = ""
    var passedNote: String = ""
    var passedRow: Int = 0
    
    var tasks: [Task] = []

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
        circleProgressBar()
    }
    
    func swipeToClose() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(close))
        swipe.direction = .right
        view.addGestureRecognizer(swipe)
    }
    
    @objc func close() {
        dismissDetail()
    }
    
    func circleProgressBar() {
        let center = view.center
        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.strokeEnd = 0
        view.layer.addSublayer(shapeLayer)
    }
    
    @IBAction func buttonHeldDown(_ sender: Any) {
        shapeLayer.isHidden = false
        basicAnimation.toValue = 1
        basicAnimation.duration = 3.7
        shapeLayer.add(basicAnimation, forKey: "progressBar")
    }
    
    @IBAction func buttonCancled(_ sender: Any) {
        shapeLayer.isHidden = true
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
