//
//  BarcelonaViewController.swift
//  ChampionsLeagueScore
//
//  Created by Björn Gonzalez on 2020-02-27.
//  Copyright © 2020 Bjorn Gonzalez. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
   private let notificationPublisher = NotificationPublisher()
    
   let transition = SlideInTransition()
      
   
   @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.navigationBar.isHidden = false
        
        DesignPart()
            
        }
        
        func DesignPart() {
            backgroundView.layer.cornerRadius = 25
            backgroundView.clipsToBounds = true
         
                          
      }
      
    @IBAction func sendNotification(_ sender: Any) {
        
        notificationPublisher.sendNotification(title: "Hey", subtitle: "Your notifications are on!", body: "All notifications on", badge: 1, delayInterval: nil)
      }
    
    @IBAction func didTapeMenu(_ sender: UIBarButtonItem) {

          guard let sideBarMenuViewController = storyboard?.instantiateViewController(withIdentifier: "SideBarMenuViewController") else { return }
              sideBarMenuViewController.modalPresentationStyle = .overCurrentContext
              sideBarMenuViewController.transitioningDelegate = self
              present(sideBarMenuViewController, animated: true)
          
       }


}
extension ProfileViewController: UIViewControllerTransitioningDelegate {
    
   func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
       transition.isPresenting = true
       return transition
   }
   
   func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
       transition.isPresenting = false
       return transition
    
      }
      
  }






































