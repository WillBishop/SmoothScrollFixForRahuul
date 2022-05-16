//
//  ViewController.swift
//  ClassRoom Attendance
//
//  Created by Rahul Roy on 13/05/22.
//

import UIKit
import LocalAuthentication

class LoginPageView: UIViewController {

    var context = LAContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
    }

    @IBAction func tapToSignIn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
        mainTabBarController.modalPresentationStyle = .fullScreen
        context = LAContext()
        context.localizedCancelTitle = "Please Try Again"
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)
        {
            let reason = "Log in to your account"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason)
            {
                success, error in
                if success
                {
                    DispatchQueue.main.async
                    { [unowned self] in
                        
                        self.present(mainTabBarController, animated: true, completion: nil)
                        
                    }
                }
                else
                {
                    print(error?.localizedDescription ?? "Failed to authenticate")
                }
            }
        }
        else
        {
            print(error?.localizedDescription ?? "Can't evaluate policy")
        }
    }
    
}

