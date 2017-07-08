$fn=100;

main(
    face_x = 22,
    face_d = 48,
    face_h = 5,
    face_t = 1,

    face_mount_r = 26,
    face_mount_angle = 68,

    base_h = 1.5,
    stand_to_stand_x = 50,
    stands_x = -4.45,
    base_l = 45,
    base_w = 44,

    stick_x = 1.9
);

module main() {
    // translate([face_x, 0, 0])
    translate([base_l * 2, 0, face_h])
    rotate([180, 0, 0])
    face(
        d = face_d,
        h = face_h,
        t = face_t,
        mount_r = face_mount_r,
        mount_angle = face_mount_angle,
        slot_offset_x = stick_x
    );

    base(
        l = base_l,
        w = base_w,
        h = base_h,
        stands_offset = stick_x,
        face_x = face_x,
        face_mount_r = face_mount_r,
        face_mount_angle = face_mount_angle,
        screw_positions = [
            [-4.5, 4],
            [-4.5, 15],
            [-4.5, 29],
            [38.5, 2],
            [38.5, 42],
            [45.5, 14],
            [45.5, 30],
        ]
    );

    translate([stands_x + stick_x, 0, 0]) {
        crossbar_stand();

        translate([stand_to_stand_x, 0, 0])
        rotate([0, 0, 180])
        sensor_stand();

        translate([45, 20])
        ratchet_stand();

        translate([45, -20])
        ratchet_stand(h=14);
    }
}

module base(
    mount_screw_d = 2.2,
    face_mount_screw_d = 1.9,
    face_mount_stand_d = 5.2,

    t = 1,

    mount_hole_h = 7.2,
    mount_hole_r = 2.25,

    arm_w = 5,

    crossbar_support_l = 3.45,
    crossbar_support_w = 5.77,

    tensioner_link_w = 3,

    ratchet_support_l = 6.4,
    ratchet_support_w = 4.5,

    sensor_stand_link_w = 13,

    left_arm_x = -3.94,
    left_arm_y = 4,
    left_arm_w = 25,

    right_arm_x = 0.5,
    right_arm_y = 14,
    right_arm_w = 16,

    central_pcb_cutoff_w = 0.5,
    central_pcb_cutoff_x = -5,

    screw_d = 1.9
){
    stand_positions = [[0, 0], [l, 0], [0, w], [l, w]];
    ridge_h = 6.5;

    translate([0, -w / 2, 0])
    difference() {
        union() {
            for(p = stand_positions) {
                translate(p)
                cylinder(h=mount_hole_h + t, r=mount_hole_r + t);
            }

            flex_bar(
                l = arm_w,
                w = w,
                h = h,

                x = left_arm_x + stands_offset,
                y1 = left_arm_y,
                y2 = left_arm_y + left_arm_w
            );

            translate([l, 0, 0])
            flex_bar(
                l = arm_w,
                w = w,
                h = h,

                x = right_arm_x + stands_offset,
                y1 = right_arm_y,
                y2 = right_arm_y + right_arm_w
            );

            for(y = [-mount_hole_r - t, w - arm_w + mount_hole_r + t]) {
                translate([0, y, 0])
                cube(size=[l, arm_w, h]);
            }

            for(y = [0, l - h / 2]) {
                translate([0, y - h / 2, 0])
                cube(size=[l, h, ridge_h]);
            }

            M = [
              [ abs((-4 + stands_offset) / tensioner_link_w * 1.2), (-4 + stands_offset) / tensioner_link_w, 0, 0 ],
              [ 0, 1, 0, 0 ],
              [ 0, 0, 1, 0 ],
              [ 0, 0, 0, 1 ],
            ];
            multmatrix(M)
            translate([-h / 2, 0, 0])
            cube(size=[h, tensioner_link_w, ridge_h]);

            translate([0, w - crossbar_support_w, 0])
            cube(size=[crossbar_support_l + stands_offset, crossbar_support_w, h]);

            for(y = [0, w - ratchet_support_w]) {
                translate([l - ratchet_support_l + stands_offset, y, 0])
                cube(size=[ratchet_support_l, ratchet_support_w, h]);
            }

            for(pos = [[0, 1], [w, -1]]) {
                M = [
                  [ 1, (pos[1] * (0.5 + stands_offset) / sensor_stand_link_w), 0, 0 ],
                  [ 0, 1, 0, 0 ],
                  [ 0, 0, 1, 0 ],
                  [ 0, 0, 0, 1 ],
                ];

                translate([l, pos[0], 0])
                rotate([0, 0, 90 - 90 * pos[1]])
                translate([-h / 2, 0, 0])
                multmatrix(M)
                cube(size=[h, sensor_stand_link_w, ridge_h]);
            }

            translate([face_x, w / 2, 0])
            for(a = [face_mount_angle, 180 - face_mount_angle, 180 + face_mount_angle, 360 - face_mount_angle]) {
                rotate([0, 0, a])
                translate([face_mount_r, 0, 0])
                cylinder(d=face_mount_stand_d, h=ridge_h);
            }
        }

        translate([face_x, w / 2, 0])
        for(a = [face_mount_angle, 180 - face_mount_angle, 180 + face_mount_angle, 360 - face_mount_angle]) {
            rotate([0, 0, a])
            translate([face_mount_r, 0, -1])
            cylinder(d=face_mount_screw_d, h=ridge_h + 2);
        }

        translate([-mount_hole_r - t, w - mount_hole_r - t - 2.3, h])
        cube(size=[mount_hole_r * 2 + t * 2, mount_hole_r + t, mount_hole_h + t]);

        for(p = stand_positions) {
            translate(p)
            translate([0, 0, -1])
            union() {
                cylinder(r=mount_hole_r, h=mount_hole_h + 1);
                cylinder(h=mount_hole_h + t + 2, d=mount_screw_d);
            }
        }

        for(p = screw_positions) {
            translate(p)
            translate([stands_offset, 0, -1])
            cylinder(h=ridge_h + 2);
        }

        for(sy = [[1, 0 - mount_hole_r - t], [-1, w + mount_hole_r + t - central_pcb_cutoff_w]]) {
            M = [
              [ 1, sy[0] * 0.8, 0, 0 ],
              [ 0, 1, 0, 0 ],
              [ 0, 0, 1, 0 ],
              [ 0, 0, 0, 1 ],
            ];

            translate([l + central_pcb_cutoff_x - central_pcb_cutoff_w, sy[1], -1])
            multmatrix(M)
            cube([10, central_pcb_cutoff_w, mount_hole_h + t + 2]);
        }
    }
}

