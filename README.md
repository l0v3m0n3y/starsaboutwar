# starsaboutwar
web api for starsaboutwar.in.ua A list of celebrities who, through words and actions, have supported Russia's war against Ukraine, as well as the policies of Putin and the Kremlin regime.
# main
```swift
import Foundation
import starsaboutwar

let starsAboutWarCli = starsAboutWar()
let findStar = try await starsAboutWarCli.searchStar(searchTerm: "nekoglai")
print(findStar)
```

# Launch (your script)
```
swift run
```
