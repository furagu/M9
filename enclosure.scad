$fn=100;

main(
    face_h = 5
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
        bearing_l = 3,

        bearing_stand_h = 8,
        bearing_stand_r = 2,
        bearing_stand_distance = 14,
        bearing_stand_l = 2,

        bearing_stopper_l = 0.4,
        bearing_stopper_w = 0.7,

        adjuster_stand_w = 11,
        adjuster_stand_h = 10,
        adjuster_stand_notch = 1.5,

        adjuster_slider_w = 5,
        adjuster_slider_y = 6,
        adjuster_slider_h = 8.5,
        adjuster_slider_r = 0.75,

        arm_stand_y = 10,
        arm_stand_h = 8,
        arm_stand_x = 2.7,
        arm_stand_r = 3,
        arm_stand_l = 2,
        arm_l = 3,
        arm_stand_pin_r = 0.75
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

            translate([-bearing_stand_r, -adjuster_stand_w - bearing_stand_distance / 2, 0])
            cube([bearing_stand_r * 2, adjuster_stand_w, adjuster_stand_h]);

            translate([0, -adjuster_stand_w - bearing_stand_distance / 2, 0])
            cylinder(r=bearing_stand_r, h=adjuster_stand_h);

            translate([arm_stand_x, bearing_stand_distance / 2 + arm_stand_y - arm_stand_r, 0])
            difference() {
                union() {
                    translate([0, arm_stand_r, arm_stand_h])
                    rotate([0, 90, 0])
                    cylinder(r=arm_stand_r, h=arm_stand_l * 2 + arm_l);

                    cube([arm_stand_l * 2 + arm_l, arm_stand_r * 2, arm_stand_h]);
                }

                translate([arm_stand_l, -1, arm_stand_h - arm_stand_r])
                cube([arm_l, arm_stand_r * 2 + 2, arm_stand_r * 2 + 1]);

                translate([-1, arm_stand_r, arm_stand_h])
                rotate([0, 90, 0])
                cylinder(r=arm_stand_pin_r, h=arm_stand_l * 1.5 + arm_l + 1);
            }

            translate([-bearing_stand_l / 2, bearing_stand_distance / 2, 0])
            cube(size=[bearing_stand_l, arm_stand_y - arm_stand_r, arm_stand_h - arm_stand_r ]);

            translate([-bearing_stand_l / 2, bearing_stand_distance / 2 + arm_stand_y - arm_stand_r, 0])
            rotate([0, 0, -45])
            cube(size=[bearing_stand_l, arm_stand_y - arm_stand_r, arm_stand_h - arm_stand_r ]);

        }

        for(y = concat(stand_y_positions, [-bearing_stand_distance / 2 - adjuster_stand_w])) {
            translate([0, y, -1])
            cylinder(r=screw_r, h=adjuster_stand_h + 2);
        }

        translate([-bearing_stand_r - 1, -adjuster_stand_notch - bearing_stand_distance / 2, bearing_stand_h])
        cube([bearing_stand_r * 2 + 2, bearing_stand_r, bearing_stand_h]);

        translate([-bearing_stand_l / 2, 0, bearing_stand_h])
        rotate([0, 90, 0])
        cylinder(h=bearing_l + 1, r=bearing_r);

        translate([-bearing_stand_l, 0, bearing_stand_h])
        rotate([0, 90, 0])
        cylinder(h=bearing_stand_l * 2, r=bearing_r - bearing_stopper_w);

        translate([-bearing_stand_r - 1, -bearing_stand_distance / 2 - adjuster_slider_w / 2 - adjuster_slider_y, adjuster_stand_h - adjuster_slider_h])
        cube([bearing_stand_r * 2 + 2, adjuster_slider_w, adjuster_stand_h + 1]);

        for(y = [-adjuster_slider_w / 2, adjuster_slider_w / 2]) {
            translate([0, y + -bearing_stand_distance / 2 - adjuster_slider_y, adjuster_stand_h - adjuster_slider_h])
            cylinder(r=adjuster_slider_r, h=adjuster_slider_h + 1);
        }
    }
}

module face(
        r = 24,
        h_t = 3,
        r_t = 1,
        slot_l = 36.5,
        slot_w = 25,
        slot_r = 2,
        slot_chamfer = 0.7
    ){
    difference() {
        cylinder(h=h, r=r);

        translate([0, 0, -1])
        cylinder(h=h - h_t + 1, r=r - r_t);

        translate([0, 0, -1])
        linear_extrude(height=h + 2)
        offset(r=slot_r)
        square([slot_l - slot_r * 2, slot_w - slot_r * 2], true);

        translate([0, 0, h - slot_chamfer])
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
            translate([0, 0, h - h_t + slot_chamfer])
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
