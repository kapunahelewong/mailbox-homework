//
//  MailboxViewController.swift
//  mailbox-homework
//
//  Created by Wong, Kapunahele on 4/14/16.
//  Copyright © 2016 Wong, Kapunahele. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var messageView: UIImageView!

    @IBOutlet weak var laterView: UIView!
    @IBOutlet weak var laterIcon: UIImageView!
    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var rescheduleView: UIView!
    
    @IBOutlet weak var feedView: UIImageView!
    
    var messageOriginalCenter: CGPoint!
    var laterIconOriginalCenter: CGPoint!
    var archiveIconOriginalCenter: CGPoint!
    var feedOriginalCenter: CGPoint!

    @IBOutlet weak var archiveIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: 320, height: 1429)
        scrollView.delegate = self
        listView.alpha = 0
        rescheduleView.alpha = 0
        laterIconOriginalCenter = laterIcon.center
        archiveIconOriginalCenter = archiveIcon.center
        feedOriginalCenter = feedView.center
        
        
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
            laterIcon.alpha = 0.5
            
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            print("Gesture changed at: \(point)")
            print("messageView.center Changed: \(messageView.center)")
            messageView.center = CGPoint(x: messageOriginalCenter.x + translation.x, y: messageOriginalCenter.y)
            print("messageView.center Changed After: \(messageView.center)")
            
            
            laterIcon.center.x = laterIconOriginalCenter.x + translation.x + 60
            laterIcon.alpha = 1
            archiveIcon.alpha = 1
            
            
            if translation.x <= -60 && translation.x >= -240 {
                print("Between -60 and -240!")
                archiveIcon.center.x = archiveIconOriginalCenter.x + translation.x - 60
                archiveIcon.alpha = 1
                laterIcon.alpha = 1
                messageView.backgroundColor = UIColor.yellowColor()

            } else if translation.x < -240 {
                print("Less than -240")
                laterIcon.center.x = self.laterIconOriginalCenter.x + translation.x + 60
                laterIcon.alpha = 1
            } else if translation.x >= 60 && translation.x <= 240 {
                print(">= 60 AND <= 240")
                archiveIcon.center.x = archiveIconOriginalCenter.x + translation.x - 60
                archiveIcon.alpha = 1
                laterIcon.alpha = 0
            } else if translation.x > 240 {
                print("> 240")
                archiveIcon.center.x = archiveIconOriginalCenter.x + translation.x - 60
                archiveIcon.alpha = 1
            } else {
                archiveIcon.alpha = 0.5
                laterIcon.alpha = 0.5
            }
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            print("Gesture ended at: \(point)")
            print("messageView.center Ended: \(messageView.center)")

            laterIcon.alpha = 1.0
            
            if translation.x <= -60 && translation.x >= -240 {
                print("ended <=-60 && >= -240")
                
                UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    self.messageView.center.x = self.messageOriginalCenter.x - 320
                    self.laterIcon.alpha = 0
                    }, completion: { (Bool) -> Void in
                        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                            self.rescheduleView.alpha = 1
                            self.showReschedule()
                            }, completion: { (Bool) -> Void in
                        })
                })
            } else if translation.x < -240 {
                print("ended less than -240")
                messageView.backgroundColor = UIColor.grayColor()
                
                UIView.animateWithDuration(0.15, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    self.messageView.center.x = self.messageOriginalCenter.x - 320
                    self.laterIcon.alpha = 0
                    }, completion: { (Bool) -> Void in
                        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                            self.listView.alpha = 1
                            }, completion: { (Bool) -> Void in
                        })
                })
            } else if translation.x >= 60 && translation.x <= 240 {
                ("ended >= 60 AND <= 240")
                UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    self.messageView.center.x = self.messageOriginalCenter.x + 320
                    self.archiveIcon.alpha = 0
                    self.messageView.backgroundColor = UIColor.redColor()
                    }, completion: { (Bool) -> Void in
                        self.hideThenRevealAgain()
                })
            } else if translation.x > 240 {
                print("ended > 240")
                UIView.animateWithDuration(0.15, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    self.messageView.center.x = self.messageOriginalCenter.x + 320
                    self.archiveIcon.alpha = 0
                    self.messageView.backgroundColor = UIColor.redColor()
                    }, completion: { (Bool) -> Void in
                        self.hideThenRevealAgain()
                })
            } else {
                print("do something")
                UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 15, options: [], animations: { () -> Void in
                    self.messageView.center.x = self.messageOriginalCenter.x
                    }, completion: { (Bool) -> Void in
                        //code
                })
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    self.laterIcon.alpha = 0.5
                    self.archiveIcon.alpha = 0.5
                })
            }
        }
    }
    
    
    
    func showReschedule() {
        rescheduleView.alpha = 1
    }
    
    
    func hideReschedule() {
        rescheduleView.alpha = 0
    }
    
    func hideThenRevealAgain() {
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.feedView.center.y = self.feedOriginalCenter.y - 86
            }, completion: { (Bool) -> Void in
                self.messageView.backgroundColor = UIColor(red: 204/255, green: 205/255, blue: 210/255, alpha: 1.0)
                self.messageView.center.x = self.messageOriginalCenter.x
                self.archiveIcon.alpha = 0.3
                self.laterIcon.alpha = 0.3
                self.archiveIcon.center.x = self.archiveIconOriginalCenter.x
                self.laterIcon.center.x = self.laterIconOriginalCenter.x
                UIView.animateWithDuration(0.3, delay: 2, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    self.feedView.center.y = self.feedOriginalCenter.y
                    }, completion: { (Bool) -> Void in
                        
                })
        })
    }
    
    
    @IBAction func didTapList(sender: AnyObject) {
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.listView.alpha = 0
            }) { (Bool) -> Void in
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
