$fn=100;

main(
    face_h = 4.5
);

module main() {
    face(
        h = face_h
    );
}

module face(
        r = 24,
        h_t = 3.5,
        r_t = 1,
        slot_l = 36.5,
        slot_w = 25,
        slot_r = 2
    ){
    difference() {
        cylinder(h=h, r=r);

        translate([0, 0, -1])
        cylinder(h=h - h_t + 1, r=r - r_t);

        translate([0, 0, -1])
        linear_extrude(height=h + 2)
        offset(r=slot_r)
        square([slot_l - slot_r * 2, slot_w - slot_r * 2], true);

        translate([0, 0, h - 1])
        hull() {
            translate([0, 0, 2])
            linear_extrude(height=1)
            offset(r=slot_r + 1)
            square([slot_l - (slot_r + 1) * 2 + 4, slot_w - (slot_r + 1) * 2 + 4], true);

            linear_extrude(height=1)
            offset(r=slot_r)
            square([slot_l - (slot_r) * 2, slot_w - (slot_r) * 2], true);
        }

        intersection() {
            translate([0, 0, h - h_t + 1])
            rotate([180, 0, 0])
            hull() {
                translate([0, 0, 2])
                linear_extrude(height=1)
                offset(r=slot_r + 1)
                square([slot_l - (slot_r + 1) * 2 + 4, slot_w - (slot_r + 1) * 2 + 4], true);

                linear_extrude(height=1)
                offset(r=slot_r)
                square([slot_l - (slot_r) * 2, slot_w - (slot_r) * 2], true);
            }

            cylinder(h=h - h_t + 1, r=r - r_t);
        }
    }
}
