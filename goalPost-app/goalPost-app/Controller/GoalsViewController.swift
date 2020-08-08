//
//  GoalsViewController.swift
//  goalPost-app
//
//  Created by Gulnara Saimassay on 7/26/20.
//  Copyright © 2020 Gulnara Saimassay. All rights reserved.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class GoalsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var undoView: UIView!
    
    var goals: [Goal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = false
        undoView.isHidden = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchCoreDataObjects()
        tableView.reloadData()
        
        
    }
    
    func fetchCoreDataObjects(){
        self.fetch { (complete) in
        if complete{
            if goals.count >= 1{
                tableView.isHidden = false
            } else{
                tableView.isHidden = true
            }
          }
        }
    }
    
    @IBAction func addGoalBtnWasPressed(_ sender: Any) {
        guard let createGoalVC = storyboard?.instantiateViewController(withIdentifier: "CreateGoalViewController") else {return}
        presentDetail(createGoalVC)
    }
    
    @IBAction func undoBtnWasPressed(_ sender: Any) {
        print("undo pressed")
        
       }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return goals.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           guard let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell") as? GoalTableViewCell else { return UITableViewCell() }
           let goal = goals[indexPath.row]
           cell.configureCell(goal: goal)
           return cell
       }
       func numberOfSections(in tableView: UITableView) -> Int {
           return  1
       }
       
       func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
           return true
       }
       func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
           return .none
       }
       func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
           let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { (rowAction, indexPath) in
               self.removeGoal(atIndexPath: indexPath)
               self.fetchCoreDataObjects()
               tableView.deleteRows(at: [indexPath], with: .automatic)
           }
           let addProgressAction = UITableViewRowAction(style: .normal, title: "ADD 1") { (rowAction, indexPath) in
               self.setProgress(atIndexPath: indexPath)
               tableView.reloadRows(at: [indexPath], with: .automatic)
           }
           
           deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
           addProgressAction.backgroundColor = #colorLiteral(red: 0.9385011792, green: 0.7164435983, blue: 0.3331357837, alpha: 1)
           
           return [deleteAction, addProgressAction]
       }
       

}

extension GoalsViewController {
    func setProgress(atIndexPath indexPath: IndexPath){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        let chosenGoal = goals[indexPath.row]
        if chosenGoal.goalProgress < chosenGoal.goalCompletionValue{
            chosenGoal.goalProgress += 1
        }else{
            return
        }
        do{
            try managedContext.save()
            print("Successfully set progress")
        }catch{
            debugPrint("Could not set progress: \(error.localizedDescription)")
        }
        
    }
    
    func removeGoal(atIndexPath indexPath: IndexPath){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        managedContext.delete(goals[indexPath.row])
        
        do{
            try managedContext.save()
            print("Successfully removed goal")
        }catch{
            debugPrint("COuld not remove: \(error.localizedDescription)")
            
        }
    }
    
    func fetch(completion: (_ complete: Bool) -> ()){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
        do{
            goals = try managedContext.fetch(fetchRequest)
            print("Successfully fetched data")
            completion(true)
        } catch{
            debugPrint("Could not fetch: \(error.localizedDescription)")
            completion(false)
        }
       
        
    }
    
    func undoDelete(){
        //guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        //managedContext.undoManager?.canUndo
    }
    
}
