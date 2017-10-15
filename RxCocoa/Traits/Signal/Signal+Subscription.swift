//
//  Signal+Subscription.swift
//  RxCocoa
//
//  Created by Krunoslav Zaher on 9/19/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

#if !RX_NO_MODULE
    import RxSwift
#endif

extension SharedSequenceConvertibleType where SharingStrategy == SignalSharingStrategy {
    /**
     Creates new subscription and sends elements to observer.

     In this form it's equivalent to `subscribe` method, but it communicates intent better.

     - parameter to: Observer that receives events.
     - returns: Disposable object that can be used to unsubscribe the observer from the subject.
     */
    public func emit<O: ObserverType>(to observer: O) -> Disposable where O.E == E {
        return self.asSharedSequence().asObservable().subscribe(observer)
    }

    /**
     Creates new subscription and sends elements to observer.

     In this form it's equivalent to `subscribe` method, but it communicates intent better.

     - parameter to: Observer that receives events.
     - returns: Disposable object that can be used to unsubscribe the observer from the subject.
     */
    public func emit<O: ObserverType>(to observer: O) -> Disposable where O.E == E? {
        return self.asSharedSequence().asObservable().map { $0 as E? }.subscribe(observer)
    }

    /**
     Creates new subscription and sends elements to variable.

     - parameter relay: Target relay for sequence elements.
     - returns: Disposable object that can be used to unsubscribe the observer from the variable.
     */
    public func emit(to relay: PublishRelay<E>) -> Disposable {
        return emit(onNext: { e in
            relay.accept(e)
        })
    }

    /**
     Creates new subscription and sends elements to variable.

     - parameter to: Target relay for sequence elements.
     - returns: Disposable object that can be used to unsubscribe the observer from the variable.
     */
    public func emit(to relay: PublishRelay<E?>) -> Disposable {
        return emit(onNext: { e in
            relay.accept(e)
        })
    }
    
    /**
     Subscribes to observable sequence using custom emitter function.
     
     - parameter emitter: Function used to emit elements from `self`.
     - returns: Object representing subscription.
     */
    public func emit<R>(to emitter: (Observable<E>) -> R) -> R {
        return emitter(self.asObservable())
    }
    
    /**
     Subscribes to observable sequence using custom emitter function and final parameter passed to emitter function
     after `self` is passed.
     
         public func emit<R1, R2>(to with: Self -> R1 -> R2, curriedArgument: R1) -> R2 {
             return emitter(self)(curriedArgument)
         }
     
     - parameter emitter: Function used to emit elements from `self`.
     - parameter curriedArgument: Final argument passed to `emitter` to finish emitting process.
     - returns: Object representing subscription.
     */
    public func emit<R1, R2>(to emitter: (Observable<E>) -> (R1) -> R2, curriedArgument: R1) -> R2 {
        return emitter(self.asObservable())(curriedArgument)
    }

    /**
     Subscribes an element handler, a completion handler and disposed handler to an observable sequence.

     Error callback is not exposed because `Signal` can't error out.

     - parameter onNext: Action to invoke for each element in the observable sequence.
     - parameter onCompleted: Action to invoke upon graceful termination of the observable sequence.
     gracefully completed, errored, or if the generation is canceled by disposing subscription)
     - parameter onDisposed: Action to invoke upon any type of termination of sequence (if the sequence has
     gracefully completed, errored, or if the generation is canceled by disposing subscription)
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    public func emit(onNext: ((E) -> Void)? = nil, onCompleted: (() -> Void)? = nil, onDisposed: (() -> Void)? = nil) -> Disposable {
        return self.asObservable().subscribe(onNext: onNext, onCompleted: onCompleted, onDisposed: onDisposed)
    }
}



