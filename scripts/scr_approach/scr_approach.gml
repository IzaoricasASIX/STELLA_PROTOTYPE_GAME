function scr_approach(cur, target, amt) {
    if (cur < target) return min(cur + amt, target);
    return max(cur - amt, target);
}
