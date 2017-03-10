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

class ViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    let url: URL
    
    init(title: String, url: URL) {
        self.url = url
        super.init(nibName: "View", bundle: nil)
        self.title = title
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented"  )
    }
    
    let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request: URLRequest = URLRequest(url: self.url)
        webView.loadRequest(request)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

