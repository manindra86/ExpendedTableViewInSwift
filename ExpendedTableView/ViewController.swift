//
//  ViewController.swift
//  ExpendedTableView
//
//  Created by Manindra on 09/09/15.
//  Copyright (c) 2015 10C Internet Pvt. Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UITableViewDataSource , UITableViewDelegate{
	var selectedIndex :Int = -1
	var subListArray : [[String:AnyObject]] = []
	
	var listArray = [
		["iconName": "list1Image", "listName": "List1", "isSubList": 0, "subList": [["iconName":"", "listName":"SubList1","isSubList": 1],["iconName":"sublistIcon", "listName":"SubList2","isSubList": 1]]],
		["iconName": "list2Image", "listName": "List2" , "isSubList": 0],
		["iconName": "list3Image", "listName": "List3", "isSubList": 0]
	]

	@IBOutlet weak var tableView: UITableView!
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableView.reloadData()
		self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	
	
	
	
	 func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	
	 func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return listArray.count
	}
	
	 func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell : UITableViewCell//tableView.dequeueReusableCellWithIdentifier("mainCell", forIndexPath: indexPath) as! UITableViewCell
		
		let row = indexPath.row
		
		
		
		//var label:UILabel = cell.contentView.viewWithTag(5551) as! UILabel
		//label.text = listArray[row]
		//let dict : NSDictionary = self.listArray[0] as NSDictionary
		//let arr: Array = dict["subList"] as Array
		//let dictSub :AnyObject? = arr[indexPath.row]["isSubList"]
		
		
		let dict : [String:AnyObject] = (self.listArray[indexPath.row] as? Dictionary)!
		
		
		println("\(object_getClassName(dict))");
		
		
		if (self.isSubList(dict)){
			cell = tableView.dequeueReusableCellWithIdentifier("subCell", forIndexPath: indexPath) as! UITableViewCell
			self.configureSubCell(cell, withObject: dict)
			
		}else{
			cell = tableView.dequeueReusableCellWithIdentifier("mainCell", forIndexPath: indexPath) as! UITableViewCell
			self.configureMainCell(cell, withObject: dict)
			
			
		}
		
		
		
		
		
		
		return cell
	}
	
	
	
	
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
		//self.loadDetailView(indexPath.row)
		let dict : [String:AnyObject] = (self.listArray[indexPath.row] as? Dictionary<String,AnyObject>)!
		let subListArr : [[String:AnyObject]]?  = (dict["subList"]  as? [[String:AnyObject]])
		if (selectedIndex == -1){
			if let arr = subListArr  {
				selectedIndex = indexPath.row
				
				self.subListArray = arr
				self.expandList(indexPath.row)
			}
		}else{
			
			if (self.isSubList(dict)){
				//perform Action
			}else{
				self.minimizeList()
				
				if (indexPath.row == selectedIndex){
					selectedIndex = -1
				}else{
					selectedIndex = indexPath.row
					
					if let arr = subListArr  {
						self.subListArray = arr
						self.expandList(indexPath.row)
					
					}
				}
			}
		}
	}

	
	func isSubList(dict : Dictionary <String, AnyObject>) -> Bool{
		let isSubList : Int = (dict["isSubList"] as? Int)!
		if ( isSubList == 1 ) {
			return true
		}
		return false
	}

	func configureMainCell(cell : UITableViewCell, withObject dict:Dictionary<String,AnyObject>){
	
		let imageName:String? = (dict["iconName"] as? String)
		let list:String? = (dict["listName"] as? String)
		
		var listNamelabel:UILabel = cell.contentView.viewWithTag(101) as! UILabel
		listNamelabel.text = list
		
		
		var disclosureImage:UIImageView = cell.contentView.viewWithTag(5555) as! UIImageView
		
		if let x: AnyObject = dict["subList"] {
			disclosureImage.hidden = false
		}else{
			disclosureImage.hidden = true
		}
	
		
	}
	func configureSubCell(cell : UITableViewCell, withObject dict:Dictionary<String,AnyObject>){
		
		let imageName:String? = (dict["iconName"] as? String)
		let list:String? = (dict["listName"] as? String)
		
		var listNamelabel:UILabel = cell.contentView.viewWithTag(102) as! UILabel
		//label.text = la
		listNamelabel.text = list
	}
	
	
	func expandList(atIndex:Int){
		for (index ,dict) in enumerate(self.subListArray){
			self.listArray.insert(dict, atIndex: selectedIndex + index + 1)
			
			
			var indxesPath:[NSIndexPath] = [NSIndexPath]()
			indxesPath.append(NSIndexPath(forRow:(selectedIndex + index + 1),inSection:0))
			//let indexPath :NSIndexPath = NSIndexPath(index: selectedIndex + index + 1)
			
			println("index path=\(indxesPath)and val= \(selectedIndex + index + 1)")
			
			self.tableView.beginUpdates()
			self.tableView.insertRowsAtIndexPaths(indxesPath, withRowAnimation: UITableViewRowAnimation.Top)
			self.tableView.endUpdates()
		
		}
	
	
	}
	
	func minimizeList(){
		var i :Int = 0
		while (i < self.listArray.count){
			let index:Int = i
			let dict:Dictionary<String, AnyObject> = self.listArray[index] as! Dictionary<String, AnyObject>
			
			if (self.isSubList(dict as Dictionary<String, AnyObject>)){
				
				let dicts:Dictionary<String, AnyObject> =  self.listArray.removeAtIndex(index) as! Dictionary<String, AnyObject>
				println(dicts)
				
				var indxesPath:[NSIndexPath] = [NSIndexPath]()
				indxesPath.append(NSIndexPath(forRow:(index),inSection:0))
				
				self.tableView.beginUpdates()
				self.tableView.deleteRowsAtIndexPaths(indxesPath, withRowAnimation: UITableViewRowAnimation.Fade)
				self.tableView.endUpdates()
				
				continue
			}
			i++
		}//while
		
		
	}
	
	
}

