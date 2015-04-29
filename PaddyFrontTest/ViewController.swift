//
//  ViewController.swift
//  PaddyFrontTest
//
//  Created by K.Mochizuki on 2015/04/29.
//  Copyright (c) 2015年 K.Mochizuki. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,NSURLSessionDelegate,NSURLSessionDataDelegate{
    @IBOutlet weak var regestBtn: UIButton!
    @IBOutlet weak var getBtn: UIButton!
    @IBOutlet weak var regestText: UITextView!
    @IBOutlet weak var getTest1: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.addSubview(regestText)
    }
    
    @IBAction func TouchRegestBtn(sender: AnyObject) {
        // 通信用のConfigを生成.
        let myConfig:NSURLSessionConfiguration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("backgroundTask")
        
        // Sessionを生成.
        var mySession:NSURLSession = NSURLSession(configuration: myConfig, delegate: self, delegateQueue: nil)
        
        // 通信先のURLを生成.
        let myUrl:NSURL = NSURL(string: "http://tanbozensen.herokuapp.com/api/tanbos/")!
        
        // POST用のリクエストを生成.
        let myRequest:NSMutableURLRequest = NSMutableURLRequest(URL: myUrl)
        
        // Httpヘッダのcontenttypeはapplication/jsonに
        myRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // POSTのメソッドを指定.
        myRequest.HTTPMethod = "POST"
        
        // 送信するデータを生成・リクエストにセット.
        let str:NSString = "{ \"latitude\": 22.2, \"longitude\": 111.1, \"phase\": 1, \"rice_type\": 0, \"done_date\": \"2015-04-29\" }"
        let myData:NSData = str.dataUsingEncoding(NSUTF8StringEncoding)!
        myRequest.HTTPBody = myData
        
        // タスクの生成.
        let myTask:NSURLSessionDataTask = mySession.dataTaskWithRequest(myRequest)
        
        // タスクの実行.
        myTask.resume()
    }
    
    /*
    通信が終了したときに呼び出されるデリゲート.
    */
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        // 帰ってきたデータを文字列に変換.
        var myData:NSString = NSString(data: data, encoding: NSUTF8StringEncoding)!
        
        // バックグラウンドだとUIの処理が出来ないので、メインスレッドでUIの処理を行わせる.
        dispatch_async(dispatch_get_main_queue(), {
            self.regestText.text = "\(myData)"
        })
    }
    
    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession) {
        println("URLSessionDidFinishEventsForBackgroundURLSession")
        // バックグラウンドからフォアグラウンドの復帰時に呼び出されるデリゲート.
    }

    @IBAction func TouchGetBtn(sender: AnyObject) {
        // APIからJsonを取得してパース
        let json = JSON(url:"http://tanbozensen.herokuapp.com/api/tanbos?year=2015")
        self.getTest1.text = "\(json)"
        // 特定の要素の取り出し
        var line = json["response"]["station"][2]["line"]
/*
        println("stationの3番目の要素のline: \(line)")
        // 配列要素の取り出し
        for (i,station) in json["response"]["station"] {
            println("-----")
            for (key, value) in station {
                println("\(key): \(value)")
            }
        }
*/
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

