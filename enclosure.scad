$fn=100;

main(
    face_x = -2,
    face_r = 24,
    face_h = 5,
    face_t = 1.5,

    base_h = 1.5,
    stand_to_stand_x = 50,
    stands_x = -4.7,
    base_l = 45,
    base_w = 44

);

module main() {
    // crossbar_stand();

    difference() {
        union() {
            base(
                l = base_l,
                w = base_w,
                h = base_h
            );

            // translate([face_x, 0, 0])
            // face(
            //     h = face_h,
            //     r = face_r,
            //     base_h = base_h,
            //     r_t = face_t
            // );

            translate([stands_x, 0, 0]) {
                crossbar_stand();

                translate([stand_to_stand_x, 0, 0])
                rotate([0, 0, 180])
                sensor_stand(
                    base_h = 1.5
                );

                translate([45, 20])
                ratchet_stand();

                translate([45, -20])
                ratchet_stand(h=14);
            }
        }

        // translate([face_r + face_x, 0, -1])
        // cylinder(r=face_r - face_t, h=50);
    }
}

module base(
        screw_r = 1,

        stand_t = 1,

        outer_t = 1,
        inner_t = 2,

        mount_hole_h = 7,
        mount_hole_r = 2.1,

        arm_w = 5,

        corner_r = 1.5,

        tensioner_link_w = 4.4,
        tensioner_link_a = 53,

        ratchet_support_l = 5.7,
        ratchet_support_w = 4,

        sensor_stand_link_w = 13,
        sensor_stand_link_a = 1
    ){
    stand_positions = [[0, 0], [l, 0], [0, w], [l, w]];
    ridge_h = mount_hole_h * 0.7 + h;

    translate([0, -w / 2, 0])
    difference() {
        union() {
            for(p = stand_positions) {
                translate(p)
                cylinder(h=mount_hole_h + stand_t, r=mount_hole_r + stand_t);
            }

            translate([-mount_hole_r - stand_t, w - mount_hole_r - stand_t, 0])
            cube(size=[mount_hole_r * 2 + stand_t * 2, mount_hole_r + stand_t, mount_hole_h + stand_t]);

            for(x = [-mount_hole_r - stand_t, l - arm_w + mount_hole_r + stand_t]) {
                translate([x, 0, 0])
                cube(size=[arm_w, w, h]);
            }

            for(y = [-mount_hole_r - stand_t, w - arm_w + mount_hole_r + stand_t]) {
                translate([0, y, 0])
                cube(size=[l, arm_w, h]);
            }

            for(y = [0, l - h / 2]) {
                translate([0, y - h / 2, 0])
                cube(size=[l, h, ridge_h]);
            }

            rotate([0, 0, tensioner_link_a])
            translate([-h / 2, 0, 0])
            cube(size=[h, tensioner_link_w, ridge_h]);

            for(y = [0, w - ratchet_support_w])
            translate([l - ratchet_support_l, y, 0])
            cube(size=[ratchet_support_l, ratchet_support_w, h]);

            for(pos = [[0, -sensor_stand_link_a], [w, 180 + sensor_stand_link_a]]) {
                translate([l, pos[0], 0])
                rotate([0, 0, pos[1]])
                translate([-h / 2, 0, 0])
                cube(size=[h, sensor_stand_link_w, ridge_h]);
            }
        }

        translate([-mount_hole_r - stand_t, w - mount_hole_r - stand_t - 2.2, h])
        cube(size=[mount_hole_r * 2 + stand_t * 2, mount_hole_r + stand_t, mount_hole_h + stand_t]);

        left_cut_y = 10;
        left_cut_r = 4;

        translate([3, left_cut_y, -1])
        hull() {
            cylinder(r=left_cut_r, h=h+2);
            translate([0, w - left_cut_y * 2, 0])
            cylinder(r=left_cut_r, h=h+2);
        }

        for(p = stand_positions) {
            translate(p)
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

        h = 18,
        r = 2.5,
        l = 4
    ){
    stand_x_positions = [-l / 2];

    difference() {
        hull() {
            for(x = stand_x_positions) {
                translate([x, 0, 0])
                cylinder(h=h, r=r);
            }
        }

        for(x = stand_x_positions) {
            translate([x, 0, 1])
            cylinder(r=screw_r, h=h);
        }
    }
}

module sensor_stand(
        screw_r = 0.95,

        bearing_r = 4,
        bearing_l = 2.5,
        bearing_z = 8,

        bearing_stand_h = 6.5,
        bearing_stand_r = 2,
        bearing_stand_distance = 16,

        bearing_bed_l = 1,
        bearing_stopper_l = 0.406,
        bearing_stopper_w = 0.7,

        sensor_stand_l = 6,
        sensor_stand_r = 2,
        sensor_stand_h = 7.8,
        sensor_stand_z = 3.5,
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

module crossbar_stand(
        l = 4,

        screw_r = 0.95,

        bearing_x = -1,
        bearing_z = 8,
        bearing_r = 4,

        bearing_stand_h = 8,
        bearing_stand_r = 2,
        bearing_stand_w = 10,
        bearing_stand_distance = 14,
        bearing_stand_l = 2,

        bearing_stopper_h = 0.9,

        adjuster_stand_w = 11,
        adjuster_stand_h = 10,
        adjuster_stand_notch = 1.6,

        adjuster_slider_w = 4.9,
        adjuster_slider_y = 6,
        adjuster_slider_h = 8.5,
        adjuster_slider_r = 0.75,

        crossbar_x = 2.8,
        crossbar_l = 3.04,

        crossbar_pin_z = 8,
        crossbar_pin_y = 16.85,
        crossbar_pin_r = 0.72,

        crossbar_stand_h = 11,
        crossbar_stand_w = 6,
        crossbar_stand_t = 2,
        crossbar_stand_link_a = -6.6613,

        crossbar_stand_cutout_h = 5
    ){

    screw_y_positions = [
        -bearing_stand_distance / 2 - adjuster_stand_w,
        -bearing_stand_distance / 2,
        +bearing_stand_distance / 2
    ];

    crossbar_stand_l = crossbar_stand_t * 2 + crossbar_l;
    crossbar_stand_x = crossbar_x - crossbar_stand_t;
    crossbar_stand_y = crossbar_pin_y - crossbar_stand_w / 2;

    difference() {
        union() {
            hull() {
                translate([0, screw_y_positions[0], 0])
                cylinder(h=adjuster_stand_h, r=l / 2);

                translate([0, screw_y_positions[2], 0])
                cylinder(h=adjuster_stand_h, r=l / 2);
            }

            translate([crossbar_stand_x, crossbar_stand_y, 0])
            cube([crossbar_stand_l, crossbar_stand_w, crossbar_stand_h]);

            translate([0, bearing_stand_distance / 2, 0])
            rotate([0, 0, crossbar_stand_link_a])
            cube([crossbar_stand_t, crossbar_pin_y - bearing_stand_distance / 2, bearing_z]);
        }

        translate([crossbar_x, crossbar_stand_y - 1, -1])
        cube([crossbar_stand_t + crossbar_l + 1, crossbar_stand_w / 2 - crossbar_pin_r + 1, crossbar_stand_h + 2]);

        translate([crossbar_x, crossbar_stand_y - 1, crossbar_stand_cutout_h])
        cube([crossbar_l, crossbar_stand_w + 2, crossbar_stand_h]);

        translate([crossbar_stand_x - crossbar_stand_t, crossbar_pin_y, crossbar_pin_z])
        rotate([0, 90, 0])
        cylinder(r=crossbar_pin_r, h=crossbar_stand_l);

        for(y = screw_y_positions) {
            translate([0, y, 1])
            cylinder(r=screw_r, h=adjuster_stand_h + 2);
        }

        translate([-l / 2 - 1, -bearing_stand_distance / 2 - adjuster_stand_notch, bearing_z])
        cube([l + 2, bearing_stand_distance + adjuster_stand_notch + l / 2, bearing_z]);

        translate([bearing_x, 0, bearing_z])
        rotate([0, 90, 0])
        cylinder(h=l + 1, r=bearing_r);

        translate([-l, 0, bearing_z])
        rotate([0, 90, 0])
        cylinder(h=l, r=bearing_r - bearing_stopper_h);

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
