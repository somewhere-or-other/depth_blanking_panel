//general conventions:
//Dimensions:
// all dimensions are in inches
//Directions:
// x - width of rack
// y - depth (front to back)
// z - vertical height

//dimensions of panel
desired_height = 5*1.75; //in inches (1.75in per RU)
desired_depth = 4; //front-to-back, in inches
desired_thickness = 0.1; //thickness of metal, in inches
holediam=0.25; //diameter of screw hole; TODO: verify this; might need to be slightly oversized due to undersizing problem (https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/undersized_circular_objects)
cornerradius=0.2; //radius of rounded corners, in inches


//useful constants
fullwidth=19; //in front of vertical posts
insidewidth=17.2165; //inside vertical posts
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

module frontpanel(height, depth, thickness)
{
	//front panel
	difference() {
		cube([fullwidth, thickness, height]);
			union() {
				//front face, lower left
				cornerround(cornerradius);

				//front face, upper left
				translate([0,0,height])
					rotate([0,90,0])
						cornerround(cornerradius);

				//front face, lower right
				translate([fullwidth, 0, 0])
					rotate([0,270,0])
						cornerround(cornerradius);
		
				//front face, upper right
				translate([fullwidth,0,height])
					rotate([0,180,0])
						cornerround(cornerradius);
			}
	}

}

module depthpanel(height, depth, thickness)
{

	difference() {
		translate([(fullwidth-insidewidth)/2, 0, 0])
			cube([insidewidth, depth, thickness]);

		union() {
			//left-back corner
			translate([(fullwidth-insidewidth)/2, desired_depth, -cornerradius/2])
				rotate([90,0,0])
					cornerround(cornerradius);

			//right-back corner
			translate([(fullwidth-insidewidth)/2+insidewidth, desired_depth, -cornerradius/2])
				rotate([90,0,270])
					cornerround(cornerradius);
		}

	}

}


module fulldepthpanel(height, depth, thickness)
{
	difference()
	{
		cube([insidewidth, thickness, (2*depth)+height]);
		union()
		{
				//depth panel, lower left
				cornerround(cornerradius);

				//depth panel, upper left
				translate([0,0,height+2*depth])
					rotate([0,90,0])
						cornerround(cornerradius);

				//depth panel, lower right
				translate([insidewidth, 0, 0])
					rotate([0,270,0])
						cornerround(cornerradius);
		
				//depth panel, upper right
				translate([insidewidth,0,height+2*depth])
					rotate([0,180,0])
						cornerround(cornerradius);

			
		}
	}

}

module blankingpanel(height, depth, thickness)
{

	//height in inches (1.75in per RU)
	//depth (front-to-back) in inches
	//thickness (metal thickness) in inches)

	difference() {
		union() 
		{
			frontpanel(height, depth, thickness);
			translate([(fullwidth-insidewidth)/2, 0, -depth])
				fulldepthpanel(height, depth, thickness);	
		}



		//mounting holes
		
		union() {
			//bottom-left hole
			translate([(fullwidth-holewidth)/2, 5*thickness, 0.875])
				rotate([90, 0, 0])
					cylinder(h=10*thickness, r=holediam/2);

			//top-left hole
			translate([(fullwidth-holewidth)/2, 5*thickness,height-0.875])
				rotate([90, 0, 0])
					cylinder(h=10*thickness, r=holediam/2);		
		
	
			//bottom-right hole
			translate([(fullwidth-holewidth)/2 + holewidth, 5*thickness, 0.875])
				rotate([90, 0, 0])
					cylinder(h=10*thickness, r=holediam/2);

			//top-right hole
			translate([(fullwidth-holewidth)/2 + holewidth, 5*thickness, height-0.875])
				rotate([90, 0, 0])
					cylinder(h=10*thickness, r=holediam/2);
		}

	}

}


union() {
	blankingpanel(desired_height, desired_depth, desired_thickness);	
}