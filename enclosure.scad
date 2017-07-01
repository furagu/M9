$fn=100;

main(
    face_h = 5,
    stand_spacing = 50,
    ratchet_positions = [[45, -20], [45, 20]]
);

module main() {
    translate([-3, -27, 0])
    mount();

    translate([25.7, 0, 0])
    rotate([180, 0, 0])
    face(
        h = face_h
    );

    tensioner_stand();

    translate([stand_spacing, 0, 0])
    rotate([0, 0, 180])
    sensor_stand();

    for(pos = ratchet_positions) {
        translate(pos)
        ratchet_stand();
    }
}

module mount(
    screw_r = 1,

    outer_t = 1,
    inner_t = 2,

    h = 3.5,
    r = 2
    ){

    translate([r + outer_t, r + outer_t, 0])
    rotate([0, 0, 180])
    difference() {
        cylinder(h=h + inner_t, r=r + inner_t);

        translate([0, 0, -1])
        cylinder(r=r, h=h + 1);

        translate([0, 0, -1])
        cylinder(r=screw_r, h=h + inner_t + 2);

        translate([r + outer_t, -r - inner_t, -1])
        cube(size=[r + outer_t, r * 2 + inner_t * 2, h + inner_t + 2]);

        translate([-r - inner_t, r + outer_t, -1])
        cube(size=[r * 2 + inner_t * 2, r + outer_t, h + inner_t + 2]);
    }

}

module ratchet_stand(
        screw_r = 0.75,

        stand_h = 18,
        stand_r = 2,
        stand_l = 4
    ){
    stand_x_positions = [stand_l / 2, -stand_l / 2];

    difference() {
        hull() {
            for(x = stand_x_positions) {
                translate([x, 0, 0])
                cylinder(h=stand_h, r=stand_r);
            }
        }

        for(x = stand_x_positions) {
            translate([x, 0, -1])
            cylinder(r=screw_r, h=stand_h + 2);
        }
    }
}

module sensor_stand(
        screw_r = 0.75,

        bearing_r = 4,
        bearing_l = 3,
        bearing_z = 8,

        bearing_stand_h = 6.5,
        bearing_stand_r = 2,
        bearing_stand_distance = 16,

        bearing_bed_l = 1,
        bearing_stopper_l = 0.406,
        bearing_stopper_w = 0.7,

        sensor_stand_l = 6,
        sensor_stand_r = 2,
        sensor_stand_h = 8,
        sensor_stand_distance = 15,
        sensor_stand_bridge = 2
    ){
    stand_y_positions = [-bearing_stand_distance / 2, bearing_stand_distance / 2];
    sensor_stand_y_positions = [-sensor_stand_distance / 2, sensor_stand_distance / 2];

    difference() {
        union() {
            for(y = stand_y_positions) {
                translate([0, y, 0])
                cylinder(h=bearing_stand_h, r=bearing_stand_r);

                translate([-sensor_stand_l, y -sensor_stand_bridge / 2, 0])
                cube([sensor_stand_l, sensor_stand_bridge, bearing_stand_h]);
            }

            for(y = sensor_stand_y_positions) {
                translate([-sensor_stand_l, y, 0])
                cylinder(h=sensor_stand_h, r=sensor_stand_r);
            }

            translate([bearing_stand_r - bearing_bed_l - bearing_stopper_l, -bearing_stand_distance / 2, 0])
            cube(size=[bearing_bed_l + bearing_stopper_l, bearing_stand_distance, bearing_z]);

            translate([bearing_stand_r - bearing_bed_l, -bearing_r, 0])
            cube(size=[bearing_l, bearing_r * 2, bearing_z - bearing_r / 2]);

            translate([-sensor_stand_l - sensor_stand_bridge / 2, -sensor_stand_distance / 2, 0])
            cube([sensor_stand_bridge, sensor_stand_distance, sensor_stand_h / 2]);
        }

        for (s = [1, -1]) {
            translate([0, s * bearing_stand_distance / 2 - bearing_stand_r, bearing_stand_h])
            cube(size=[bearing_stand_r * 2, bearing_stand_r * 2, bearing_z]);
        }

        translate([0, bearing_stand_distance / 2 - bearing_stand_r, bearing_stand_h])
        rotate([45, 0, 0])
        cube(size=[bearing_stand_r * 2, bearing_stand_r * 2, bearing_z]);

        translate([0, -bearing_stand_distance / 2 + bearing_stand_r, bearing_stand_h])
        rotate([-45, 0, 0])
        translate([0, -bearing_stand_r * 2, 0])
        cube(size=[bearing_stand_r * 2, bearing_stand_r * 2, bearing_z]);

        translate([bearing_stand_r - bearing_bed_l, 0, bearing_z])
        rotate([0, 90, 0])
        cylinder(h=bearing_l + 1, r=bearing_r);

        translate([0, 0, bearing_z])
        rotate([0, 90, 0])
        cylinder(h=bearing_l * 2, r=bearing_r - bearing_stopper_w);

        for(y = stand_y_positions) {
            translate([0, y, -1])
            cylinder(r=screw_r, h=bearing_stand_h + 2);
        }

        for(y = sensor_stand_y_positions) {
            translate([-sensor_stand_l, y, -1])
            cylinder(r=screw_r, h=sensor_stand_h + 2);
        }
    }
}

module tensioner_stand(
        screw_r = 0.75,

        bearing_r = 4,
        bearing_l = 3,

        bearing_stand_h = 8,
        bearing_stand_r = 2,
        bearing_stand_distance = 14,
        bearing_stand_l = 2,

        bearing_stopper_l = 0.406,
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
