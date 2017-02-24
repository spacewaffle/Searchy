//
//  ViewController.swift
//  Searchy
//
//  Created by Jon on 2/24/17.
//  Copyright © 2017 Jon. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TableController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var search: UISearchBar!
    
    let disposeBag: DisposeBag = DisposeBag()
    
    let list: [String] = ["thing one", "thing two", "third thing", "four things", "thing number 5"]
    
    var filteredList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let searchQuery = self.search.rx.text.orEmpty.asDriver()
        
        searchQuery.drive(
            onNext: { x in
                print("text is \(x)")
                self.filteredList = self.list.filter {
                    $0.contains(x.localizedLowercase)
                }
                self.table.reloadData()
                
            }
        ).addDisposableTo(disposeBag)
        
             // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        print("hello")
        let cellIdentifier = "ElementCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        
        //let row = cellForRowAt.row
        //cell.textLabel?.text = swiftBlogs[row]
        cell.textLabel?.text = filteredList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return filteredList.count
    }
    
}

