// ExpectToEventuallyEqual by Jon Reid (https://qualitycoding.org) and Steven Baker (https://stevenrbaker.com)
// Copyright 2023 Jonathan M. Reid. https://github.com/jonreid/ExpectToEventuallyEqual/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

import ExpectToEventuallyEqual

final class FailSpy: Failing {
    private(set) var callCount = 0
    private(set) var messages: [String] = []
    private(set) var locations: [SourceLocation] = []

    func fail(message: String, location: SourceLocation) {
        callCount += 1
        self.messages.append(message)
        self.locations.append(location)
    }
}
