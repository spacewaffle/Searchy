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
    
    var filteredList: [WikipediaSearchResult] = []
    
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
        
        
        searchTerm.flatMap { term in
            DefaultWikipediaAPI.sharedAPI
                .getSearchResults(term)
            }
            .subscribe(onNext: { r in
                self.filteredList = r
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
        print("hello")
        let cellIdentifier = "ElementCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        
        //let row = cellForRowAt.row
        //cell.textLabel?.text = swiftBlogs[row]
        cell.textLabel?.text = filteredList[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return filteredList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("path is \(indexPath.row)")
        let row = filteredList[indexPath.row].title
        print("text is \(row)")
        
        let viewController = ViewController(selection: row)
//        self.present(viewController, animated: true, completion: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

