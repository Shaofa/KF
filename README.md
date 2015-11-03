# KalmanFilter

''This project realizes and test the Kalman Filter in matlab code''

''' File List:'''

1. @kf_modele.m:	
	the dynamic system model and measurement model definded here.

2. @kf_predict.m
	time update 

3. @kf_update.m:
 	measurement update

4. @kf_ui.fig:
	GUI file in matlab.it can convenientely tune some parameters and change test cases.

5. @kf_ui.m:
	GUI event responses.

6. @ Exp_oneDim.m:
	test case one. system state is a constant number and measurement is also a number with Gussian White Noise.

7. @ Exp_cwpa.m:
	test case two. system dynamic is CWPA

8. @ Exp_measured.m
	test case three. useing the real measured data from IVQ905 sensor in ./data/filter_in.data to test KF.
