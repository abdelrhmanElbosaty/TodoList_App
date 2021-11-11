//
//  ViewController.swift
//  ToDoListApp-ProjectTaskSession 11 LVL 2
//
//  Created by abdurhman elbosaty on 30/07/2021.
//

import UIKit
import DGElasticPullToRefresh
import CoreData

class ToDoListVC: UIViewController {
    
    //MARK: - Variables
    
    //    var notesArr = ["Play","Read","Write","IOS","Listen","Meeting","Play","Read","Write","IOS","Listen","Meeting","Play","Read","Write","IOS","Listen","Meeting"]
    
    //    var notesArr = [String]()
    //    var timeArr = [String]()
    
    var noteArr = [NoteData]()
    //MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        tableViewSetup()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //        tableView.reloadData()
        pullToDoReload()
        loadNotes()
        print(noteArr)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        tableView.dg_removePullToRefresh()
    }
    
    //MARK: - IBActions
    
    @objc func addToList(){
        
        let addToListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AddToListVC") as! AddToListVC
        addToListVC.modalPresentationStyle = .fullScreen
        addToListVC.modalTransitionStyle = .crossDissolve
        addToListVC.delegate = self
        self.present(addToListVC, animated: true, completion: nil)
    }
    
    @objc func upArrowBtnPressed(sender :UIButton){
        if sender.tag != 0 {
            noteArr.swapAt(sender.tag, sender.tag - 1)
            tableView.reloadData()
        }
    }
    @objc func downArrowBtnPressed(sender :UIButton){
        if sender.tag != (noteArr.count - 1){
            noteArr.swapAt(sender.tag, sender.tag + 1)
            tableView.reloadData()
        }
    }
    
    
    //MARK: - Helper Functions
    
    func setupUI() {
        self.title = "Todo List"
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.03564627841, green: 0.5182372928, blue: 1, alpha: 1)
        
        let btn = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(self.addToList))
        btn.tintColor = #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)
        self.navigationItem.rightBarButtonItem = btn
    }
    
    func tableViewSetup(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    func pullToDoReload(){
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = #colorLiteral(red: 0.306208849, green: 0.01529191155, blue: 0.124912791, alpha: 1) //UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            // Add your logic here
            // Do not forget to call dg_stopLoading() at the end
            self?.tableView.dg_stopLoading()
        }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(#colorLiteral(red: 0.03564627841, green: 0.5182372928, blue: 1, alpha: 1)) //(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
    }
    
    func loadNotes(){
        
        let fetchReq : NSFetchRequest<NoteData> = NoteData.fetchRequest()
        do {
            try noteArr = context.fetch(fetchReq)
            tableView.reloadData()
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    func deleteNotes(_ index: NSManagedObject){
        context.delete(index)
        do {
            try context.save()
            
        }catch{
            print(error.localizedDescription)
        }
    }
}

//MARK: - Conform TableView Protocol
extension ToDoListVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FirstCell", for: indexPath) as! FirstCell
        
        
        cell.nameLbl.text = noteArr[indexPath.row].noteName
        cell.timeLbl.text = noteArr[indexPath.row].noteTime
        
        cell.upArrowOutlet.tag = indexPath.row
        cell.upArrowOutlet.addTarget(self, action: #selector(self.upArrowBtnPressed), for: .touchUpInside)
        
        cell.downArrowOutlet.tag = indexPath.row
        cell.downArrowOutlet.addTarget(self, action: #selector(self.downArrowBtnPressed), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return CGFloat(SCREEN_HEIGHT / 8)
    //    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellAnimation(cell: cell, index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteCell = UIContextualAction(style: .normal, title: "Delete") { (action, view, nil) in
            self.deleteNotes(self.noteArr[indexPath.row])
            self.noteArr.remove(at: indexPath.row)
            tableView.reloadData()
            print(self.noteArr.count)
        }
        deleteCell.backgroundColor = .red
        deleteCell.image = UIImage(systemName: "trash.fill")
        
        let perform = UISwipeActionsConfiguration(actions: [deleteCell])
        return perform
    }
    
}
//MARK: - Conform Protocl to pass data from vc to another
extension ToDoListVC:PassDataBetweenVC{
    func passFullData(notesData: NoteData) {
        self.noteArr.append(notesData)
        tableView.reloadData()
    }
    //    func passData(note: String, time: String) {
    //        self.notesArr.append(note)
    //        self.timeArr.append(time)
    //        tableView.reloadData()
    //    }
}

// MARK: - TableViewCell Animation
extension ToDoListVC {
    
    func cellAnimation(cell: UITableViewCell, index: Int) {
        
        for _ in 0...index{
            let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 1000, 0)
            cell.layer.transform = rotationTransform
            cell.alpha = 0
            
            UIView.animate(withDuration: 0.7, delay: 0.3 ,animations: {
                cell.layer.transform = CATransform3DIdentity
                cell.alpha = 1.0
            }, completion: nil)
        }
    }
    
}
