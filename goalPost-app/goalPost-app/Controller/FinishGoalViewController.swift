//
//  FinishGoalViewController.swift
//  goalPost-app
//
//  Created by Gulnara Saimassay on 7/27/20.
//  Copyright © 2020 Gulnara Saimassay. All rights reserved.
//

import UIKit
import CoreData

class FinishGoalViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var createGoalBtn: UIButton!
    @IBOutlet weak var pointsTextField: UITextField!
    
    var goalDescription: String!
    var goalType: GoalType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createGoalBtn.bindingToKeyboard()
        pointsTextField.delegate = self
    }
    
    func initData(description: String, type: GoalType){
        self.goalDescription = description
        self.goalType = type
    }

    @IBAction func createGoalBtnWasPressed(_ sender: Any) {
        //Pass data into coredata model
        if pointsTextField.text != ""{
            self.save { (complete) in
                if complete{
                    dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func backBtnWasPressed(_ sender: Any) {
        dismissDetail()
    }
    
    func save(completion: (_ finished: Bool) -> ()){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else{ return }
        let goal = Goal(context: managedContext)
        goal.goalDescription = goalDescription
        goal.goalType = goalType.rawValue
        goal.goalCompletionValue = Int32(pointsTextField.text!)!
        goal.goalProgress = Int32(0)
        
        do{
            try managedContext.save()
            print("Successfully saved data")
            completion(true)
        } catch{
            debugPrint("Could not save: \(error.localizedDescription )")
            completion(false)
        }
    }
}
