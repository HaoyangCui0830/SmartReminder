//
//  RemindItemsTableViewController.swift
//  Smart Reminder
//
//  Created by Penguin on 2020/1/17.
//  Copyright © 2020 haoyang. All rights reserved.
//

import UIKit
import CoreData

class RemindItemsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        initialiseFetchedResultController()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewRemindItem))
        self.refreshControl = pullToRefreshControl
        pullToRefreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    let pullToRefreshControl = UIRefreshControl()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    var remindItemArray = [RemindItem]()
    
    func initialiseFetchedResultController(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"RemindItemEntity")
        
        //let sortByDescription = NSSortDescriptor(key:"itemDescription", ascending:true)
        let sortByDescription = NSSortDescriptor(key:"priorityPoint", ascending:false)
        request.sortDescriptors = [sortByDescription]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do{
            try fetchedResultsController.performFetch()
        } catch{
            fatalError("failed to initialise")
        }
    }
    
    func configureCell(cell: UITableViewCell, indexPath: IndexPath){
        let entries = fetchedResultsController.object(at:indexPath) as! RemindItemEntity
        cell.textLabel?.text = entries.itemDescription
        let r = RemindItem(descrip: entries.itemDescription ?? "",
                           should: entries.shouldBeFinished ?? "1000",
                           must: entries.mustBeFinished ?? "1000",
                           essential: entries.essentialTask ?? "false",
                           Pre: entries.preTask ?? "false",
                           prioritypoint: entries.priorityPoint?.doubleValue ?? 0.0,
                           startdate: entries.startDate ?? Date())
        remindItemArray.append(r)
        
    }
    
    @objc func refreshTable(){
        //model.remindItem = model.remindItem
        self.tableView.reloadData()
        pullToRefreshControl.endRefreshing()
    }
    
    @objc func addNewRemindItem(){
        self.performSegue(withIdentifier: "segueToNewRemindItem", sender: self)
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
        //return fetchedResultsController.sections!.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return RemindItem.remindItems.count
        //fetchedResultsController.sections!.count

        guard let sections = fetchedResultsController.sections else{
            fatalError("no sections")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "Remind Item", for: indexPath)
        
           configureCell(cell:cell, indexPath: indexPath)
           // customise cells
           // cell.textLabel?.text = RemindItem.remindItems[indexPath.row].description
           
           return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete{
//            RemindItem.remindItems.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//        else if editingStyle == .insert{
//
//        }
//    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToDetailedItemView"{
            let destination = segue.destination as! DetailedItemViewController
            
            //destination.selectedIndexItem = tableView.indexPathForSelectedRow!
            let cell = tableView.cellForRow(at:tableView.indexPathForSelectedRow!)
            let celltext = (cell?.textLabel?.text!)! as String
//            destination.detailedItemDescription = celltext
            for remindItem in remindItemArray{
                if remindItem.description == celltext{
                    destination.detailedItemDescription = celltext
                    destination.shouldBeFinishedIn = remindItem.shouldBeFinishedBy
                    destination.mustBeFinishedIn = remindItem.mustBeFinishedBy
                    destination.essentialTask = remindItem.mustBeCompleted
                    destination.isPre = remindItem.isPreTask
                    break
                }
            }
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
     
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
            
            //print("TADA")
        case .move:
            break
        case .update:
            break
        }
    }
     
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            let cell = tableView.cellForRow(at: indexPath!)
            let celltext = (cell?.textLabel?.text!)! as String
            //print("celltext = " + celltext)
            for remindItem in remindItemArray{
                if remindItem.description == celltext{
                    remindItem.learn()
                    break
                }
            }
            //print("DATA")
        case .update:
            configureCell(cell: tableView.cellForRow(at: indexPath!)!, indexPath: indexPath!)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
     
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        let managedObject = fetchedResultsController.object(at: indexPath) as! NSManagedObject
        context.delete(managedObject)
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
