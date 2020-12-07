//
//  PageViewController.swift
//  Halaida06
//
//  Created by Mykhailo Halaida on 06.12.2020.
//

import SwiftUI
import UIKit

struct PageViewController: UIViewControllerRepresentable {
    var controllers: [UIViewController]
    
    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        return pageViewController;
    }
    
    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        pageViewController.setViewControllers(
            [controllers[0]], direction: .forward, animated: true)
    }
}

//struct PageViewController: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//struct PageViewController_Previews: PreviewProvider {
//    static var previews: some View {
//        PageViewController()
//    }
//}
