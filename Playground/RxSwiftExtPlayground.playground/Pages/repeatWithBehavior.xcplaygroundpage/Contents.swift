/*:
 > # IMPORTANT: To use `RxSwiftExtPlayground.playground`, please:

 1. Build `RxSwiftExt` scheme for a simulator target
 1. Build `RxSwiftExtDemo` scheme for a simulator target
 1. Choose `View > Show Debug Area`
 */

//: [Previous](@previous)

import Foundation
import RxSwift
import RxSwiftExt

private enum SampleErrors : ErrorType {
    case fatalError
}

let completingObservable = Observable<String>.create { observer in
    observer.onNext("First")
    observer.onNext("Second")
    observer.onCompleted()
    return NopDisposable.instance
}

let erroringObservable = Observable<String>.create { observer in
    observer.onNext("First")
    observer.onNext("Second")
    observer.onError(SampleErrors.fatalError)
    return NopDisposable.instance
}

let delayScheduler = SerialDispatchQueueScheduler(globalConcurrentQueueQOS: .Utility)

example("Immediate repeat") {
    // repeat immediately after completion
    _ = completingObservable.repeatWithBehavior(.Immediate(maxCount: 2))
        .subscribeNext { event in
            print("Receive event: \(event)")
    }
}



example("Immediate repeat with custom predicate") {
    // in this case we provide custom predicate, that will evaluate error and decide, should we retry or not
    _ = completingObservable.repeatWithBehavior(.Immediate(maxCount: 2), scheduler: delayScheduler) {
            return true
        }
        .subscribeNext { event in
            print("Receive event: \(event)")
    }
}

example("Delayed repeat") {
    // after error, observable will be retried after 1.0 second delay
    _ = completingObservable.repeatWithBehavior(.Delayed(maxCount: 2, time: 1.0), scheduler: delayScheduler)
        .subscribeNext { event in
            print("Receive event: \(event)")
    }
}

// sleep in order to wait until previous example finishes
NSThread.sleepForTimeInterval(2.5)

example("Exponential delay") {
    // in case of an error initial delay will be 1 second,
    // every next delay will be doubled
    // delay formula is: initial * pow(1 + multiplier, Double(currentAttempt - 1)), so multiplier 1.0 means, delay will doubled
    _ = completingObservable.repeatWithBehavior(.ExponentialDelayed(maxCount: 3, initial: 1.0, multiplier: 1.2), scheduler: delayScheduler)
        .subscribeNext { event in
            print("Receive event: \(event)")
    }
}

// sleep in order to wait until previous example finishes
NSThread.sleepForTimeInterval(4.0)

example("Delay with calculator") {
    // custom delay calculator
    // will be invoked to calculate delay for particular repeat
    // will be invoked in the beginning of repeat
    let customCalculator: (UInt) -> Double = { attempt in
        switch attempt {
        case 1: return 0.5
        case 2: return 1.5
        default: return 2.0
        }
    }
    _ = completingObservable.repeatWithBehavior(.CustomTimerDelayed(maxCount: 3, delayCalculator: customCalculator), scheduler: delayScheduler)
        .subscribeNext { event in
            print("Receive event: \(event)")
    }
}

// sleep in order to wait until previous example finishes
NSThread.sleepForTimeInterval(4.0)

example("Observable with error") {
    _ = erroringObservable.repeatWithBehavior(.Immediate(maxCount: 2))
        .doOnError {error in
            print("Repetition interrupted with error: \(error)")
        }
        .subscribeNext { event in
            print("Receive event: \(event)")
    }
}

playgroundShouldContinueIndefinitely()

//: [Next](@next)
