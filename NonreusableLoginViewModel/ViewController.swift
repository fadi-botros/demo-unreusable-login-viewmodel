//
//  ViewController.swift
//  NonreusableLoginViewModel
//
//  Created by fadi on 3/13/18.
//  Copyright © 2018 fadi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - View Model and its observation
    
    var observationOnLoginState: NSKeyValueObservation?
    
    var viewModel: LoginViewModel? {
        
        didSet {
        
            self.observationOnLoginState = viewModel?.observe(\LoginViewModel.loginState, changeHandler: {[weak self] viewModel, change in
                
                DispatchQueue.main.async {
                    self?.activityIndicator?.stopAnimating()
                    
                    if viewModel.loginState?.isLoggedIn == true {
                        self?.presentSuccess(user: (viewModel.loginState?.user)!)
                    } else if let err = viewModel.loginState?.error {
                        self?.presentError(err)
                    }
                }
                
            })
        }
    }
    
    // MARK: - Present Errors
    
    func presentError(_ err: Error) {
        let e = UIAlertController(title: "Error",
                                  message: err.localizedDescription,
                                  preferredStyle: .alert)
        
        e.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(e, animated: true, completion: nil)
    }
    
    func presentSuccess(user: User) {
        let e = UIAlertController(title: "Success",
                                  message: "Logged in as: \(user.userName), with email of \(user.email), with phone of \(user.phone)",
                                  preferredStyle: .alert)
        
        e.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(e, animated: true, completion: nil)
    }

    // MARK: - Actions

    @IBAction func loginButtonAction(_ sender: Any) {
        // This is not the best practice, the better was to make an "isLoading" variable in the
        //    viewModel, and control this from the ViewModel
        guard !activityIndicator.isAnimating else { return }
        
        // Makes the activity indicator moving now
        activityIndicator.startAnimating()
        
        // Get the repository, and begin loading
        viewModel?.login(userName: userNameTextField.text ?? "",
                         password: passwordTextField.text ?? "",
                         using: RepositoryInjector.repository)
    }
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = LoginViewModel()
    }
    
}

