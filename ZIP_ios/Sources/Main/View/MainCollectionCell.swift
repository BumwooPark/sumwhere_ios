////
////  MainCollectionCell.swift
////  ZIP_ios
////
////  Created by xiilab on 2018. 8. 22..
////  Copyright © 2018년 park bumwoo. All rights reserved.
////
//
//class MainCollectionCell: UICollectionViewCell{
//  
//  var didUpdateConstraint = false
//  var item: MainModel?{
//    didSet{
//      backImageView.image = item?.image
//      titleLabel.text = item?.title
//      detailLabel.text = item?.detail
//    }
//  }
//  
//  let titleLabel: UILabel = {
//    let label = UILabel()
//    label.font = UIFont.AppleSDGothicNeoRegular(size: 17)
//    label.textColor = .white
//    label.numberOfLines = 0
//    return label
//  }()
//  
//  let detailLabel: UILabel = {
//    let label = UILabel()
//    label.textColor = .white
//    label.font = UIFont.AppleSDGothicNeoRegular(size: 13.5)
//    return label
//  }()
//  
//  let backImageView: UIImageView = {
//    let imageView = UIImageView()
//    imageView.contentMode = .scaleAspectFill
//    imageView.backgroundColor = .blue
//    imageView.layer.cornerRadius = 20
//    imageView.clipsToBounds = true
//    return imageView
//  }()
//  
//  private let gotoDetailLabel: UILabel = {
//    let label = UILabel()
//    label.text = "여행지 보러가기"
//    label.font = .AppleSDGothicNeoRegular(size: 13.5)
//    return label
//  }()
//  
//  private let detailView: UIView = {
//    let view = UIView()
//    view.backgroundColor = .white
//    return view
//  }()
//  
//  private let detailImage: UIImageView = {
//    let image = UIImageView()
//    image.image = #imageLiteral(resourceName: "detailMove.png")
//    return image
//  }()
//
//  
//  override init(frame: CGRect) {
//    super.init(frame: frame)
//    addSubview(backImageView)
//    backImageView.addSubview(titleLabel)
//    backImageView.addSubview(detailLabel)
//    backImageView.addSubview(detailView)
//    detailView.addSubview(gotoDetailLabel)
//    detailView.addSubview(detailImage)
//    
//    layer.shadowColor = UIColor.lightGray.cgColor
//    layer.shadowOpacity = 5
//    layer.shadowOffset = CGSize(width: 5, height: 5)
//    layer.cornerRadius = 20
//    setNeedsUpdateConstraints()
//  }
//  
//  override func updateConstraints() {
//    if !didUpdateConstraint{
//      backImageView.snp.makeConstraints { (make) in
//        make.edges.equalToSuperview()
//      }
//      
//      titleLabel.snp.makeConstraints { (make) in
//        make.top.equalToSuperview().inset(27)
//        make.left.equalToSuperview().inset(20)
//      }
//      
//      detailLabel.snp.makeConstraints { (make) in
//        make.left.equalTo(titleLabel.snp.left)
//        make.top.equalTo(titleLabel.snp.bottom).offset(5)
//      }
//      
//      detailView.snp.makeConstraints { (make) in
//        make.bottom.left.right.equalToSuperview()
//        make.height.equalTo(41)
//      }
//      
//      gotoDetailLabel.snp.makeConstraints { (make) in
//        make.left.equalToSuperview().inset(19.8)
//        make.centerY.equalToSuperview()
//      }
//      
//      detailImage.snp.makeConstraints { (make) in
//        make.centerY.equalToSuperview()
//        make.right.equalToSuperview().inset(16.6)
//        make.height.equalTo(16)
//        make.width.equalTo(9)
//      }
//      
//      didUpdateConstraint = true
//    }
//    super.updateConstraints()
//  }
//  
//  
//  required init?(coder aDecoder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }
//}
