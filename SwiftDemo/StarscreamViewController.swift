//
//  StarscreamViewController.swift
//  SwiftDemo
//
//  Created by Sean Zeng on 2018/7/31.
//  Copyright © 2018 Yahoo. All rights reserved.
//

import Starscream
import UIKit

class StarscreamViewController: UIViewController {
    
    private var socket: WebSocket?
    
    private var button : UIButton!
    private var label : UILabel!
    private var textView : UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        button = UIButton.init()
        button.backgroundColor = UIColor.yellow
        button.titleLabel?.text = "ok"
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action:#selector(tapButton), for: .touchUpInside)
        view.addSubview(button)
        if #available(iOS 11, *) {
            NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view.safeAreaLayoutGuide, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 10.0).isActive = true
        } else {
            NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 10.0).isActive = true
        }
        NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: -10.0).isActive = true
        NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 30.0).isActive = true
        NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 30.0).isActive = true
        
        textView = UITextView.init(frame: CGRect.init())
        textView.backgroundColor = UIColor.white
        textView.center = view.center
        textView.textColor = UIColor.black
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textView)
        if #available(iOS 11, *) {
            NSLayoutConstraint(item: textView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view.safeAreaLayoutGuide, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 10.0).isActive = true
        } else {
            NSLayoutConstraint(item: textView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 10.0).isActive = true
        }
        NSLayoutConstraint(item: textView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 10.0).isActive = true
        NSLayoutConstraint(item: textView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: button, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: -10.0).isActive = true
        NSLayoutConstraint(item: textView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 30.0).isActive = true
        
        label = UILabel.init()
        label.backgroundColor = UIColor.white
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: textView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 10.0).isActive = true
        NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 10.0).isActive = true
        NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: button, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 30.0).isActive = true
        
        socket = WebSocket(url: URL(string: "ws://localhost:8080/echo")!)
        if let socket = socket {
            //socket.delegate = self
            socket.onConnect = {
                print("websocket is connected")
            }
            socket.onData = { (data: Data) in
                print("got some data: \(data.count)")
            }
            socket.onDisconnect = { (error: Error?) in
                print("websocket is disconnected: \(error?.localizedDescription)")
            }
            socket.onText = { (text: String) in
                self.label.text = text
                print("got some text: \(text)")
            }
            socket.connect()
        }
    }
    
    // MARK: - UI event
    
    func tapButton() {
        socket?.write(string: textView.text)
    }
    
}
