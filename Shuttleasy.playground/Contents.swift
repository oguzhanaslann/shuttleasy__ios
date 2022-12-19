import Foundation

let input = "2022-12-19T00:29:29.954Z"
let formatter = DateFormatter()
formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"

let date = formatter.date(from: input)!

formatter.dateFormat = "HH:mm dd MMMM yyyy"
let output = formatter.string(from: date)
// Output: "00:29 19 December 2022"

print(output)
