$fa=1;
$fs=5;
//$fs=2;    // Uncomment for final render
$fn=100;

base_height = 13;
base_chamfer = 2;
wall_thickness = 2.0004;
usb_hole_vertical_corection = -0.8;
usbc_connector_height=3.3;
usbc_connector_width=9;

usb_interconnect = 0; // 0 = keep existing TRRS interconnect hole, 1 = mini-usb interconnect
print_only_front_slice = 1;
show_usbc_connector = 1;

tent_positions = [
    // [X, Y, Angle]
    [87.7, 44.0, 0, 11],
    [85.7, -31, -10, 11],
    [-78.5, 44, 177, 11],
    [-78, -61, -150, 11],
    ];

module fail(message) {
   assert(false, message);
}

// M5 bolt tenting
boltRad = 5 / 2;
nutRad = 9.4 / 2;
nutHeight = 3.5;
module tent_support(position) {
    off = apothem(nutRad, 6)+0.5;
    lift = 0;
    height = base_height - lift;
    tent_support_depth=position[3];
    em=0.1; // error margin
    translate([position[0], position[1], lift]) rotate([0, 0, position[2]]) {
        difference() {
            chamfer_extrude(height=height, chamfer=base_chamfer, faces = [true, false]) {
                hull() {
                    translate([-tent_support_depth,0]) square([0.1, 35], center=true);
                    translate([off, 0]) circle(r=boltRad+base_chamfer+1.5);
                }
            }
            translate([-tent_support_depth-em,-20, -em]) cube([base_chamfer, 40, height+em*2], center=false);
            translate([off, 0, -0.1]) polyhole(r=boltRad, h=height+1);
            // Nut hole
            translate([off, 0, height-nutHeight]) rotate([0, 0, 60/2]) cylinder(r=nutRad, h=nutHeight+0.1, $fn=6);
        }
    }
}

mini_usb_screw_rad = 2.4 / 2; // Smaller than M3 to tap into
mini_usb_screw_sep = 20;
mini_usb_hole_height = 7.5;
module mini_usb_hole() {
    translate([0, 0, mini_usb_hole_height/2])  rotate([90, 0, 0]) roundedcube([10, mini_usb_hole_height, 10], r=1.5, center=true, $fs=1);
    for (i = [-1,1], j = [0, 14]) {
        translate([i*mini_usb_screw_sep/2, -4-j, -5]) polyhole(r=mini_usb_screw_rad, h=10);
    }
}

micro_usb_screw_dia = 3.0;
micro_usb_screw_rad = (micro_usb_screw_dia - 0.6) / 2; // Smaller than M3 to tap into
micro_usb_screw_sep = 9;
micro_usb_hole_height = 7.5;
micro_usb_socket_height = 2.5;
pcb_thickness = 2;
module micro_usb_hole() {
    translate([0, 1, micro_usb_hole_height/2]) rotate([90, 0, 0]) roundedcube([11, micro_usb_hole_height, 10], r=1.5, center=true, $fs=1);
    translate([0, -1.5, pcb_thickness + micro_usb_socket_height / 2]) rotate([90, 0, 0]) cube([7.5, micro_usb_socket_height, 10], r = 1.5, center = true, $fs = 1);
    for (i = [-1,1]) {
        translate([i * micro_usb_screw_sep/2, -8, -5]) polyhole(r = micro_usb_screw_rad, h=15);
    }
}

// Print a couple of these to prevent heads of the mini-usb mounting screws from
// hitting the mini-usb socket
module micro_usb_bracket() {
    height = micro_usb_socket_height + 0.25; // One layer above
    difference() {
        translate([0, 0, height/2])  roundedcube([micro_usb_screw_sep + 7, 7, height], center = true);
        translate([0, 8, -pcb_thickness - 0.01]) micro_usb_hole();
        for (i = [-1,1]) {
            translate([i * micro_usb_screw_sep/2, 0, 0]) polyhole(r = (micro_usb_screw_dia + 0.2) / 2, h = 15, center = true);
        }
    }
}

// Make a mold for making an oogoo foot around the M5 nut heads.
module foot_negative() {
    rotate([0, 90, 0]) {
        // Nut trap to stop the bolt from being pushed out. Two half height nuts.
        translate([0, 0, -1]) cylinder(r = nutRad + 0.75, h = 5.5, center = true, $fn=16);
        // actual bolt shaft
        polyhole(r = boltRad, h = 20, center = true);
        // show actual bolt head shape
        translate([0, 0, 10]) cylinder(r1 = 5, r2 = 2.5, h = 2.7, center = false);
        // This is the rubber around the head
        translate([0, 0, 11]) {
            scale([1, 1, 0.5])  sphere(r = 6.5);
        }
    }
}

module foot_mold() {
    height = 8;
    for (m = [0, 1])
        mirror([m, 0, 0])
            translate([5, 0, 0])
            difference() {
            translate([0, -10, 0])  cube([25, 65, height], center = false);
            for (i = [0:3]) {
          #      translate([7, i*15, height]) foot_negative();
            }
    }
}

module report_side_parameter_validation_failed() {
    fail("'side' parameter should have value either 'left' or 'right'");
}

