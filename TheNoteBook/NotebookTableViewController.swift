//
//  NotebookTableViewController.swift
//  TheNoteBook
//
//  Created by Kenneth Uyabeme on 11/30/18.
//  Copyright © 2018 Kenneth Uyabeme. All rights reserved.
//

import UIKit
import CoreData
class NotebookTableViewController: UITableViewController {
    var context:NSManagedObjectContext!
    var notebooks:[Notebook]!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        // 2. Mandatory - initialize the context variable
        // This variable gives you access to the CoreData functions
        self.context = appDelegate.persistentContainer.viewContext
        getNotebooks()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notebooks.count
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notebookCell", for: indexPath)

        cell.textLabel?.text = notebooks[indexPath.row].title
        cell.detailTextLabel?.text = "\(String(notebooks[indexPath.row].numberOfPages))"
        print("\(String(notebooks[indexPath.row].numberOfPages))")
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // condensed into 1 statement
            self.context.delete(notebooks[indexPath.row])
            
            do {
                try self.context.save()         // SEND YOUR DELETE TO THE DATABASE
                print("Deleted!")
            }
            catch {
                print("error while commiting delete")
            }
            
            // UI:  Delete the row from the USER INTEFACE!!!!
            // Reminder: This does NOT delete it from the database!!!
            notebooks.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let pagesTableView = segue.destination as! PagesTableViewController
        
        // 2. set your variables that you wanna pass to second screen
        let i = (self.tableView.indexPathForSelectedRow?.row)!
        pagesTableView.parentNotebook = notebooks[i]
    }
    
    @IBAction func refreshButtonAction(_ sender: Any) {
         self.tableView.reloadData();
    }
    @IBAction func addButtonAction(_ sender: Any) {
        // alert box
        
        // MARK: Code for creating an alert Box
        //-----------------------------------------------
        let popup = UIAlertController(title: "Add a Notebook", message: "Give your notebook a title", preferredStyle: .alert)
        
        popup.addTextField()
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .default, handler: nil)  // creating & configuring the button
        let saveButton = UIAlertAction(title: "Save", style: .default, handler: {
            // mandatory line for creating a closure in swift
            action in
            
            // code for what should happen when you click the button
            //let data = popup.textFields?[0].text
            
            // save your note to the database
            let notebook = Notebook(context: self.context)
            notebook.title = popup.textFields?[0].text   // get whatever they wrote in the text box
            notebook.dateCreated = NSDate() as Date
            notebook.numberOfPages = 0
            
            do  {
                try self.context.save()
                print("done saving to the database")
                
                // update the ui
                self.notebooks.append(notebook)
                self.tableView.reloadData();
                
            }
            catch {
                print("Error while saving to the database")
            }
            
            
        })
        
        popup.addAction(saveButton)             // adds the button to your popup box
        popup.addAction(cancelButton)
        
        // 4. Show the alert box!
        present(popup, animated:true)
        
    }
    
    func getNotebooks(){
        let fetchRequest:NSFetchRequest<Notebook> = Notebook.fetchRequest()
        
        do {
            let results = try self.context.fetch(fetchRequest) as [Notebook]
            self.notebooks = results
            
            // Loop through the database results and output each "row" to the screen
            print("Number of items in database: \(results.count)")
            
            // DEBUG CODE
            for x in results {
                print("Stuff in db: \(x.title!)")
                
            }
            
        }
        catch {
            print("Error when fetching from database")
        }
        
        // --------------------------------
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

}
