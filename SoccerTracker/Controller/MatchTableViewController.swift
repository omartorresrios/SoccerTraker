//
//  MatchesTableViewController.swift
//  SoccerTracker
//
//  Created by Omar Torres on 1/2/19.
//  Copyright © 2019 OmarTorres. All rights reserved.
//

import UIKit
import Firebase
import Floaty

class MatchTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    let pickerView: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    var currentTextField: UITextField = {
        let tf = UITextField()
        return tf
    }()
    
    var firstTeamTextField: UITextField = {
        let tf = UITextField()
        return tf
    }()
    
    var secondTeamTextField: UITextField = {
        let tf = UITextField()
        return tf
    }()
    
    var teams = [String]()
    var matches = [Match]()
    var firstTeamName: String?
    var secondTeamName: String?
    var firstTeamGoals: String?
    var secondTeamGoals: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllMatches()
        fetchAllTeams()
        setupFloatButton()
    }
    
    func fetchAllMatches() {
        databaseRef.child("Matches").observe(.childAdded, with: { (snapshot) in
            print("snapshot: ", snapshot)
            if let dictionary = snapshot.value as? [String: AnyObject] {
                guard let firstTeamDict = dictionary["Team1"] as? [String: AnyObject] else { return }
                guard let secondTeamDict = dictionary["Team2"] as? [String: AnyObject] else { return }
                let score = dictionary["score"] as? String ?? ""
                
                let match = Match(score: score, firstTeamDict: firstTeamDict, secondTeamDict: secondTeamDict)
                self.matches.append(match)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    func fetchAllTeams() {
        databaseRef.child("Teams").observe(.childAdded, with: { (snapshot) in
            if let teamDictionary = snapshot.value as? [String: AnyObject] {
                let teamName = teamDictionary["name"] as! String
                self.teams.append(teamName)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    func setupFloatButton() {
        Floaty.global.button.addItem("Agregar partido", icon: UIImage(named: "plus"), handler: { _ in
            self.addANewMatch()
        })
    }
    
    func addANewMatch() {
        DispatchQueue.main.async {
            Floaty.global.hide()
        }
        
        let alertController = UIAlertController(title: "Nuevo partido", message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.delegate = self
            self.firstTeamTextField = textField
            self.firstTeamTextField.placeholder = "Nombre del primer equipo"
        }
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.delegate = self
            self.secondTeamTextField = textField
            self.secondTeamTextField.placeholder = "Nombre del segundo equipo"
        }
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Goles del primer equipo"
            textField.keyboardType = .numberPad
        }
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Goles del segundo equipo"
            textField.keyboardType = .numberPad
        }
        
        let saveAction = UIAlertAction(title: "Guardar", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            self.firstTeamName = firstTextField.text!
            let secondTextField = alertController.textFields![1] as UITextField
            self.secondTeamName = secondTextField.text!
            let thirdTextField = alertController.textFields![2] as UITextField
            self.firstTeamGoals = thirdTextField.text!
            let fourthTextField = alertController.textFields![3] as UITextField
            self.secondTeamGoals = fourthTextField.text!
            
            let scoreText = "\(thirdTextField.text!)" + "-" + "\(fourthTextField.text!)"
            
            self.saveNewMatchInFirebase(firstTeamName: self.firstTeamName!, secondTeamName: self.secondTeamName!, firstTeamGoals: self.firstTeamGoals!, secondTeamGoals: self.secondTeamGoals!, score: scoreText)
            
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
    
    func saveNewMatchInFirebase(firstTeamName: String, secondTeamName: String, firstTeamGoals: String, secondTeamGoals: String, score: String) {
        let newMatch = databaseRef.child("Matches").childByAutoId()
        newMatch.setValue(["score": score])
        newMatch.child("Team1").setValue(["name": firstTeamName, "goals": firstTeamGoals])
        newMatch.child("Team2").setValue(["name": secondTeamName, "goals": secondTeamGoals])
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return teams.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return teams[row]
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if currentTextField == firstTeamTextField {
            firstTeamTextField.text = teams[row]
        } else if currentTextField == secondTeamTextField {
            secondTeamTextField.text = teams[row]
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "matchCell", for: indexPath) as! MatchTableViewCell
        cell.matchData = matches[indexPath.row]
        return cell
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        currentTextField = textField
        if currentTextField == firstTeamTextField {
            currentTextField.inputView = pickerView
        } else if currentTextField == secondTeamTextField {
            currentTextField.inputView = pickerView
        }
    }
    
}
