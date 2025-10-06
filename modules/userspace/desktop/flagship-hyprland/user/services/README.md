# Services

## Idle Killer

The Idle Killer service intends to optimize system performance by stopping apps running in the background. It consists of two subsystems defined as services in systemd. The two services of Idle Killer are as follows:

- First service (concurrent killing): Manages specific apps concurrently. Each app has its own timer managed concurrently. If a timer exceeds the allotted time, the respective app is stopped. If an app is focused, its timer is reset.
- Second service (priority-based killing): Manages a single timer for the oldest running app. Past visited apps are stored in a set queue. Each time the oldest entry in the queue changes (an app is revisited and pushed back up, or is stopped), the timer manager switches to that app. The operation of that timer is congruent to the manager of the first service.

The backend used for finding the focused app in Hyprland is `hyprctl active-window`, which is polled every few seconds.