module original_base(side) {
    // uses Improved Redox Rev.1 Case STL from https://www.thingiverse.com/thing:4835785/
    // The original file was fixed in Blender to be correct 2-mainfold model

    if (side == "left") {
        translate([-73.7,63.43,0.06])
            import("orig/BottomLeft-fixed-mainfold.stl");
    } else if (side == "right") {
        translate([-306.3,63.43,0.06])
            import("orig/BottomRight-fixed-mainfold.stl");
    } else {
        report_side_parameter_validation_failed();
    };
}

module base_outline(side) {
    projection(cut=true)
        translate([0, 0, -base_height+1])
        original_base(side);
}

module base_walls(side) {
        linear_extrude(height = base_height)
        base_outline(side);
}

module filled_base(side) {
        linear_extrude(height = base_height)
        fill()
        base_outline(side);
}

module base_interior(side) {
    difference() {
        filled_base(side);
        base_walls(side);
    }
}

module modified_base(side) {
    difference() {
        union() {
            original_base(side);

            if (usb_interconnect) {
                // Fill in TRRS hole, since we'll do something different
                translate([-42, 61.426, base_chamfer]) cube([20, wall_thickness, base_height - base_chamfer - 0.1]);
            }

            for(i = [0:len(tent_positions)-1]) {
                difference() {
                    if (side == "left") {
                        mirror([1, 0, 0])
                            tent_support(tent_positions[i]);
                    } else if (side == "right") {
                        tent_support(tent_positions[i]);
                    } else {
                        report_side_parameter_validation_failed();
                    };

                    base_interior(side);
                }
            }
        }
        if (usb_interconnect) {
            translate([-28, 61.426, wall_thickness]) mini_usb_hole();
            //translate([65.5, 61.426, wall_thickness]) micro_usb_hole();
        }
    }
}

module usb_hole(side) {
    if (side == "left") {
        translate([-5.36, 60.53, 6.83])
            cube([8.04, 1.4, 2.782]);
    } else if (side == "right") {
        translate([-2.1, 60.43, 2.52])
            cube([8.07, 2, 2.9]);
     } else {
        report_side_parameter_validation_failed();
    };
}

module usbc_hole(side) {
    if (side == "left") {
        translate([-1.35, 56, 8.2])
            scale([1.3, 1, 1.6])
            usbc_connector_body(usbc_connector_width, usbc_connector_height, 17);
    } else if (side == "right") {
        translate([2, 56, 4.75])
            scale([1.3, 1, 1.6])
            usbc_connector_body(usbc_connector_width, usbc_connector_height, 17);
     } else {
        report_side_parameter_validation_failed();
    };
}

module usbc_connector(side) {
    if (side == "left") {
        color("red")
        translate([-1.35, 56, 8.2])
            usbc_connector_body(usbc_connector_width, usbc_connector_height, 17);
    } else if (side == "right") {
        color("red")
        translate([2, 56, 4.75])
            usbc_connector_body(usbc_connector_width, usbc_connector_height, 17);
     } else {
        report_side_parameter_validation_failed();
    };
}

module base_with_corrected_usb(side) {
    difference() {
        // fill original usb connector hole
        union() {
            modified_base(side);
            usb_hole(side);
        }

        // cut a new usbc hole
        translate([0, 0, usb_hole_vertical_corection])
            usbc_hole(side);
    }

    // visualize pro micro connector position
    if (show_usbc_connector) {
        translate([0, 0, usb_hole_vertical_corection])
            usbc_connector(side);
    }
}

module rectangle_with_rounded_corners(width, height, corner_radius) {
    hull() {
		translate( [-width/2+corner_radius, -height/2+corner_radius, 0] ) circle( corner_radius );
		translate( [-width/2+corner_radius, height/2 - corner_radius, 0 ] ) circle( corner_radius );
		translate( [width/2 - corner_radius, -height/2+corner_radius, 0] ) circle( corner_radius );
		translate( [width/2 - corner_radius, height/2 - corner_radius, 0] ) circle( corner_radius );
	}
}

module usbc_connector_body(width, height, length) {
    corner_radius = 1;

    rotate([90, 0, 0])
    translate([0, 0, -length/2])
    linear_extrude(height = length)
        rectangle_with_rounded_corners(width, height, corner_radius);
}

translate([-100, 0, 0]) {
    intersection() {
        base_with_corrected_usb("left"); // set to "left" or "right"
        if (print_only_front_slice) {
            color("green")
                translate([-100, 53, -5])
                cube([200, wall_thickness*10, base_height*1.5]);
        }
    }
}

translate([100, 0, 0]) {
    intersection() {
        base_with_corrected_usb("right"); // set to "left" or "right"
        if (print_only_front_slice) {
            color("green")
                translate([-100, 53, -5])
                cube([200, wall_thickness*10, base_height*1.5]);
        }
    }
}

/*
// positioning cubes
translate([0, -19.5, 0])
    cube([4.2, 2, 2], center=true);

translate([0, 64.5, 0])
    cube([60, 2, 2], center=true);
*/

//micro_usb_bracket();

//foot_mold();

// Requires my utility functions in your OpenSCAD lib or as local submodule
// https://github.com/Lenbok/scad-lenbok-utils.git
use<../Lenbok_Utils/utils.scad>
