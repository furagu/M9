$fn=100;

main(
    face_x = -2,
    face_r = 24,
    face_h = 5,
    face_t = 1.5,

    base_h = 1.5,
    stand_to_stand_x = 50,
    ratchet_positions = [[45, -20], [45, 20]],
    stands_x = -2.5,
    base_l = 45,
    base_w = 44

);

module main() {
    difference() {
        union() {
            base(
                l = base_l,
                w = base_w,
                h = base_h
            );

            translate([face_x, 0, 0])
            face(
                h = face_h,
                r = face_r,
                base_h = base_h,
                r_t = face_t
            );

            translate([stands_x, 0, 0]) {
                tensioner_stand();

                translate([stand_to_stand_x, 0, 0])
                rotate([0, 0, 180])
                sensor_stand(
                    base_h = 1.5
                );

                for(pos = ratchet_positions) {
                    translate(pos)
                    ratchet_stand();
                }
            }
        }

        translate([face_r + face_x, 0, -1])
        cylinder(r=face_r - face_t, h=50);
    }
}

module base(
        screw_r = 1,

        outer_t = 1,
        inner_t = 2,

        mount_hole_h = 3.5,
        mount_hole_r = 2,

        corner_r = 1.5,
    ){
    mount_positions = [[[0, 0], 180], [[l, 0], -90], [[0, w], 90], [[l, w], 0]];

    translate([0, -w / 2, 0])
    difference() {
        union() {
            for(pos_angle = mount_positions) {
                translate(pos_angle[0])
                rotate([0, 0, pos_angle[1]])
                difference() {
                    union() {
                        difference() {
                            cylinder(h=mount_hole_h + inner_t, r=mount_hole_r + inner_t);

                            translate([0, 0, -1])
                            cube(size=[mount_hole_r + outer_t + 1, mount_hole_r + outer_t + 1, mount_hole_h + inner_t + 2]);
                        }

                        translate([-corner_r, -corner_r, 0])
                        linear_extrude(height=mount_hole_h + inner_t)
                        offset(r=corner_r)
                        square(size=[mount_hole_r + outer_t, mount_hole_r + outer_t]);
                    }

                    translate([mount_hole_r + outer_t, -mount_hole_r - inner_t, -1])
                    cube(size=[mount_hole_r + outer_t, mount_hole_r * 2 + inner_t * 2, mount_hole_h + inner_t + 2]);

                    translate([-mount_hole_r - inner_t, mount_hole_r + outer_t, -1])
                    cube(size=[mount_hole_r * 2 + inner_t * 2, mount_hole_r + outer_t, mount_hole_h + inner_t + 2]);
                }

            }

            translate([- outer_t, -outer_t, 0])
            linear_extrude(height=h)
            offset(r=mount_hole_r)
            square(size=[l + outer_t * 2, w + outer_t * 2]);
        }

        for(pos_angle = mount_positions) {
            translate(pos_angle[0])
            translate([0, 0, -1])
            union() {
                cylinder(r=mount_hole_r, h=mount_hole_h + 1);

                cylinder(r=screw_r, h=mount_hole_h + inner_t + 2);
            }
        }
    }
}

module ratchet_stand(
        screw_r = 0.95,

        stand_h = 18,
        stand_r = 2,
        stand_l = 4
    ){
    stand_x_positions = [-stand_l / 2];

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
        screw_r = 0.95,

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
        sensor_stand_z = 2,
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

                translate([-sensor_stand_l, y -sensor_stand_bridge / 2, sensor_stand_z])
                cube([sensor_stand_l, sensor_stand_bridge, bearing_stand_h - sensor_stand_z]);
            }

            for(y = sensor_stand_y_positions) {
                translate([-sensor_stand_l, y, sensor_stand_z])
                cylinder(h=sensor_stand_h - sensor_stand_z, r=sensor_stand_r);
            }

            translate([bearing_stand_r - bearing_bed_l - bearing_stopper_l, -bearing_stand_distance / 2, 0])
            cube(size=[bearing_bed_l + bearing_stopper_l, bearing_stand_distance, bearing_stand_h]);

            translate([bearing_stand_r - bearing_bed_l, -bearing_r - 1, 0])
            cube(size=[bearing_l, bearing_r * 2 + 2, bearing_stand_h]);

            translate([-sensor_stand_l - sensor_stand_bridge / 2, -sensor_stand_distance / 2, sensor_stand_z])
            cube([sensor_stand_bridge, sensor_stand_distance, sensor_stand_h / 2]);
        }

        translate([bearing_stand_r - bearing_bed_l, 0, bearing_z])
        rotate([0, 90, 0])
        cylinder(h=bearing_l + 1, r=bearing_r);

        translate([0, 0, bearing_z])
        rotate([0, 90, 0])
        cylinder(h=bearing_l * 2, r=bearing_r - bearing_stopper_w);

        for(y = stand_y_positions) {
            translate([0, y, 1.5])
            cylinder(r=screw_r, h=bearing_stand_h + 2);
        }

        for(y = sensor_stand_y_positions) {
            translate([-sensor_stand_l, y, -1])
            cylinder(r=screw_r, h=sensor_stand_h + 2);
        }
    }
}

