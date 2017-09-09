$fn=200;

face_x = 22;
face_d = 48;
face_h = 5;
face_t = 1;

face_mount_r = 26;
face_mount_angle = 68;

stand_to_stand_x = 50;
stands_x = -4.45;
base_l = 45;
base_w = 44;

stick_x = 1.9;

main();

module main() {
    translate([face_x, 0, 0])
    // translate([base_l * 2, 0, face_h])
    rotate([180, 0, 0])
    face(
        d = face_d,
        h = face_h,
        t = face_t,
        mount_r = face_mount_r,
        mount_angle = face_mount_angle,
        slot_offset_x = stick_x
    );

    translate([0, -base_w / 2, 0])
    difference() {
        enclosure();

        gimbal_screws();
        mount_screws();
        bearings();
        crossbar_tension_screw();
        crossbar();
    }
}

module crossbar() {
    mount_l = 3.2;
    mount_d = 5.1;
    pin_d = 1.59;
    pin_l = 7;
    s = 15;

    translate([stands_x + stick_x + 2.81, 38.98, 6.5]) {
        rotate([0, -90, 0])
        translate([0, 0, -1])
        hull() {
            cylinder(d=pin_d, h=pin_l + 1);

            translate([pin_d / 2 + 0.3, 0, 0])
            cylinder(d=0.1, h=pin_l + 1);
        }

        hull() {
            rotate([0, 90, 0])
            cylinder(d=mount_d, h=mount_l);

            translate([0, mount_d / 2 - s, s - 2])
            cube([mount_l, s, 1]);

            translate([0, mount_d / 2 - s - 1, -mount_d / 2])
            cube([mount_l, 1, s]);
        }
    }
}

module crossbar_tension_screw() {
    l = 6;
    w = 4.9;
    h = 12;
    guide_d = 1.5;
    screw_d = 2.3;

    translate([stands_x + stick_x, 6.55, 1]) {
        translate([-l / 2, 0])
        cube([l, w, h]);

        for (y = [0, w]) {
            translate([0, y])
            cylinder(d=guide_d, h=h);
        }

        translate([0, w / 2, -h])
        cylinder(d=screw_d, h=h + 1);
    }
}

module bearings() {
    d = 8.1;
    stopper_d = 6.2;
    z = 6.5;

    translate([stands_x + stick_x - 1, base_w / 2, z])
    rotate([0, 90, 0]) {
        cylinder(d=d, h=stand_to_stand_x);

        translate([0, 0, -5])
        cylinder(d=stopper_d, h=stand_to_stand_x + 10);
    }
}

module gimbal_screws() {
    d = 1.9;
    h = 20;

    dx = stands_x + stick_x;

    face_screw_dx = face_mount_r * cos(face_mount_angle);
    face_screw_dy = face_mount_r * sin(face_mount_angle);

    positions = [
        [dx, 4],
        [dx, 15],
        [dx, 29],

        [stand_to_stand_x + dx - 7, base_w - 2],
        [stand_to_stand_x + dx - 7, 2],

        [stand_to_stand_x + dx, 30],
        [stand_to_stand_x + dx, 14],

        [face_x + face_screw_dx, base_w / 2 + face_screw_dy],
        [face_x - face_screw_dx, base_w / 2 + face_screw_dy],
        [face_x + face_screw_dx, base_w / 2 - face_screw_dy],
        [face_x - face_screw_dx, base_w / 2 - face_screw_dy],
    ];

    for (p = positions) {
        translate(p)
        translate([0, 0, -2])
        cylinder(d=d, h=h);
    }
}

module mount_screws() {
    mount_screw_d = 2.3;
    mount_screw_h = 20;

    mount_hole_h = 7.2;
    mount_hole_d = 4.5;

    for (p = [[0, 0], [0, base_w], [base_l, base_w], [base_l, 0]]) {
        translate([0, 0, -1])
        translate(p) {
            // translate([0, 0, mount_hole_h + 1.3])
            cylinder(d=mount_screw_d, h=mount_screw_h + 1);

            cylinder(d=mount_hole_d, h=mount_hole_h + 1);
        }
    }
}

module enclosure() {
    right_beam_dx = 0.5;
    top_beam_dy = 2.1;

    difference() {
        beam(w=4, h=6.5, points=[
            [0, 0],
            [stands_x + stick_x, 4],
            [stands_x + stick_x, 29],
            [0, base_w],
            [12.26, base_w + top_beam_dy],
            [31.7, base_w + top_beam_dy],
            [base_l, base_w],
            [stand_to_stand_x + stands_x + stick_x, 30],
            [stand_to_stand_x + stands_x + stick_x - 1.5, 28],
            [stand_to_stand_x + stands_x + stick_x - 1.5, 16],
            [stand_to_stand_x + stands_x + stick_x, 14],
            [base_l, 0],
            [31.7, -top_beam_dy],
            [12.26, -top_beam_dy],
            [0, 0],
        ]);

        translate([0, 0, 5])
        beam(w=4.2, h=5, points=[
            [stand_to_stand_x + stands_x + stick_x, 30],
            [stand_to_stand_x + stands_x + stick_x, 14],
        ]);
    }

    difference() {
        beam(w=4, h=8.5, points=[
            [0, 0],
            [stands_x + stick_x, 4],
            [stands_x + stick_x, 13.4],
        ]);

        translate([stands_x + stick_x - 2, 13.3, 6.5])
        cube(size=[6, 6, 3]);
    }

    difference() {
        hull() {
            translate([0, base_w])
            cylinder(d=6.5, h=8.5);

            translate([stands_x + stick_x - 0.5, base_w - 7.8])
            cube(size=[2, 5, 8.5]);

            translate([stands_x + stick_x + 5.9, base_w - 5.8])
            cube(size=[2, 5, 8.5]);
        }
    }

    cylinder(h=8.5, d=6.5);

    hull() {
        translate([base_l, base_w])
        cylinder(d=6.5, h=8.5);

        translate([43 + stands_x + stick_x, base_w - 2])
        cylinder(d=5, h=8.5);
    }

    translate([43 + stands_x + stick_x, base_w - 2])
    cylinder(d=5, h=16.5);

    hull() {
        translate([base_l, 0])
        cylinder(d=6.5, h=8.5);

        translate([43 + stands_x + stick_x, 2])
        cylinder(d=5, h=8.5);
    }

    translate([43 + stands_x + stick_x, 2])
    cylinder(d=5, h=12.5);
}

module beam(w, h, points) {
    for (i = [0:len(points) - 2]) {
        hull()
        for (p = [points[i], points[i + 1]]) {
            translate(p)
            cylinder(d=w, h=h);
        }
    }
}

module face(
    plate_t = 1.5,

    slot_l = 37,
    slot_w = 25,
    slot_r = 2,

    slot_bevel = 1,
    slot_clearance = 3.5
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
        t = 2,

        screw_d = 2.2,

        screw_head_d = 3.8,
        screw_head_h = 1,

        screw_distance = 2
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
