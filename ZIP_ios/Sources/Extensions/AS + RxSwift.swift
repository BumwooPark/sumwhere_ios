////
////  AS + RxSwift.swift
////  ZIP_ios
////
////  Created by xiilab on 2018. 9. 10..
////  Copyright © 2018년 park bumwoo. All rights reserved.
////
//
//import RxSwift
////import AsyncDisplayKit
//import RxCocoa
//
//extension Reactive where Base: ASButtonNode{
//  /// Reactive wrapper for `TouchUpInside` control event.
//  /// Bindable sink for `enabled` property.
//  public var isEnabled: Binder<Bool> {
//    return Binder(self.base) { control, value in
//      control.isEnabled = value
//    }
//  }
//  
//  /// Bindable sink for `selected` property.
//  public var isSelected: Binder<Bool> {
//    return Binder(self.base) { control, selected in
//      control.isSelected = selected
//    }
//  }
//  
//  
//  public var tap: ASControlEvent<Void> {
//    return controlEvent(.touchUpInside)
//  }
//  
//  public func controlEvent(_ controlEvents: ASControlNodeEvent) -> ASControlEvent<()> {
//    let source: Observable<Void> = Observable.create { [weak control = self.base] observer in
//      MainScheduler.ensureExecutingOnScheduler()
//      
//      guard let control = control else {
//        observer.on(.completed)
//        return Disposables.create()
//      }
//      
//      let controlTarget = ASControlTarget(control: control, controlEvents: controlEvents) {
//        control in
//        observer.on(.next(()))
//      }
//      
//      return Disposables.create(with: controlTarget.dispose)
//      }
//      .takeUntil(deallocated)
//    
//    return ASControlEvent(events: source)
//  }
//}
//
//public protocol ASControlEventType : ObservableType {
//  
//  /// - returns: `ControlEvent` interface
//  func asControlEvent() -> ASControlEvent<E>
//}
//
//public struct ASControlEvent<PropertyType> : ASControlEventType {
//  public typealias E = PropertyType
//  
//  let _events: Observable<PropertyType>
//  
//  /// Initializes control event with a observable sequence that represents events.
//  ///
//  /// - parameter events: Observable sequence that represents events.
//  /// - returns: Control event created with a observable sequence of events.
//  public init<Ev: ObservableType>(events: Ev) where Ev.E == E {
//    _events = events.subscribeOn(ConcurrentMainScheduler.instance)
//  }
//  
//  /// Subscribes an observer to control events.
//  ///
//  /// - parameter observer: Observer to subscribe to events.
//  /// - returns: Disposable object that can be used to unsubscribe the observer from receiving control events.
//  public func subscribe<O : ObserverType>(_ observer: O) -> Disposable where O.E == E {
//    return _events.subscribe(observer)
//  }
//  
//  /// - returns: `Observable` interface.
//  public func asObservable() -> Observable<E> {
//    return _events
//  }
//  
//  /// - returns: `ControlEvent` interface.
//  public func asControlEvent() -> ASControlEvent<E> {
//    return self
//  }
//}
//
//final class ASControlTarget<Control: ASControlNode>: _RXKVOObserver, Disposable {
//  typealias Callback = (Control) -> Void
//  
//  let selector: Selector = #selector(eventHandler(_:))
//  
//  weak var controlNode: Control?
//  #if os(iOS) || os(tvOS)
//
//  #endif
//  var callback: Callback?
//  #if os(iOS) || os(tvOS)
//  init(control: Control, controlEvents: ASControlNodeEvent, callback: @escaping Callback) {
//    MainScheduler.ensureExecutingOnScheduler()
//    
//    self.controlNode = control
//    self.callback = callback
//    
//    super.init()
//    
//    control.addTarget(self, action: selector, forControlEvents: controlEvents)
//    
//    let method = self.method(for: selector)
//    if method == nil {
//      fatalError("Can't find method")
//    }
//  }
//  #elseif os(macOS)
//  init(controlNode: Control, callback: @escaping Callback) {
//    MainScheduler.ensureExecutingOnScheduler()
//    
//    self.controlNode = controlNode
//    self.callback = callback
//    
//    super.init()
//    
//    control.target = self
//    control.action = selector
//    
//    let method = self.method(for: selector)
//    if method == nil {
//      rxFatalError("Can't find method")
//    }
//  }
//  #endif
//  
//  @objc func eventHandler(_ sender: UIGestureRecognizer) {
//    if let callback = self.callback, let controlNode = self.controlNode {
//      callback(controlNode)
//    }
//  }
//  
//  override func dispose() {
//    super.dispose()
//    self.controlNode?.removeTarget(self, action: self.selector, forControlEvents: .allEvents)
//    self.callback = nil
//  }
//}
