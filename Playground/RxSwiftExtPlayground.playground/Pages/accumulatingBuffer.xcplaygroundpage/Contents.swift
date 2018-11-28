/*:
 > # IMPORTANT: To use `RxSwiftExtPlayground.playground`, please:

 1. Make sure you have [Carthage](https://github.com/Carthage/Carthage) installed
 1. Fetch Carthage dependencies from shell: `carthage bootstrap --platform ios`
 1. Build scheme `RxSwiftExtPlayground` scheme for a simulator target
 1. Choose `View > Show Debug Area`
 */

//: [Previous](@previous)
import RxSwift
import RxSwiftExt
/*:
 ## accumulatingBuffer

 Collects the elements of the source observable, and emits them as an array when the boundary emits.
 */

example("accumulatingBuffer") {
    let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)

    let signalAtThreeSeconds = Observable<Void>.timer(3, scheduler: MainScheduler.instance).map { _ in () }
    let signalAtFiveSeconds = Observable<Void>.timer(5, scheduler: MainScheduler.instance).map { _ in () }
    let boundary = Observable.of(signalAtThreeSeconds, signalAtFiveSeconds).merge()

    // unlimited buffering of values received while paused
    let buffered = observable.accumulatingBuffer(boundary)

    buffered.subscribe { print($0) }

    playgroundShouldContinueIndefinitely()
}
//: [Next](@next)
