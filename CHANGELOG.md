## indev Build 16

- Fixed forward thrust being applied when any movement key was pressed if the user does not have RCS

## indev Build 15 - Nameswap, Scaling Balance

- Temp Name Change: Astershift -> Aurora Transit
- Notice: old userdata is still stored under old name
	- If you would like to remove the old data, or transfer it to the new file:
		- On Windows: C:\\Users\\\[USER\]\\AppData\\Roaming\\Godot\\app_userdata\\\[Astershift/Aurora Transit\]
- Updated to Godot 4.4
- Bay resources are now capped at 10
- Added Bigger Bay upgrade to Inventory Monitor
- Added BERTHA upgrade to Bigger Bay
- Added Compartmentalization upgrade to Bigger Bay
- Added Mass Driver upgrade to Compartmentalization
- Added Borealis Station upgrade to Core Assembler
- Removed threading in Hangar
- Further optimized Hangar:
	- I no longer know how it works, but it seems to work
- Added flare shader to Apollo (replaces inner ring)
- Reduced rotation speed of Apollo, and edges no longer fade
- Power drain now ramps at 0.1/s beginning at 30 seconds
	- Starting energy upgrades increase it by 1 second per energy
	- Calibration increases time by 15s
	- Solar Cell increases time by 3s
	- RTG increases time by 1s
- On-Board Battery cost has been slightly buffed (4's -> 3's)
- Energy is now capped to starting energy
	- Overcharge increases cap by 30
- Costs of Calibration and Overcharge have been nerfed from 32 to 48 ceramic
- Dynamo has been buffed back to total velocity
- Artemis now goes through things in the way of its target, if that obstruction is far away enough (outside a 1px range)
- Focus Fire now loses target if you manually fire and hit nothing
- Removed pulsing yellow outline to energy meter value
- Fixed no save data causing garage to show "selected" arrow on every color
	- Not 100% sure fixed, and not 100% sure from a previous version
- Fixed a data storage system not properly defaulting, most notably fixing resolution on launch if not set in settings
- Adjusted Adapt setting for resolution
- Adjusted "IsAvailable" overlay of upgrades
- Scope creep is a hell of a drug. Stay sane, kids.

## indev Build 14

- !IMPORTANT!: Hangar now uses a thread per upgrade to help mitigate lag on buying
	- !IMPORTANT!: PLEASE let me know if this causes ANY issues
	- Optimized upgrade's propagation function a bit to further reduce latency
- Added Plasma Bubble upgrade to Charged Shield
- Solar Cell is now a child of RTG
- Inventory Audit is once again a child of Inventory Monitor
- Added Overcharge upgrade to Overclocking
- Added Calibration upgrade to Idle Process
- Added Focus Fire setting to Artemis (does not require Artemis enabled)
- Added target priority settings to Artemis (requires Artemis be enabled)
- Optimized laser targeting:
	- Will now only run retarget code every 0.25s instead of every physics frame
	- Will additionally run if Artemis loses its target
	- Will also run if an object enters or exits the laser's range
- Added Prioritize Resources setting to Attractor Beam
- "Buffed" Stage 2 acceleration: 4 -> 8
- Nerfed Charged Shield: now uses +1 energy
- Thruster VFX acceleration length is now capped by max speed
- Added WIP title icon to main menu
- Made adjustments to available Garage colors
- Fixed Stage 2 boost VFX not working when turning around
- Fixed RCS's drag not actually ever stopping the player
	- This also fixed drag not working as well as v11, due to a fix in v12
- Fixed RCS only ever rotating you within 5 degrees of the RCS cursor
- Fixed Reset button in Hangar not resetting Upcycler's incrementor for core conversions
- Fixed resolution options
- Fixed Juniper Beam not applying any force to stationary resources when the ship is not moving

## indev Build Unlucky 13

- Added Basic Radar Dish and Radar back
	- They now showcase nearby things instead of allow zoom out
	- UI is in bottom left
- Added Radioisotope Thermoelectric Generator upgrade to On-Board Battery
- Solar Cell now costs a core
- Ion Engine is now a child of Combustion ARCS
- Idle Process is now a child of On-Board Battery
- Inventory Monitor is now a child of Extra Spoolage
- Inventory Audit is now a child of Status Monitor
- Upcycler's core transformation is now guaranteed every 250th, instead of chance-based
- Added Production Line upgrade to Synthesizer
- Adjusted thruster VFX
- Added *very* basic resolution setting in options menu and options button in main menu
- Slightly adjusted font, and added the squared (²) symbol.
- Arrow keys can be used to control the ship now
- Added High-Visibility Asteroids option
- Added background to Garage
- Buffed Inventory Audit costs:
	- Metal: 5 -> 2
	- Ceramic: 5 -> 2
	- Synthetic: 5 -> 2
	- Organic: 10 -> 6

