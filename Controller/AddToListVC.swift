//
//  AddToListVC.swift
//  ToDoListApp-ProjectTaskSession 11 LVL 2
//
//  Created by abdurhman elbosaty on 30/07/2021.
//

import UIKit
import CoreData

var apDelegate = UIApplication.shared.delegate as! AppDelegate
var context = apDelegate.persistentContainer.viewContext

class AddToListVC: UIViewController {

    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            containerView.layer.cornerRadius = 10
            containerView.layer.borderWidth = 1
            containerView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var dismessBtnOutlet: UIButton!
    @IBOutlet weak var enterNotesTF: UITextField!
    
    
    var delegate: PassDataBetweenVC?
    var time = ""
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    //MARK: - IBActions
    @IBAction func addToListBtnPressed(_ sender: UIButton) {
        getTime()
        if enterNotesTF.text != "" {
            dismiss(animated: true) {
              //  self.delegate?.passData(note: self.enterNotesTF.text!, time: self.time)
                //self.saveToCoreData()
                self.addNote()
            }
        }
    }
    @IBAction func dismessBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helper Functions
    
//    func saveToCoreData(){
//        let note = NoteData(context: context)
//        note.noteName = self.enterNotesTF.text
//        note.noteTime = self.time
//           apDelegate.saveContext()
//        self.delegate?.passFullData(notesData: note)
//        print(note.noteName ?? "")
//        print("saved")
//    }
    
    
    
    func addNote(){
        let newNote = NSEntityDescription.insertNewObject(forEntityName: "NoteData", into: context)

        guard let noteText = self.enterNotesTF.text else { return }
        newNote.setValue("\(noteText)", forKey: "noteName")
        newNote.setValue("\(self.time)", forKey: "noteTime")
        
        self.delegate?.passFullData(notesData: newNote as! NoteData)

        do{
            try context.save()
            print("success")
        }
        catch {
            print(error)
        }
    }
    
    func getTime(){
        
        let datetime = Date()
        let dateFormater = DateFormatter()

        dateFormater.timeStyle = .short
        dateFormater.dateStyle = .short
        let dateString = dateFormater.string(from: datetime)
        print(dateString)
        time = "\(dateString)"
    }
    
}
