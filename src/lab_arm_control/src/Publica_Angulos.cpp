#include "ros/ros.h"
#include "custom_msg/set_angles.h"
using namespace std;

int main(int argc, char **argv)
{	
	ros::init(argc, argv, "Publica_Angulos");

	ros::NodeHandle n;
	ros::Publisher pub = n.advertise<custom_msg::set_angles>("/cmd_3R", 1000);
	ros::Rate looprate(10);
	custom_msg::set_angles msg;

	int mode;

	//while(ros::ok()){
	while(mode != 5){

		cout << "Digite o modo de operação:\n";
		cout << "1: Somente Ombro.\n";
		cout << "2: Somente Cotovelo.\n";
		cout << "3: Somente Punho.\n";
		cout << "4: Todos.\n";
		cout << "5: Sair.\n";
		cin >> mode;

		system("clear");

		switch(mode){
			case 1:
					cout << "Ângulo do Ombro:\n";
					cin >> msg.set_OMB;
					if(msg.set_OMB == 0){
						msg.emergency_stop = true;
						pub.publish(msg);
						ros::spinOnce();}
					else{
						msg.emergency_stop = false;}
					break;
			case 2:
					cout << "Ângulo do Cotovelo:\n";
					cin >> msg.set_COT;
					if(msg.set_COT == 0){
						msg.emergency_stop = true;
						pub.publish(msg);
						ros::spinOnce();}
					else{
						msg.emergency_stop = false;}
					break;
			case 3:
					cout << "Ângulo do Punho:\n";
					cin >> msg.set_PUN;
					if(msg.set_PUN == 0){
						msg.emergency_stop = true;
						pub.publish(msg);
						ros::spinOnce();}
					else{
						msg.emergency_stop = false;}
					break;
			case 4:
					cout << "Ângulo do Ombro:\n";
					cin >> msg.set_OMB;
					if(msg.set_OMB == 0){
						msg.emergency_stop = true;
						pub.publish(msg);
						ros::spinOnce();}
					else{
						msg.emergency_stop = false;}

					cout << "Ângulo do Cotovelo:\n";
					cin >> msg.set_COT;
					if(msg.set_COT == 0){
						msg.emergency_stop = true;
						pub.publish(msg);
						ros::spinOnce();}
					else{
						msg.emergency_stop = false;}

					cout << "Ângulo do Punho:\n";
					cin >> msg.set_PUN;
					if(msg.set_PUN == 0){
						msg.emergency_stop = true;
						pub.publish(msg);
						ros::spinOnce();}
					else{
						msg.emergency_stop = false;}
					break;
		}

		pub.publish(msg);
		ros::spinOnce();
		looprate.sleep();

		cout << "\n\n\n";
	}
	return 0;
}