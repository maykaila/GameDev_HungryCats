# 🐾 Hungry Cats

A physics-based 2D slingshot game built in Godot 4. The neighborhood cats have had their precious fish stolen by the devious rats, and it's time to get it back—one catapult launch at a time!

## 🚀 Current Status: In Development

The game is currently in active development. The foundational systems, UI, and initial level designs are implemented, with core gameplay mechanics currently being built.

### ✅ What's Working Right Now
*   **Cinematic Storyline Intro:** A fully implemented, fade-in comic strip intro ("The Great Fish Heist") that explains the cats' motivation, complete with an interactive "Wanna play?" start screen.
*   **Dynamic UI & Menus:** 
    *   Updated Main Menu featuring a continuously looping parallax city background.
    *   Working interactive buttons (Start, Settings).
    *   Custom Settings popup with toggle switches.
*   **Audio Systems:** 
    *   Global Background Music (BGM) implemented using an Autoload/Singleton so the music plays seamlessly across scene changes.
    *   Audio bus routing set up for independent Music and SFX volume control.
*   **Level Design (Levels 1 - 3):** 
    *   The first three levels are fully designed and mapped out.
    *   Destructible environments: Wooden and stone forts for the rats are built and placed in the scenes.
*   **Characters:** The main cat and rat sprites/nodes are fully integrated into the game world.
*   **Demo:**
    https://github.com/user-attachments/assets/dd2f58e8-e171-4df9-91d3-77cbc0ebcf0c





### 🚧 Work in Progress (Coming Soon)
*   **Core Gameplay Mechanics:** The slingshot/catapult physics, launching cats, and structure destruction logic.
*   **Sound Effects (SFX):** Adding impact sounds, catapult snaps, cat meows, and rat squeaks to the SFX audio bus.
*   **Win/Loss States:** Logic for completing a level when all rats are defeated or restarting when out of cats.
