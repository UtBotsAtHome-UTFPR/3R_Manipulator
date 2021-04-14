#include "ros/ros.h"
#include "custom_msg/set_angles.h"
using namespace std;
#include <math.h>
#define PI 3.14159265

int main(int argc, char **argv)
{	
	ros::init(argc, argv, "IK");

	ros::NodeHandle n;
	ros::Publisher pub = n.advertise<custom_msg::set_angles>("/cmd_3R", 1000);
	ros::Rate looprate(10);
	custom_msg::set_angles msg;

	double x;
	double y;

	double t1,t2,t3;
	double a1 = 0.25;
	double a2 = 0.25;
	double a3 = 0.13;
	double gamma = 0;

	double x3,y3,d,f,c2,s2, beta, den, psi,a,b;

	//while(ros::ok()){
	//while(mode != 5){

		/*cout << "Insira as coordenadas:\n";
		cout << "X:";
		cin >> x;
		cout << "\nY:";
		cin >> y;*/

		x = 0.15;
		y = 0.3;
		
		//system("clear");
		cout << "\n\nCalculando cinemática inversa...\n";

		x3 = x-a3*cos(gamma);
		y3 = y-a3*sin(gamma);

		c2 = (pow(x3,2) + pow(y3,2)-pow(a1,2) - pow(a2,2))/ (2*a1*a2);
		t2 = acos(c2);
		a = atan2(y3,x3);
		b = acos((pow(x3,2) + pow(y3,2) + pow(a1,2) - pow(a2,2) ) / (2*a1*sqrt(pow(x3,2)+pow(y3,2))));
		t1 = a-b;
		t3 = (t2 + t1 - gamma)*-1;

		msg.set_OMB = t1*180/PI;
		msg.set_COT = t2*180/PI;
		msg.set_PUN = t3*180/PI;

		cout << "Coordenada de destino: [" << x << ", " << y <<"]\n\n";
		cout << "theta(1) - Ombro: " << msg.set_OMB << "\n";
		cout << "theta(2) - Cotovelo: " << msg.set_COT << "\n";
		cout << "theta(3) - Punho: " << msg.set_PUN << "\n";

		pub.publish(msg);
		ros::spinOnce();
		looprate.sleep();
	//}
	return 0;
}