module tensioner_stand(
        screw_r = 0.95,

        bearing_r = 4,
        bearing_l = 3,

        bearing_stand_h = 8,
        bearing_stand_r = 2,
        bearing_stand_w = 10,
        bearing_stand_distance = 14,
        bearing_stand_l = 2,

        bearing_stopper_l = 0.406,
        bearing_stopper_w = 0.7,

        adjuster_stand_w = 11,
        adjuster_stand_h = 10,
        adjuster_stand_notch = 1.5,

        adjuster_slider_w = 4.9,
        adjuster_slider_y = 6,
        adjuster_slider_h = 8.5,
        adjuster_slider_r = 0.75,

        crossbar_stand_y = 9.7,
        crossbar_stand_h = 8,
        crossbar_stand_x = 1.3,
        crossbar_stand_r = 3,
        crossbar_stand_l = 2,
        crossbar_l = 3,
        crossbar_stand_pin_r = 0.75
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

            translate([-bearing_stand_l / 2, -bearing_stand_w / 2, 0])
            cube(size=[bearing_l, bearing_stand_w, bearing_stand_h]);

            translate([-bearing_stand_r, -adjuster_stand_w - bearing_stand_distance / 2, 0])
            cube([bearing_stand_r * 2, adjuster_stand_w, adjuster_stand_h]);

            translate([0, -adjuster_stand_w - bearing_stand_distance / 2, 0])
            cylinder(r=bearing_stand_r, h=adjuster_stand_h);

            translate([crossbar_stand_x, bearing_stand_distance / 2 + crossbar_stand_y - crossbar_stand_r, 0])
            difference() {
                union() {
                    translate([0, crossbar_stand_r, crossbar_stand_h])
                    rotate([0, 90, 0])
                    cylinder(r=crossbar_stand_r, h=crossbar_stand_l * 2 + crossbar_l);

                    cube([crossbar_stand_l * 2 + crossbar_l, crossbar_stand_r * 2, crossbar_stand_h]);
                }

                translate([crossbar_stand_l, -1, crossbar_stand_h - crossbar_stand_r])
                cube([crossbar_l, crossbar_stand_r * 2 + 2, crossbar_stand_r * 2 + 1]);

                translate([-1, crossbar_stand_r, crossbar_stand_h])
                rotate([0, 90, 0])
                cylinder(r=crossbar_stand_pin_r, h=crossbar_stand_l * 1.5 + crossbar_l + 1);
            }

            translate([-bearing_stand_l / 2, bearing_stand_distance / 2, 0])
            cube(size=[bearing_stand_l, crossbar_stand_y - crossbar_stand_r, crossbar_stand_h - crossbar_stand_r ]);

            translate([-bearing_stand_l / 2, bearing_stand_distance / 2 + crossbar_stand_y - crossbar_stand_r, 0])
            rotate([0, 0, -45])
            cube(size=[bearing_stand_l, crossbar_stand_y - crossbar_stand_r, crossbar_stand_h - crossbar_stand_r ]);

        }

        for(y = concat(stand_y_positions, [-bearing_stand_distance / 2 - adjuster_stand_w])) {
            translate([0, y, 1])
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
        h_t = 3,

        slot_l = 36.5,
        slot_w = 25,
        slot_r = 2,

        slot_chamfer = 0.7
    ){
    translate([r, 0, base_h])
    rotate([180, 0, 0])
    difference() {
        cylinder(h=h + base_h, r=r);

        translate([0, 0, -1])
        cylinder(h=h + base_h - h_t + 1, r=r - r_t);

        translate([0, 0, -1])
        linear_extrude(height=h + base_h + 2)
        offset(r=slot_r)
        square([slot_l - slot_r * 2, slot_w - slot_r * 2], true);

        translate([0, 0, h + base_h - slot_chamfer])
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
            translate([0, 0, h + base_h - h_t + slot_chamfer])
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

            cylinder(h=h + base_h - h_t + 1, r=r - r_t);
        }
    }
}
