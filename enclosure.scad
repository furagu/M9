$fn=100;

main(
    face_h = 4.5
);

module main() {
    // face(
    //     h = face_h
    // );

    tensioner_stand(
    );
}

module tensioner_stand(
        screw_r = 0.75,

        bearing_r = 4,
        bearing_l = 2.5,

        bearing_stand_h = 6.8,
        bearing_stand_r = 2,
        bearing_stand_distance = 14,
        bearing_stand_l = 2,

        bearing_stopper_l = 0.4,
        bearing_stopper_w = 0.7,

        adjuster_stand_y = 18,
        adjuster_stand_h = 10,
        adjuster_overlap = 0.2
    ){

    stand_y_positions = [-bearing_stand_distance / 2, bearing_stand_distance / 2];

    difference() {
        union() {
            for(y = stand_y_positions) {
                translate([0, y, 0])
                cylinder(h=bearing_stand_h, r=bearing_stand_r);
            }

            translate([-bearing_stopper_l - bearing_stand_l / 2, -bearing_stand_distance / 2, 0])
            cube(size=[bearing_stand_l + bearing_stopper_l, bearing_stand_distance, bearing_stand_h]);

            translate([-bearing_stand_l / 2, -bearing_r, 0])
            cube(size=[bearing_l, bearing_r * 2, bearing_stand_h - bearing_r / 2]);

        }

        for(y = stand_y_positions) {
            translate([0, y, -1])
            cylinder(h=bearing_stand_h + 2, r=screw_r);
        }

        translate([-bearing_stand_l / 2, 0, bearing_stand_h])
        rotate([0, 90, 0])
        cylinder(h=bearing_l + 1, r=bearing_r);

        translate([-bearing_stand_l, 0, bearing_stand_h])
        rotate([0, 90, 0])
        cylinder(h=bearing_stand_l * 2, r=bearing_r - bearing_stopper_w);
    }


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
