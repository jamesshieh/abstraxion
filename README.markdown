Abstraxion v0.2
===============

Abstraxion is a game based around the concept of abstraction.

### To run

    bundle install
    bin/console_axn   # for console printing tester
    bin/abstraxion    # for visual gosu client

### Console Abstraxion

Currently displays the grid layer of the game represented by unicode box
drawings.

Node legend:  
Bold red nodes currently have a pulse in them  
Red nodes are generators, pulses originate from these nodes and pulses that
reach these nodes become shots  
Yellow nodes are amplifiers, these increase the pulse power  
Blue nodes are switchers, these will alternate the pulses between their
connections  
Green nodes are splitters, these will split nodes into multiple directions at
the cost of power  

Currently building generalized game logic that can be applied to different
frameworks for the game. More details to come when an interface is built out.

### Currently working on:

Visual node connections
Node level abstraction
Main map and playability
Monsters and waves for core gameplay
