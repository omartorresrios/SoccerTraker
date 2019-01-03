//
//  TeamsTableViewController.swift
//  SoccerTracker
//
//  Created by Omar Torres on 1/2/19.
//  Copyright © 2019 OmarTorres. All rights reserved.
//

import UIKit
import Firebase
import Floaty

class TeamTableViewController: UITableViewController {
    
    var teams = [Team]()
    var teamName: String?
    var teamScore: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFloatingActionButton()
        fetchTeams()
    }
    
    func setupFloatingActionButton() {
        Floaty.global.button.buttonImage = UIImage(named: "plus")
        Floaty.global.button.buttonColor = UIColor.white
        
        Floaty.global.button.addItem("Agregar equipo", icon: UIImage(named: "plus"), handler: { _ in
            self.addANewTeam()
        })
        
        if let tabBarHeight = self.tabBarController?.tabBar.frame.size.height {
            Floaty.global.button.paddingY = tabBarHeight
            Floaty.global.button.openAnimationType = .fade
            Floaty.global.show()
        }
    }
    
    func fetchTeams() {
        DataService.shared.fetchTeams { (teams) in
            self.teams = teams
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func addANewTeam() {
        DispatchQueue.main.async {
            Floaty.global.hide()
        }
        
        let alertController = UIAlertController(title: "Nuevo equipo", message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Nombre del equipo"
        }
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Puntuación"
            textField.keyboardType = .numberPad
        }
        
        let saveAction = UIAlertAction(title: "Guardar", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            self.teamName = firstTextField.text!
            let secondTextField = alertController.textFields![1] as UITextField
            self.teamScore = secondTextField.text!
            
            self.saveNewTeamInFirebase(teamName: self.teamName!, teamScore: self.teamScore!)
            
            DispatchQueue.main.async {
                Floaty.global.show()
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func saveNewTeamInFirebase(teamName: String, teamScore: String) {
        databaseRef.child("Teams").childByAutoId().setValue(["name": teamName , "score": teamScore])
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teamCell", for: indexPath) as! TeamTableViewCell
        cell.team = teams[indexPath.row]
        return cell
    }
}
