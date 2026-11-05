var spd = abs(other.hsp);

if (spd >= required_speed) {
    hp--;
    other.hsp *= 0.6;

    if (hp <= 0) {
        instance_destroy();
    }
}
else {
    other.hsp = -sign(other.hsp) * 2;
}
