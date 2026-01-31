## kaynes_garbage 🗑️
Production garbage collection job system for FiveM (QBox)

kaynes_garbage is a configurable, end-to-end garbage collection job system built for FiveM servers using QBox and ox_lib.  
It was designed to model a complete job workflow from start to finish, with a focus on clarity, performance, and real server usage.

The system includes job start logic, vehicle spawning, route-based task progression, interactive world props, and payment handling — all configurable to suit different server setups.

---

## Features

- Job start at a configurable location (e.g. truck yard)
- Automatic work vehicle spawning and management
- Route-based task system across multiple locations
- Interactive garbage bin collection and disposal workflow
- Player interaction: dragging bins to trucks and emptying
- Job completion and payment handling
- Outfit changing and full configuration support
- Designed to run at very low latency

---

## Framework & Integrations

- **Framework:** QBox  
- **Libraries:** ox_lib  
- **Integrations:**  
  - qbx_vehiclekeys  
  - ox_fuel  

These integrations ensure a streamlined and immersive job experience.

---

## Technical Overview

This project demonstrates:

- Lua-based event-driven job systems  
- State management across multi-step workflows  
- Route generation and task progression logic  
- World interaction handling and prop management  
- Performance-conscious scripting for live multiplayer servers  
- Modular, configuration-driven design  

The system was built to be reliable under real player usage rather than as a proof-of-concept.

---

## Requirements

- **ox_lib (v3.24.0)**  
  https://github.com/overextended/ox_lib/releases/tag/v3.24.0  

---

## Installation

Basic setup consists of adding the resource, configuring job locations, routes, props, and rewards, and ensuring required dependencies are running.

---

## Preview

https://youtu.be/RBc8WJZj2zk

---

## Credits

- Ox Team for their ox_lib framework  
- Phoenix for inspiration and animations  
  https://forum.cfx.re/t/free-esx-trasher-job/5166462  

---

## Project Status

This project is **archived** and may use patterns or dependencies that are outdated by current standards.

It is preserved as a reference for building complete, real-world job systems and gameplay workflows.  
More recent projects in this profile better represent my current approach and skill level.

---

## Notes

This project reflects an emphasis on building full-featured systems, clean structure, and performance-aware scripting in live environments.
