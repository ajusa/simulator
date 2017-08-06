import std.stdio, std.array, std.algorithm, std.conv, std.math;
/*Math Conversion

sigmaZ = width;		the width along the z axis
sigmaVz = height;	the height along the Vz axis
zetaZ = VzIntDist;	the distance between the two Vz intercepts				//I think since it is between z (distance) and Vz(relative difference in velocity)
tau = zIntDist;		the distance between the two z intercepts				//Its important to write z and Vz, instead of x and y
a = chirp;			the chirp. chirp = slope
z = dist;			the distance from the origin-from the center of mass
Vz = vel;			the difference in velocity from center of mass
b = b;				the relationship between the chirp, zIntDist, and VzIntDist. (b=a(tau/zeta)^2)
*/


/*Important things to know

	We will need to create a phase space simulation that not only has the shape of the phase space
	but and VERY IMPORTANTLY
	has the data gathered from hitting the specimen in each point. How to do that is the mystery. Will we have to do a coordinate system?
	Or is this found in each individual phase space when it shatters

	Objectives
	Create a phase space simulator that simulates the phase space and collects data from hitting the specimen
	in order to collect the data it needs to shatter
	recombine the phase spaces at the end and collect the data

	Time Table
	Due September 19
		Things to do
	Finish free expansion
	Figure out shattering
		Recenter center of mass individually for each phase space
	Figure out data containment
	Figure out reactions between shatters phase spaces and how to account for them and how they change each other
	Figure out how to recombine

	LARGE PART NOT YET FIGURED OUT Figure out how to optimize the microscope through combinations of optics
	Write an at most 18 pages (not including references) paper about our research
		Total 1600 projects
	Score top 300 for semi finalist
	Score top 60 for regional finalist
	Score top 6 (in team category) for national finalist 
*/

class PhaseSpace{
	double width, height, VzIntDist, zIntDist, chirp, dist, vel, b;
	double[][] data;
    this(double Vz, double z){
    	data ~= [Vz];
    	data ~= [z];
	}
	void currentPhaseSpace(){
		writeln(text(data));
	}
	void goForward(double dt){ //just here temporarily
		foreach (ref items; data) { // overwrite value
    		foreach (ref item; items)  item *= dt;
		}
	}
	void freeExpansion(){//To deal with processing we might need to make our own math functions. (less/more digits of accuracy)
		this.VzIntDist = sqrt(1/((1/pow(height,2))+pow((b/zIntDist),2)));
		this.chirp = b*pow(VzIntDist,2)/pow(zIntDist,2);
		this.VzIntDist = sqrt(1/((1/pow(zIntDist,2))-pow(chirp/VzIntDist,2)));
	}
	void opticalMantipulation(double changeChirp, double changeB){
		this.chirp += changeChirp;
		this.b += changeB;
	}
	/*void drawPhaseSpace(double v){ THIS ISNT FINISHED YET
		auto window = new SimpleWindow(800, 800);
		{ // introduce sub-scope
			auto painter = window.draw(); // begin drawing
			//draw here
			painter.outlineColor = Color.red;
			painter.fillColor = Color.red;
			auto x = -sigmaZ;
			while(x < sigmaZ)
			{
				double h = exp((pow(a*x,2)/(-2*pow(x,2)))-pow(v-a,2)/(2*(pow(a*x,2))))/(2*PI*pow(x*a*x,2));
				painter.outlineColor = Color.red;
				painter.drawLine(Point(to!int(x*400), to!int(((0.5 * h)+a*x)*400)), Point(to!int(x*400), to!int((a*x-(0.5 * h))*400)));
				x += .0001; //accuracy
			}
		} // end scope, calling `painter`'s destructor, drawing to the screen.
		window.eventLoop(0); // handle events
	}*/
	double getArea(double accuracy){
		auto x = -VzIntDist; 
		double area = 0;
		while(x < VzIntDist)
		{
			area += exp((pow(chirp*x,2)/(-2*pow(x,2)))-pow(vel-chirp,2)/(2*(pow(chirp*x,2))))/(2*PI*pow(x*chirp*x,2));
			x += accuracy; //accuracy
		}
		return area;
	}
/*Conservation Checking
	consAValue needs to be integrated! 
	This process only needs to be run as a sort of debug tool for the programmer- the program might not necessarily need it
	-Should we have auto checkAreaConservation? 
	-(More processing would be needed but as different variables are inputed the user can be warned if the program doesn't work and then it can be fixed)
	Fa(z,vZ) = exp((pow(zeta,2)/(-2*pow(sigma,2)))-pow(v-a,2)/(2*(pow(zeta,2))))/(2*PI*pow(sigma*zeta,2));	Integration
	Fa(dist, vel) = exp((pow(VzIntDist,2)/(-2*pow(width,2)))-pow(vel-chirp,2)/(2*pow(VzIntDist,2))))/(2*PI*pow(width*VzIntDist,2));
*/
	bool checkAreaConservation(double ){
		
		if(consAValue > 0.99 && consAValue < 1.01){//randomly decided range to account for integration error 
			writeln("Area is conserved");
			return true;
		}
		else{
			writeln("Area is not conserved");
			writeln("Area:", consAValue);
			return false;
		}
	bool checkVolumeConservation(){//Two checkAreaConservations but with different variables for form A and form B
		/*if(checkAreaConservation() &&checkAreaConservation()){
			writeln("Volume is conserved");*/
			return true;
		}
	}
}

void main(){
	auto space = new PhaseSpace(2.001, 5.009); //Random numbers
	space.currentPhaseSpace();
    //space.goForward(4);
    space.currentPhaseSpace();
	space.checkAreaConservation(1,1);
	writeln("End of Program, enter anything to continue");
	string input = stdin.readln();
}