# Roblox Flight Controller Script

Skybound Flight is a client-side Roblox script written in Luau that adds a camera-relative flight controller, allowing players to toggle flight, move horizontally, rise, and descend using keyboard controls in a Roblox experience.

## Install

1. Open your experience in Roblox Studio.
2. In the Explorer, open `StarterPlayer` and then `StarterPlayerScripts`.
3. Create a new `LocalScript`.
4. Copy the contents of `FlightController.client.lua` into the LocalScript.
5. Start a play test to verify the controller.

## Use

1. Press `F` to start flying.
2. Press `F` again to stop flying.
3. Hold `W` to move forward relative to the camera.
4. Hold `S` to move backward relative to the camera.
5. Hold `A` or `D` to move left or right relative to the camera.
6. Hold `Space` to rise.
7. Hold `LeftCtrl` to descend.

To change the movement speed, edit the `FLIGHT_SPEED` value near the top of the script. The default speed is 60.

The controller automatically stops flight when the character is replaced or the humanoid is unavailable. It uses Roblox `LinearVelocity` and `AlignOrientation` constraints to control movement and facing direction. Because this is a client-side controller, server-side validation should be added for competitive experiences or gameplay where unauthorized flight must be prevented.

---

More Roblox script projects by EnderDevelopment: https://github.com/EnderDevelopment

Project page: https://dash.enderdevelopment.com/community/ce6cb349-b6d5-452b-8025-e2f3dc015526?utm_source=github&utm_medium=readme&utm_campaign=auto_publish&utm_content=ce6cb349-b6d5-452b-8025-e2f3dc015526
