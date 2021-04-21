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
	while(mode != 8){

		cout << "Digite o modo de operação:\n";
		cout << "1: Somente Ombro.\n";
		cout << "2: Somente Cotovelo.\n";
		cout << "3: Somente Punho.\n";
		cout << "4: Todos.\n";
		cout << "5: Abre/fecha a Garra.\n";
		cout << "6: Reset.\n";
		cout << "7: Retry.\n";
		cout << "8: Sair.\n";
		cin >> mode;

		system("clear");

		switch(mode){
			case 1:
					msg.reset = false;
					msg.retry = false;
					cout << "Ângulo do Ombro:\n";
					cin >> msg.set_OMB;
					if(msg.set_OMB == 0){
						msg.emergency_stop = true;
						pub.publish(msg);
						ros::spinOnce();}
					else{
						msg.emergency_stop = false;}
					pub.publish(msg);
					ros::spinOnce();
					break;
			case 2:
					msg.reset = false;
					msg.retry = false;
					cout << "Ângulo do Cotovelo:\n";
					cin >> msg.set_COT;
					if(msg.set_COT == 0){
						msg.emergency_stop = true;
						pub.publish(msg);
						ros::spinOnce();}
					else{
						msg.emergency_stop = false;}
					pub.publish(msg);
					ros::spinOnce();
					break;
			case 3:
					msg.reset = false;
					msg.retry = false;
					cout << "Ângulo do Punho:\n";
					cin >> msg.set_PUN;
					if(msg.set_PUN == 0){
						msg.emergency_stop = true;
						pub.publish(msg);
						ros::spinOnce();}
					else{
						msg.emergency_stop = false;}
					pub.publish(msg);
					ros::spinOnce();
					break;
			case 4:
					msg.reset = false;
					msg.retry = false;
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
					pub.publish(msg);
					ros::spinOnce();
					break;
			case 5:
					msg.reset = false;
					msg.retry = false;

					if(msg.set_GAR){
						msg.set_GAR = false;
						cout << "Garra Fechando.\n";
					}else{
						msg.set_GAR = true;
						cout << "Garra Abrindo.\n";
					}
					pub.publish(msg);
					ros::spinOnce();
					break;
			case 6:
					msg.reset = true;
					msg.retry = false;
					msg.set_OMB = 0;
					msg.set_COT = 0;
					msg.set_PUN = 0;
					pub.publish(msg);
					ros::spinOnce();
					break;
			case 7:
					msg.reset = false;
					msg.retry = true;
					pub.publish(msg);
					ros::spinOnce();
					break;
			case 8:
					msg.reset = true;
					msg.retry = false;
					pub.publish(msg);
					ros::spinOnce();
					break;
		}
		cout << "\n\n";
	}
	return 0;
}