## indev Build 12

- Added Swift Assembly upgrade to Synthesizer
- Added Hephaestus upgrade to Foundry
- Added Core Forge upgrade to Foundry
- Added Godrays upgrade to Laser Array
- Buffed Artemis modifiers from 60% to 80%
- Artemis now grants an additional unit of range regardless of discarded lasers
	- Discarded lasers still buff range by +2u
- Nerfed Artemis core cost: 1 -> 2
- Kiln is now a child of Composter
- Fixed Upcycler having a 1/200 chance to convert *every* resource rather than every *seventh* resource
- Nerfed Upcycler core chance from 1/200 to 1/250
- Dynamo now scales with speed out of max speed, instead of total speed
	- This shouldn't affect early-game much but nerfs Dynamo late-game
- Adjusted resolution of game window
- Game now starts in exclusive fullscreen
- Overhauled hangar visuals
- Temporarily removed all zoom and zoom upgrades
- Fixed RCS with very high acceleration values causing flashing thrust when stopping
 	- As a result, RCS's decceleration has been slightly worsened
- Gravity Well no longer doubles thrust *visuals*, it still doubles everything that matters
- Added Time Spent to Run Overview
- Added Distance Covered to Run Overview
- Fixed Backup Battery charging or being damaged while the run is over
- Touched-up main menu a bit
- Implemented custom font
- Inventory Monitor no longer sorts Hangar's resources
- Buffed ARCS cost:
	- Ceramics: 6 -> 3
	- Metals: 2 -> 1
	- Synthetics: 4 -> 0
- Buffed Core Assembler costs:
	- Organics: 16 -> 6
	- Ceramics: 8 -> 4
	- Synthetics: 8 -> 4
	- Metals: 4 -> 2
- Buffed Hydroponics Pod organic cost: 12 -> 8
- Buffed Fine Wire synthetic cost: 64 -> 58
- Buffed Bigger Coils costs:
	- Metals: 24 -> 12
	- Synthetics: 48 -> 24
- Adjusted Military-Grade Laser costs:
	- Metals: 15 -> 30
	- Ceramics: 10 -> 12
	- Synthetics: 10 -> 0
- Adjusted Akimbo costs:
	- Ceramics: 4 -> 8
	- Synthetics: 16 -> 8
	- Organics: 8 -> 0
- Nerfed Spare Battery costs:
	- Metals: 4 -> 8
	- Organics: 2 -> 8
- Nerfed Shield Projector metal cost: 16 -> 32
- Nerfed Upcycler costs:
	- Metals: 0 -> 8
	- Synthetics: 0 -> 8
	- Organics: 32 -> 48

## indev Build 11

- Precision Prospector is now a child of Rapid Winch, and costs of that path have been adjusted to be more synthetic-focused
- Adjusted Electromagnet costs:
	- Metal: 12 -> 10
	- Synthetic: 10 -> 12
- Increased opacity of Apollo when not combined with Artemis
- Added Overclocking upgrade to Stage 2
- Added Idle Process upgrade to Solar Cell
- Fixed Stage 2 increasing max speed passively
	- To compensate, the active bonus has been buffed from 8u/s to 12u/s
- Added Ion Engine upgrade to Overclocking
- Added Linear Drive upgrade to Idle Process
- Added Gimbal Drive upgrade to Linear Drive
- Added Gravity Well upgrade to Gimbal Drive
- Added Bigger Coils upgrade to Electromagnet
- Added Fine Wire upgrade to Electromagnet
- Core Assembler now directly follows Research Network
- Hydroponics is now a child of Core Assembler
- Composter is now a child of Hydroponics Pod
- Synthesizer is now a child of Composter
- Added Kiln upgrade to Synthesizer
- Added Scrapper upgrade to Kiln
- Added Foundry upgrade to Kiln
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

## indev Build 10

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

## indev Build 9

- Adjusted/refurbished various sprites
- Fixed Dynamo not having a parent (Furnace)
- Fixed Hydroponics Pod generating organics even if it wasn't bought
- Fixed Upcycler functioning even if it wasn't bought
- Flipped a layer of Starry Night to prevent obviously identical stars from overlapping

## indev Build 8

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

## indev Build 7

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

[I'm tired, hoss](https://www.youtube.com/watch?v=siq9ln7EvmA)
