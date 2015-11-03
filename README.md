# KalmanFilter

# This project realizes and test the Kalman Filter in matlab code
#
# File List:
#
# @kf_modele.m:	
#	the dynamic system model and measurement model definded here.
#
# @kf_predict.m
#	time update 
#
# @kf_update.m:
# 	measurement update
#
# @kf_ui.fig:
#	GUI file in matlab.it can convenientely tune some parameters and change test cases.
#
# @kf_ui.m:
#	GUI event responses.
#
# @ Exp_oneDim.m:
#	test case one. system state is a constant number and measurement is also a number with Gussian White Noise.
#
# @ Exp_cwpa.m:
#	test case two. system dynamic is CWPA
#
# @ Exp_measured.m
#	test case three. useing the real measured data from IVQ905 sensor in ./data/filter_in.data to test KF.
#
