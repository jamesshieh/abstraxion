Abstraxion v0.3
===============

Abstraxion is a game based around the concept of abstraction.

### Dependencies

Please see https://github.com/jlnr/gosu/wiki and check in the sidebar for your
system specific dependencies for the Gosu game library.

Install gem dependencies with:

    bundle install

### To run

    bin/abstraxion

#### Controls

Space - Toggle between Build and Play modes
Left Click - Add node connections
Right Click - Toggle node types

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
