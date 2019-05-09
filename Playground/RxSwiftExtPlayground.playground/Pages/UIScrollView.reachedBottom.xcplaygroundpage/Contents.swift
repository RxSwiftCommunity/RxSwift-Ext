/*:
 > # IMPORTANT: To use `RxSwiftExtPlayground.playground`, please:

 1. Make sure you have [Carthage](https://github.com/Carthage/Carthage) installed
 1. Fetch Carthage dependencies from shell: `carthage bootstrap --platform ios`
 1. Build scheme `RxSwiftExtPlayground` scheme for a simulator target
 1. Choose `View > Show Debug Area`
 */

//: [Previous](@previous)

import RxSwift
import RxCocoa
import RxSwiftExt
import PlaygroundSupport
import UIKit

/*:
 ## reachedBottom

 The `reachedBottom` operator provides a sequence that emits every time scrollview is scrolled to the bottom.

 Please open the Assistant Editor (⌘⌥⏎) to see the Interactive Live View example.
 */

final class ReachedBottomViewController: UITableViewController {
    private let dataSource = Array(stride(from: 0, to: 28, by: 1))
    private let identifier = "identifier"
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        tableView.rx.reachedBottom(offset: 40)
            .throttle(1.0, latest: false, scheduler: MainScheduler.instance)
            .bind { print("Reached bottom") }
            .disposed(by: disposeBag)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.textLabel?.text = "\(dataSource[indexPath.row])"
        return cell
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = ReachedBottomViewController()
//: [Next](@next)
