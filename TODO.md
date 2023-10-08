Main tasks:
    1. [X] Finish hitboxes
    2. [X] Elaborate further on player.lua as an entity
    3. [X] Learn how to do animations
    4. [X] Replace love.graphics with textures
    5. [X] MAKE THE WHOLE FUCKING ANIMATONS SHIT AGAIN
    6. [ ] Add Networking
    7. [ ] Learn how to do a map
    8.  [ ] Prepare for the map
    9.  [ ] Do the map
    10. [ ] Organise main.lua
    11. [ ] How to do UI?
    12. [ ] Do a simple HUI (health, cooldowns, buttons)
    13. [ ] Make a Main Menu
    14. [ ] Add properties to players
    15. [ ] Add more attack types (i.e. abilities)
    16. [ ] Develop Classes
    17. [ ] Add abilities (Q and E) and more classes + make combos work
    18. [ ] Add feedback to attacks (i.e. camera shake, particles)
    19. [ ] Remove unused textures for space (i.e. tilesheet / texture)

Current task: Add properties to players

task: Add properties to players
  - Add damangeReduction percentages and in attacks too
  - Add healing points in attacks


classes brainstorming:
    - Actions would be like: attack(LClick), 2nd attack(RClick), ability1(Q), ability2(Q)
    - There could be spells that give buffs, do area attacks, or movement
      - Buffs such as: haste, strength
      - Debuffs such as: stun, blind, slowness
      - Area attacks such as: fire ring, ice wall, 
    - Movement/special actions such as dodges, rolls or parries
    - classes should all be forced to melee. Else players will stay away:
      - there could be attacks with longer range and increased cooldown to promote combos
      - attacks that inflict stunning, also promoting combos (and skill indirectly)
    - "Automatic" attacks are a must to reduce click-spamming and thus noise (we are going to play in class after all)