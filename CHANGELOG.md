## indev build 7

- Implemented and nerfed Core Assembler
- Re-added Stage 2 from v4 with some changes:
	- Now costs a core
	- Max speed is only increased while boosting
	- Boosting always thrusts ship forward
	- No longer decreases turn rate
- Holding the boost key now disables RCS's "drag" effect, even if you don't have Stage 2
- Implemented Charged Shield
- Implemented Backup Power
- Added Solar Cell upgrade to On-Board Battery
- Added Juniper Beam upgrade to Attractor Beam
- Fixed asteroid collision damage considering mass in a strange way, resulting in gentle collisions killing the player
- Fixed mentions of units in RCS's upgrade path (divided by 16)
- Electromagnet no longer costs a core.
	- Metal 11 -> 12
	- Synthetics 9 -> 10
	- Attraction to resources has been doubled.
	- Repulsion to resources has been halved.
- The magnetic coefficients of each resource have been evened out:
	- Metal 2.0 -> 1.75
	- Ceramic 1.0 -> 1.1
	- Organic 0.5 -> 0.9
	- Synthetic remains 1.0 and Core remains 1.5
- Nerfed Akimbo costs:
	- Metal 16 -> 32
	- Synthetics 8 -> 16
	- Organics 4 -> 8
	- Ceramics 2 -> 4
	- Core remains 1
- Buffed Laser Array stats:
	- Damage x0.5 -> x0.6
	- Mining Time x2 -> Mining Speed x0.6
	- Clarified description stats to reflect the amount of lasers.
- Nerfed Laser Array costs:
	- Metal 48 -> 64
	- Ceramics 16 -> 32
	- Synthetics 16 -> 24
	- Core remains 1
- Adjusted textures of RCS, ARCS, CARCS, Movement Relative to Ship
- Radar was a flawed design so has been removed

## indev Build 6

- Fixed Shield Deflector VFX not appearing
- Added RESET and CHEAT buttons to the hangar
- Fixed Needle Lasers blinking when targetting objects 8 pixels closer than the max range
- Initial Needle Laser now stays centered
- Additional Needle Lasers now rotate 7 pixels away from center
- Generation: Increased weight of Organics (50 -> 75) and Cores (1 -> 2). Other weights remain 100.
- New Asteroid Mining Weights: 
	- Metals (4 -> 400)
	- Ceramics (0 -> 50)
	- Synthetics (0 -> 25)
	- Organics (1 -> 100)
	- Cores (0 -> 1)
- Asteroids have a 10% chance to create a Core when destroyed
- Rebalanced costs based on my own gameplay
- Incomplete (this build is rushed because v5 is a virus?):
	- Re-added Booster from v4 with some changes
	- Added Core Assembler
	- Added Radar
	- Added Radar Recognition Systems
	- Added Charged Shield
	- Added Backup Power

## indev Builds 1-5: unrecorded
