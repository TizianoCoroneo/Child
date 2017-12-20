

import Foundation
import ChildBrain

let runner = Runner()

do {
    try runner.run(
        CommandLine.arguments,
        diagnostic: { print($0) },
        completion: { print($0) })
} catch {
    print("Error! \(error)")
}
