//
//  BannerViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 14/01/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//
import Kingfisher

final class BannerViewController: UIViewController{
  
  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  init(banner: BannerModel) {
    super.init(nibName: nil, bundle: nil)
    imageView.kf.setImage(with: URL(string: banner.imageURL.addSumwhereImageURL()),options: [.transition(.fade(0.2))])
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func didMove(toParent parent: UIViewController?) {
    super.didMove(toParent: parent)
    
  }
  
  override func viewDidLoad() {
    view.addSubview(imageView)
    imageView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
}
