![](https://img.shields.io/badge/Signed-Yes-00AA00)
![](https://img.shields.io/badge/dynamic/json?query=downloads&url=https%3A%2F%2Fopenplanet.dev%2Fapi%2Fplugin%2F382&label=Downloads&color=purple)
![](https://img.shields.io/badge/dynamic/json?query=version&url=https%3A%2F%2Fopenplanet.dev%2Fapi%2Fplugin%2F382&label=Version&color=red)
![](https://img.shields.io/badge/Game-TM-blue)
![](https://img.shields.io/badge/Game-MP4-blue)
![](https://img.shields.io/badge/Game-Turbo-blue)

![image](images/current-effects-1.png)

# Current Effects
So many things can affect your car, ranging from an effect that kills your engine to one that makes you fly. It can be hard to keep track of it all, and now you don't have to! With a little window on your screen, you get a comprehensive overview of the things you need to worry about.
- "Did I actually touch that fragile block?"
- "When is my reactor going to run out?"
- "How wet am I?"

Not all statuses (the things we track) are available everywhere. Refer to the chart below to see what is and where. If you're a developer and want to add a checkmark somewhere, human-written PRs are always welcome.

|status              |solo|replay|server|spectate|tm2 solo|tm2 server|tm2 spectate|turbo solo|turbo server|turbo spectate
|:-:                 |:-: |:-:   |:-:   |:-:     |:-:     |:-:       |:-:         |:-:       |:-:         |:-:
|action key          |✅|❌|✅|❌|❌|❌|❌|❌|❌|❌
|brake pedal         |✅|❌|✅|❌|❌|❌|❌|❌|❌|❌
|camera              |✅|❌|✅|✅|✅|✅|✅|✅|✅|❌
|cruise control      |✅|✅|✅|✅|❌|❌|❌|❌|❌|❌
|cruise control speed|✅|✅|✅|✅|❌|❌|❌|❌|❌|❌
|driving             |✅|✅|✅|❌|✅|✅|✅|✅|✅|❌
|engine off          |✅|❌|✅|✅|✅|✅|❌|✅|✅|❌
|entity id           |✅|✅|✅|✅|✅|✅|✅|❌|❌|❌
|finished            |✅|✅|✅|❌|✅|✅|✅|✅|✅|❌
|forced acceleration |✅|❌|✅|✅|✅|✅|❌|❌|❌|❌
|fragile             |✅|⚠️|✅|⚠️|❌|❌|❌|❌|❌|❌
|fragile damage      |✅|❌|✅|❌|❌|❌|❌|❌|❌|❌
|game mode           |✅|✅|✅|✅|✅|✅|✅|✅|✅|✅
|ghost visibility    |✅|✅|✅|✅|✅|✅|✅|✅|✅|✅
|launch respawning   |✅|❌|✅|❌|❌|❌|❌|❌|❌|❌
|login               |✅|❌|✅|✅|✅|✅|✅|✅|✅|❌
|name                |✅|✅|✅|✅|✅|✅|✅|✅|✅|❌
|nametag visibility  |✅|✅|✅|✅|✅|✅|✅|❌|❌|❌
|no brakes           |✅|❌|✅|✅|✅|✅|❌|❌|❌|❌
|no grip             |✅|❌|✅|✅|✅|✅|❌|❌|❌|❌
|no steering         |✅|❌|✅|✅|✅|✅|❌|❌|❌|❌
|opponent visibility |✅|✅|✅|✅|✅|✅|✅|❌|❌|❌
|race time           |✅|❌|✅|✅|❌|❌|❌|❌|❌|❌
|reactor             |✅|✅|✅|✅|❌|❌|❌|❌|❌|❌
|reactor duration    |✅|❌|✅|❌|❌|❌|❌|❌|❌|❌
|reactor final timer |✅|❌|✅|✅|❌|❌|❌|❌|❌|❌
|reactor level       |✅|✅|✅|✅|❌|❌|❌|❌|❌|❌
|reactor remaining   |✅|❌|✅|❌|❌|❌|❌|❌|❌|❌
|reactor type        |✅|✅|✅|✅|❌|❌|❌|❌|❌|❌
|respawn duration    |✅|❌|✅|❌|❌|❌|❌|❌|❌|❌
|respawn end tick    |✅|❌|✅|❌|❌|❌|❌|❌|❌|❌
|respawning          |✅|❌|✅|❌|❌|❌|❌|❌|❌|❌
|respawn remaining   |✅|❌|✅|❌|❌|❌|❌|❌|❌|❌
|respawns            |✅|❌|✅|✅|✅|✅|✅|✅|✅|❌
|sequence            |✅|✅|✅|✅|✅|✅|✅|✅|✅|✅
|slow-mo             |✅|✅|✅|✅|❌|❌|❌|❌|❌|❌
|slow-mo coefficient |✅|✅|✅|✅|❌|❌|❌|❌|❌|❌
|slow-mo duration    |⚠️|❌|⚠️|❌|❌|❌|❌|❌|❌|❌
|slow-mo level       |✅|✅|✅|✅|❌|❌|❌|❌|❌|❌
|slow-mo remaining   |✅|❌|✅|❌|❌|❌|❌|❌|❌|❌
|spawning            |✅|✅|✅|✅|✅|✅|✅|✅|✅|❌
|stand respawning    |✅|❌|✅|❌|❌|❌|❌|❌|❌|❌
|start tick          |✅|❌|✅|✅|✅|✅|✅|✅|✅|❌
|ticks               |✅|✅|✅|✅|✅|✅|✅|✅|✅|✅
|turbo               |✅|✅|✅|❌|✅|✅|❌|✅|✅|❌
|turbo level         |✅|✅|✅|❌|❌|❌|❌|❌|❌|❌
|turbo timer         |✅|✅|✅|❌|✅|✅|❌|✅|✅|❌
|vehicle type        |✅|✅|✅|✅|⚠️|⚠️|⚠️|✅|✅|✅
|web services id     |✅|❌|✅|✅|❌|❌|❌|❌|❌|❌
|water               |✅|✅|✅|❌|❌|❌|❌|❌|❌|❌

- ⚠️ when watching a replay or spectating, fragile only appears if at least one tire is partially worn
- ⚠️ when switching to/from alt cars, slow-mo duration may be wrong
- ⚠️ vehicle type is probably wrong in envimix

## Thank You

I want to give a special thank you to the following developers who have given me great insight and assistance on this project. Without their research and help in testing, this plugin would be a shell of what it is now.
- Miss
- XertroV
- achepta
- druduche
- Fort
- Manama
