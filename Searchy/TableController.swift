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

class TableController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var search: UISearchBar!
    
    let disposeBag: DisposeBag = DisposeBag()
    
    let list: [String] = ["thing one", "thing two", "third thing", "four things", "thing number 5"]
    
    var filteredList: [[WikipediaSearchResult]] = [[],[]]
    
    let sections: [String] = ["Search Results", "History"]
    
    let api: WikipediaAPI = DefaultWikipediaAPI.sharedAPI
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        
        self.title = "Search"
        
//        let searchQuery: Observable<String> = self.search.rx.text.orEmpty
//            .throttle(0.3, scheduler:MainScheduler.instance)
//        
//        searchQuery
//
////            .flatMapLatest( { query in
////                self.api.getSearchResults(query)
////            })
//            .subscribe(
//                onNext: { x in
//                    print("result is \(x)")
//
//                
//                }
//            ).addDisposableTo(disposeBag)
        
        let searchTerm: Observable<String> = self.search.rx.text.orEmpty
            .throttle(0.3, scheduler:MainScheduler.instance)
            .filter { $0.characters.count > 1 }
            .do(
                onNext: { x in
                    print(x)
            })
        
        
        searchTerm.flatMap { term in
            DefaultWikipediaAPI.sharedAPI
                .getSearchResults(term)
            }
            .subscribe(onNext: { r in
                self.filteredList[0] = r
                self.table.reloadData()
                print("results: \(r)")
            })
            .addDisposableTo(disposeBag)
        
        
             // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellIdentifier = "ElementCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        
        //let row = cellForRowAt.row
        //cell.textLabel?.text = swiftBlogs[row]
        let item: WikipediaSearchResult = filteredList[indexPath.section][indexPath.row]
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.description
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return filteredList[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
//        
//        return 40.0
//    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("path is \(indexPath.row)")
        let row = filteredList[indexPath.section][indexPath.row]
        print("text is \(row.title)")
        
        print("url is \(row.URL)")
        print("history is \(filteredList[1])")
        filteredList[1].append(row)
        print("history is now\(filteredList[1])")
        print("sections are \(sections)")
        self.table.reloadData()
        
        let viewController = ViewController(title: row.title, url: row.URL)
//        self.present(viewController, animated: true, completion: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

