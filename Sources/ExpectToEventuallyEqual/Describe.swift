// SPDX-License-Identifier: MIT

func describe<T>(_ type: T.Type, value: T) -> String {
    let description = String(describing: value)
    if type == String.self {
        return toCSyntaxString(description)
    }
    return description
}

private func toCSyntaxString(_ unformatted: String) -> String {
    let result = unformatted.map { toCSyntax($0) }
    return "\"\(result.joined())\""
}

private func toCSyntax(_ ch: Character) -> String {
    switch ch {
    case "\"":
        return "\\\""
    case "\n":
        return "\\n"
    case "\r":
        return "\\r"
    case "\t":
        return "\\t"
    default:
        return String(ch)
    }
}