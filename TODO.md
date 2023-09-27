Main tasks:
    1. [X] Finish hitboxes
    2. [X] Elaborate further on player.lua as an entity
    3. [X] Learn how to do animations
    4. [X] Replace love.graphics with textures
    5. [ ] Make animations and a testing class
    6. [ ] Apply animations
    7. [ ] Add Networking
    8. [ ] Learn how to do a map
    9. [ ] Do the map
    10. [ ] Organise main.lua
    11. [ ] Make player.lua take on various classes
    12. [ ] Elaborate on inputs (i.e. type of attacks)
    13. [ ] Make various classes and animations
    14. [ ] Add feedback to attacks (i.e. camera shake, particles)
    15. [ ] Remove unused textures for space (i.e. tilesheet / texture)

Current task: Make animations and finish testing class


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