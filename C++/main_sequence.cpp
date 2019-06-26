#include <iostream>
#include <vector>
#include "test_class.h"
#include "using_gnuplot.h"
#include "constants.h"
#include "modeling.h"
#include "data_processing.h"
#include "main_sequence.h"
#include <fstream>;
using namespace std;

double counter = 0.0;

PhaseSpace initialPulse( base_hWidth, base_hHeight, base_VzDist, base_zDist, base_chirp, base_b, base_pulseEnergy, base_intensityMultiplier,
	base_hDepth, base_hDepthVelocity, base_VxDist, base_xDist, base_chirpT, base_bT, 0.0, 0.0, 0.0);

PhaseSpace finalPulse = initialPulse;

void mainSequence() {
	if (loadData != true) {
		PhaseSpace modifiedPulse = initialPulse;
		//vector<PhaseSpace> pulses = initialPulse.split();
		finalPulse = modifiedPulse;

		vector<vector<double>> v;
		readSpec("Data files/hexogon BN-powder-eels.sl0", v);
		
		vector<PhaseSpace> splitPulses = initialPulse.split();

		vector<vector<PhaseSpace>> allPulses;
		for (PhaseSpace p : splitPulses) {
			allPulses.push_back(p.shatter(v));
		}
		//vector<PhaseSpace> shatteredPulses = initialPulse.shatter(v);
		

		//summing(shatteredPulses, graphingMap3);
		//summing(initialPulse, graphingMap);
		//measureDeviation(graphingMap, graphingMap3);
		//psComparison(shatteredPulses[0], initialPulse);
		//grid_subtraction(graphingMap, graphingMap3, graphingMap2);
		//modeling(graphingMap3);
		//modeling(graphingMap3);
		//for (int i = 0; i < modelingXRange; i++) {
		//	for (int j = 0; j < modelingYRange; j++) {
		//		valueHolder3 += graphingMap3[i][j];
		//	}
		//}

		vector<double> pixelArray(pixels);
		pixelSum(pixelArray, allPulses);
		specModeling(pixelArray);

	}
	else if (loadData)//Redundant - else would do just as fine as else if, but else if makes the logic easier to understand
		read_from_file("modeling_data.txt");
		finalDataOutput();

	// DEBUGGING in conjuction with code inside get_split_intensity_multiplier that assigns values to the printed variables
	//cout << testMax << endl;
	//cout << testMaxXCoordinate << endl;
	//cout << testMaxYCoordinate << endl;
	//cout << valueHolder << endl;

	cout << "Code ran to end" << endl;
	pause();
}

PhaseSpace returnInitialPS() {
	return initialPulse;
}

PhaseSpace returnFinalPS() {
	return finalPulse;
}

