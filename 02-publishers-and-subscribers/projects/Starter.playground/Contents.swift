import Foundation
import Combine
import _Concurrency

var subscriptions = Set<AnyCancellable>()
example(of: "Publisher") {
    let notification = Notification.Name("MyNotification")
    let publisher = NotificationCenter.default.publisher(for: notification, object: nil)
    let center = NotificationCenter.default
    
    let observer = center.addObserver(forName: notification, object: nil, queue: nil) { notification in
        print("Notification recieved")
    }
    center.post(name: notification, object: nil)
    
    center.removeObserver(observer)
}


example(of: "Subscriber") {
    let notification = Notification.Name("MyNotification")
    let center = NotificationCenter.default
    let publisher = center.publisher(for: notification, object: nil)
    let subscription = publisher.sink { completion in
        print("Received Completion", completion)
    } receiveValue: { notification in
        print("Notification recieved from Publisher")
    }

    center.post(name: notification, object: nil)
    subscription.cancel()
}

example(of: "Just") {
    let just = Just("Hello World")
    _ = just.sink(receiveCompletion: {
        print("received completion", $0)
    }, receiveValue: {
        print("received value", $0)
    })
}

example(of: "assign(to:on:)") {
    class SomeObject {
        var value: String = "" {
            didSet {
                print(value)
            }
        }
    }
    
}

class WordCollection {
    fileprivate lazy var items = [String]()
    
    func append(_ item: String) {
        self.items.append(item)
    }
}

extension WordCollection : Sequence {
    func makeIterator() -> WordIterator {
        return WordIterator(self)
    }
}

class WordIterator: IteratorProtocol {
    
    private let collection: WordCollection
    private var index = 0
    
    init(_ collection: WordCollection) {
        self.collection = collection
    }
    
    func next() -> String? {
        defer {
            index += 1
        }
        return index < collection.items.count ? collection.items[index] : nil
    }
}


