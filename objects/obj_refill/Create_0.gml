// DASH CRYSTAL: touch it to refill your air dash (Stella) / air attack (Nila).
// It comes back after a few seconds. Great for building long dash-chain puzzles.
respawn_time = 180;   // frames until it comes back (change per instance in Creation Code)
timer = 0;
active = true;
t = irandom(100);
