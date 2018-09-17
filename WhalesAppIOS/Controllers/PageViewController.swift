//
//  PageViewController.swift
//  WhalesAppIOS
//
//  Created by Pedro Ribeiro on 29/05/2018.
//  Copyright © 2018 Pedro Ribeiro. All rights reserved.
//

import UIKit


class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    ///array with the name of the view controllers so that they can be loaded next
    lazy var arrayUIViews: [UIViewController] = {
        return [self.viewControllerInstance(name: "MainPage"),
                self.viewControllerInstance(name: "CrimeaRose"),
                self.viewControllerInstance(name: "Cubijsm"),
                self.viewControllerInstance(name: "Gps")]
    }()
    
    private let previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("PREV", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(prevButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("NEXT", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.mainPink, for: .normal)
        button.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = arrayUIViews.count
        pc.currentPageIndicatorTintColor = .mainPink
        pc.pageIndicatorTintColor = UIColor(red: 249/255, green: 207/255, blue: 224/255, alpha: 1)
        return pc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        if let firstViewController = arrayUIViews.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        
        setupBottomControls()
    }
    
    /// for layout of the scrollView
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for view in self.view.subviews{
            if view is UIScrollView {
                view.frame = UIScreen.main.bounds
            } else if view is UIPageControl {
                view.backgroundColor = .clear
            }
        }
    }
    
    /// handles the change on the PageViewController
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = arrayUIViews.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard  arrayUIViews.count > previousIndex else {
            return nil
        }
        
        return arrayUIViews[previousIndex]
    }
    
    /// handles the change on the PageViewController
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = arrayUIViews.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < arrayUIViews.count else {
            return nil
        }
        
        guard  arrayUIViews.count > nextIndex else {
            return nil
        }
        
        return arrayUIViews[nextIndex]
    }
    
    /// handles the change on the PageViewController
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        pageControl.currentPage = arrayUIViews.index(of: pageContentViewController)!
    }
    
    
    // Private Methods
    
    /// instantiates the views
    private func viewControllerInstance(name:String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name)
    }
    
    /// sets the bottom controls and their layouts
    private func setupBottomControls() {
        
        let bottomControlsStackView = UIStackView(arrangedSubviews: [previousButton, pageControl, nextButton])
        
        bottomControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomControlsStackView.distribution = .fillEqually        
        
        view.addSubview(bottomControlsStackView)
        
        NSLayoutConstraint.activate([
            bottomControlsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomControlsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomControlsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomControlsStackView.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
    
    ///handles the touch event on the prev button
    @objc private func prevButtonClicked(){
        // prevents from having negative index
        let nextIndex = max(pageControl.currentPage - 1, 0)
        pageControl.currentPage = nextIndex
        
        setViewControllers([arrayUIViews[nextIndex]], direction: .reverse, animated: true, completion: nil)
    }
    
    ///handles the touch event on the next button
    @objc private func nextButtonClicked(){
        // prevents from having negative index
        let nextIndex = min(pageControl.currentPage + 1, arrayUIViews.count - 1)
        pageControl.currentPage = nextIndex
        
        setViewControllers([arrayUIViews[nextIndex]], direction: .forward, animated: true, completion: nil)
    }
}
