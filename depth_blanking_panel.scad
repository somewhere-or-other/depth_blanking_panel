//general conventions:
//Dimensions:
// heights are in Rack units (1.75 in)
// other dimensions are in inches
//Directions:
// x - width f rack
// y - depth (front to back)
// z - vertical height

//dimensions of panel
desired_height = 4; //in rack-units
desired_depth = 4; //front-to-back, in inches
desired_thickness = 0.1; //thickness of metal, in inches
holediam=0.25; //diameter of screw hole; TODO: verify this; might need to be slightly oversized due to undersizing problem (https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/undersized_circular_objects)


//useful constants
fullwidth=19; //in front of vertical posts
insidewidth=17.7165; //inside vertical posts
holewidth=18.3071; //center-to-center hole spacing

//other parameters
$fn = 36; // number of steps per circle, for approximating circle/cylinder/sphere using polygons

module cornerround(radius, height=10*desired_thickness)
{
	difference() {
	translate([-1,-radius/2,-1])
		cube(radius+1);
	translate([radius,height/2,radius])
		rotate([90,0,0])
			cylinder(h=height, r=radius);
	}
}

module blankingpanel(height, depth, thickness)
{

	//height in rack-units (1.75 in)
	//depth (front-to-back) in inches
	//thickness (metal thickness) in inches)

	difference() {
		union() 
		{
			//front panel
			cube([fullwidth, thickness, height*1.75]);
			
			//lower depth panel
			translate([(fullwidth-insidewidth)/2, 0, 0])
				cube([insidewidth, depth, thickness]);
		
			//upper depth panel
			translate([(fullwidth-insidewidth)/2, 0, 1.75*height-thickness])
				cube([insidewidth, depth, thickness]);
	
		}



		//holes
		
		union() {
			//bottom-left hole
			translate([(fullwidth-holewidth)/2, 5*thickness, 0.875])
				rotate([90, 0, 0])
					cylinder(h=10*thickness, r=holediam/2);

			//top-left hole
			translate([(fullwidth-holewidth)/2, 5*thickness, (height*1.75)-0.875])
				rotate([90, 0, 0])
					cylinder(h=10*thickness, r=holediam/2);		
		
	
			//bottom-right hole
			translate([(fullwidth-holewidth)/2 + holewidth, 5*thickness, 0.875])
				rotate([90, 0, 0])
					cylinder(h=10*thickness, r=holediam/2);

			//top-right hole
			translate([(fullwidth-holewidth)/2 + holewidth, 5*thickness, (height*1.75)-0.875])
				rotate([90, 0, 0])
					cylinder(h=10*thickness, r=holediam/2);
		}

	}

}


difference() {
	blankingpanel(desired_height, desired_depth, desired_thickness);

	union() {
		cornerround(0.25);

	}

}