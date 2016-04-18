//
//  MailboxViewController.swift
//  mailbox-homework
//
//  Created by Wong, Kapunahele on 4/14/16.
//  Copyright © 2016 Wong, Kapunahele. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var messageView: UIImageView!

    @IBOutlet weak var laterView: UIView!
    @IBOutlet weak var laterIcon: UIImageView!
    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var rescheduleView: UIView!
    var messageOriginalCenter: CGPoint!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: 320, height: 1429)
        scrollView.delegate = self
        listView.alpha = 0
        rescheduleView.alpha = 0
        
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "onCustomPan:")
        
        // Attach it to a view of your choice. If it's a UIImageView, remember to enable user interaction
        view.addGestureRecognizer(panGestureRecognizer)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func onCustomPan(panGestureRecognizer: UIPanGestureRecognizer) {
        
        // Absolute (x,y) coordinates in parent view
        let point = panGestureRecognizer.locationInView(view)
        
        // Relative change in (x,y) coordinates from where gesture began.
        var translation = panGestureRecognizer.translationInView(view)
        var velocity = panGestureRecognizer.velocityInView(view)
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            print("Gesture began at: \(point)")
            print("messageView.center: \(messageView.center)")
            print("Translation: \(translation)")
            messageOriginalCenter = messageView.center
            laterView.backgroundColor = UIColor.grayColor()
            laterIcon.backgroundColor = UIColor.grayColor()
            laterIcon.alpha = 0.5
            
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            print("Gesture changed at: \(point)")
            print("messageView.center Changed: \(messageView.center)")
            messageView.center = CGPoint(x: messageOriginalCenter.x + translation.x, y: messageOriginalCenter.y)
            print("messageView.center Changed After: \(messageView.center)")
            
            if messageOriginalCenter.x + translation.x < 100 && messageOriginalCenter.x + translation.x > 50 {
                print("Between 100 and 50!!!!!!!!!!!!!!!")
                laterView.backgroundColor = UIColor.yellowColor()
                laterIcon.backgroundColor = UIColor.yellowColor()
                laterIcon.center = messageView.center 
            } else if messageOriginalCenter.x + translation.x < 50 {
                print("Less than 50!!!!!!!!!!!!!!!")
//            } else if messageOriginalCenter.x + translation.x 
            
            
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            print("Gesture ended at: \(point)")
            print("messageView.center Ended: \(messageView.center)")

            laterIcon.alpha = 1.0
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
