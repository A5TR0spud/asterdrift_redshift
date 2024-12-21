## indev build 11

- Precision Prospector is now a child of Rapid Winch, and costs of that path have been adjusted to be more synthetic-focused
- Adjusted Electromagnet costs:
	- Metal: 12 -> 10
	- Synthetic: 10 -> 12
- Increased opacity of Apollo when not combined with Artemis
- Added Overclocking upgrade to Stage 2
- Added Idle Process upgrade to Solar Cell
- Core Assembler now directly follows Research Network
- Hydroponics is now a child of Core Assembler
- Synthesizer is now a child of Core Assembler
- Furnace is now a child of Synthesizer
- Composter is now a child of Hydroponics
- Reworked Stasis Bay, and its now a child of Electromagnet
- Reworked Tractor Bay
- Removed Electromagnet's doubled attraction and halved repulsion to resources
- Adjusted Core Assembler costs:
	- Metal: 16 -> 4
	- Ceramics: 24 -> 8
	- Synthetics: 24 -> 8
	- Organics: 32 -> 16
- Nerfed Core generation: 4 -> 1
- Figured out and fixed the seconds issue for Core Assembler's timer
- Adjusted zoom and scaling in the hangar in hopes of making text more legible

## indev build 10

- Added Apollo upgrade to Akimbo
- Added Artemis upgrade to Akimbo
- Buffed Inventory Monitor to include hangar materials
- Reduced Core generation 8 -> 4
- Nerfed Stage 2 Ceramic cost: 10 -> 32
- Fixed Upcycler and Core cropping issue on pickup notifications from Inventory Audit
- Fixed overwriting of source in inventory log; Upcycler now properly displays next to conversions that it causes
- Buffed Military-Grade Laser Core cost: 1 -> 0
- Buffed Juniper Beam: now applies a 1.2x multiplier to mining speed
- In the hangar, middle mouse button no longer resets zoom
- In the hangar, the camera can now be dragged with LMB, RMB, or MMB
- Buffed Core Assembler: 5 minutes -> 3 minutes
- Adjusted Core Assembler costs:
	- Ceramics: 16 -> 24
	- Synthetics: 16 -> 24
	- Organics: 24 -> 32
	- Cores: 1 -> 0
	- Metal remains 16
- Alternating Charger now costs a core
- Tractor Bay no longer costs a core
- Upcycler costs a core now
- Combustion ARCS now changes color of RCS thrust to the same as main thrust
- Completely reworked asteroids
	- Asteroids now spawn in different sizes
	- Asteroids colliding with each other take damage
	- Killing an asteroid causes it to split if its big enough
		- If it's too small to split, it rolls a resource from its loot table
	- Mining has been reworked
		- Switched timer from per laser to per asteroid
		- Asteroids will lose size after being mined sufficiently
			- If it's too small to lose size, it will have to be killed with damage
		- Resources mined no longer cause a burst of damage to the asteroid
		- Cores can no longer be obtained from mining

## indev build 9

- Adjusted/refurbished various sprites
- Fixed Dynamo not having a parent (Furnace)
- Fixed Hydroponics Pod generating organics even if it wasn't bought
- Fixed Upcycler functioning even if it wasn't bought
- Flipped a layer of Starry Night to prevent obviously identical stars from overlapping

## indev build 8

- Added Stasis Bay upgrade to Rapid Winch
- Added Tractor Bay upgrade to Stasis Bay
- Added 3 HUD upgrades, level 1 is always bought (like the hook)
- Added Hydroponics Pod upgrade to Research Engine
- Added Synthesizer upgrade to Hydroponics Pod
- Added Composter upgrade to Synthesizer
- Added Recycler upgrade to Composter
- Added Furnace upgrade to Hydroponics Pod
- Added Dynamo upgrade to Furnace
- Added Upcycler upgrade to Recycler
- Core Assembler is now a child of Synthesizer
- Nerfed Laser Array Core cost: 1 -> 2
- Nerfed Military-Grade Laser Core cost: 0 -> 1
- Buffed Juniper Beam attraction multiplier: 1.5 -> 2
- Buffed Core Assembler cost 32's -> 16's
	- Organics cost 24
- Fixed Core Assembler counting w/o the upgrade
- Fixed asteroids having a 100% chance to drop cores on death
- Fixed thrust showing in garage
- Thrust is now trianglular instead of a box
- Fixed cores from killing asteroids not wrapping around with player
- Fixed resources from mining asteroids not wrapping around with player
- Holding boost with Stage 2 now forces ship to move forward
- Boost from Stage 2 now has visual effect on thruster
- Fixed Core Assembler sometimes showing really weird second values in the Hangar
- Changed wrap-around to both be square, fixing overcrowing
- Quadrupled world size
- Changed weight system to be exact amount per run, and adjusted numbers:
	- Metal: 100 -> 404
	- Synthetic: 100 -> 404
	- Ceramic: 100 -> 404
	- Organic: 75 -> 300
	- Cores: 2 -> 8
	- Total Collectables: 380 -> 1520
	- Asteroids: 180 -> 720
- Updated "Starry Night" background of runs

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
- Added Industrial Fuse upgrade to Backup Power
- Added Alternating Charger upgrade to Industrial Fuse
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
- Fixed lasers targeting the wrong object
- All lasers now target the cursor when holding fire
- Added wrap-around to player and world
- Added temporary thruster visual FX
- Changed generation to be beginning of run instead of also over time
	- Objects are distributed evenly instead of radially

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