module flex_bar(
        l = 10,
        w = 50,
        h = 1.5,

        x  = 10,
        y1 = 20,
        y2 = 40
    ) {
    r = l / 2;

    hull() {
        cylinder(r=r, h=h);

        translate([x, y1, 0])
        cylinder(r=r, h=h);
    }

    translate([x - r, y1, 0])
    cube([l, y2 - y1, h]);

    hull() {
        translate([0, w, 0])
        cylinder(r=r, h=h);

        translate([x, y2, 0])
        cylinder(r=r, h=h);
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
            translate([x, 0, -1])
            cylinder(r=screw_r, h=h + 2);
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
        bearing_stopper_l = 1,
        bearing_stopper_h = 0.9,

        sensor_stand_l = 6,
        sensor_stand_r = 2,
        sensor_stand_h = 7.8,
        sensor_stand_z = 4,
        sensor_stand_distance = 15,
        sensor_stand_bridge = 4
    ){
    stand_y_positions = [-bearing_stand_distance / 2, bearing_stand_distance / 2];
    sensor_stand_y_positions = [-sensor_stand_distance / 2, sensor_stand_distance / 2];

    difference() {
        union() {
            for(y = stand_y_positions) {
                translate([0, y, 0])
                cylinder(h=bearing_stand_h, r=bearing_stand_r);
            }

            for(y = sensor_stand_y_positions) {
                translate([-sensor_stand_l, y, sensor_stand_z])
                cylinder(h=sensor_stand_h - sensor_stand_z, r=sensor_stand_r);
            }

            for(i = [0, 1]) {
                hull() {
                    translate([0, stand_y_positions[i], sensor_stand_z])
                    cylinder(h=bearing_stand_h - sensor_stand_z, r=sensor_stand_r);

                    translate([-sensor_stand_l, sensor_stand_y_positions[i], sensor_stand_z])
                    cylinder(h=bearing_stand_h - sensor_stand_z, r=sensor_stand_r);
                }
            }

            translate([-sensor_stand_l - sensor_stand_r, -sensor_stand_distance / 2, sensor_stand_z])
            cube([sensor_stand_r, sensor_stand_distance, sensor_stand_h - sensor_stand_z]);

            translate([bearing_stand_r - bearing_bed_l - bearing_stopper_l, -bearing_stand_distance / 2, 0])
            cube(size=[bearing_bed_l + bearing_stopper_l, bearing_stand_distance, bearing_stand_h]);

            translate([bearing_stand_r - bearing_bed_l, -bearing_r - 1, 0])
            cube(size=[bearing_l, bearing_r * 2 + 2, bearing_stand_h]);
        }

        translate([bearing_stand_r - bearing_bed_l, 0, bearing_z])
        rotate([0, 90, 0])
        cylinder(h=bearing_l + 1, r=bearing_r);

        translate([-1, 0, bearing_z])
        rotate([0, 90, 0])
        cylinder(h=bearing_l * 2, r=bearing_r - bearing_stopper_h);

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

module crossbar_stand(
        l = 4,

        screw_d = 1.9,

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
        crossbar_l = 3.1,

        crossbar_pin_z = 8,
        crossbar_pin_y = 16.95,
        crossbar_pin_r = 0.72,

        crossbar_stand_h = 11,
        crossbar_stand_w = 5.55,
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
            translate([0, y, -1])
            cylinder(d=screw_d, h=adjuster_stand_h + 2);
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
    plate_t = 3,

    slot_l = 36.5,
    slot_w = 25,
    slot_r = 2,

    slot_bevel = 1,
    slot_clearance = 3
){
    difference() {
        union() {
            cylinder(h=h, d=d);

            slot(h=h, extra=slot_clearance + t);

            for(a = [mount_angle, 180 - mount_angle, 180 + mount_angle, 360 - mount_angle]) {
                rotate([0, 0, a])
                translate([mount_r, 0, 0])
                mount();
            }

            // color("red")
            // for(a = [45 : 90 : 360]) {
            //     rotate([0, 0, a])
            //     translate([r, -0.5, 0])
            //     cube([3, 1, 3]);
            // }
        }

        translate([0, 0, -1]) {
            cylinder(h=h - plate_t + 1, d=d - t * 2);
            slot(h=h + 2);
            slot(h=h - plate_t + 1, extra=slot_clearance);
        }

        translate([0, 0, h - plate_t])
        hull() {
            translate([0, 0, -slot_bevel])
            slot(h=1, extra=slot_bevel);

            slot(h=slot_bevel);
        }
    }

    module slot(
        extra = 0,
        h = 1
    ){
        translate([slot_offset_x, 0, 0])
        linear_extrude(height=h)
        offset(r=slot_r + extra)
        square([slot_l - slot_r * 2, slot_w - slot_r * 2], true);
    }

    module mount(
        t = 1.5,

        screw_d = 2.2,

        screw_head_d = 3.8,
        screw_head_h = 1,

        screw_distance = 1
    ){
        l = screw_head_d * 2;
        d = screw_d + t * 2;

        translate([-l, 0, 0])
        difference() {
            union() {
                translate([l, 0, 0])
                cylinder(d=d, h=h);

                translate([0, -d / 2, 0])
                cube([l, d, h]);
            }

            translate([l, 0, -1])
            cylinder(d=screw_d, h=h + 2);

            translate([l, 0, screw_distance])
            cylinder(d1=screw_d, d2=screw_head_d, h=screw_head_h);

            translate([l, 0, screw_distance + screw_head_h])
            cylinder(d=screw_head_d, h=h);

            translate([-d, -d - 1, -1])
            cube(size=[d, d * 2 + 2, h + 2]);
        }
    }
}
