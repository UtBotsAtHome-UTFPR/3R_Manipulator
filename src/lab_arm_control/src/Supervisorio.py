#!/usr/bin/env python
# -*- coding: utf-8 -*-

from pyqtgraph.Qt import QtGui, QtCore
import numpy as np
import pyqtgraph as pg
import math
import random
import rospy
import turtlesim.msg
import sys

#Declara e define informações da GUI.
app = QtGui.QApplication([])
mw = QtGui.QMainWindow()
mw.setWindowTitle('Monitor')
mw.resize(800,800)
cw = QtGui.QWidget()
mw.setCentralWidget(cw)

#Cria os widgets de gráficos.
pw1 = pg.PlotWidget(name='Joint 1')
pw2 = pg.PlotWidget(name='Joint 2')
pw3 = pg.PlotWidget(name='Joint 3')

#Cria os widgets de botão.
btn1 = QtGui.QPushButton('Button 1')
btn2 = QtGui.QPushButton('Button 2')
btn3 = QtGui.QPushButton('Button 3')

#Indica que o layout é no formato de grid e posiciona os widgets.
l = QtGui.QGridLayout()
l.addWidget(pw1,0,1)
l.addWidget(pw2,1,1)
l.addWidget(pw3,2,1)
l.addWidget(btn1,0,0)
l.addWidget(btn2,1,0)
l.addWidget(btn3,2,0)


#Seta o layout montado e abre a janela.
cw.setLayout(l)
mw.show()

#Seta as séries dos gráficos e inicializa com valores quaisquer.
J1_setpoint = pw1.plot(pen=(255,0,0), name="Setpoint")
J1_data = pw1.plot(pen=(0,0,255), name="Data")

J2_setpoint = pw2.plot(pen=(255,0,0), name="Setpoint")
J2_data = pw2.plot(pen=(0,0,255), name="Data")

J3_setpoint = pw3.plot(pen=(255,0,0), name="Setpoint")
J3_data = pw3.plot(pen=(0,0,255), name="Data")

pw1.setLabel('left', 'Joint 1', units='Deg')
pw1.setLabel('bottom', 'Time', units='ms')
pw1.setYRange(-2*math.pi, 2*math.pi)

pw2.setLabel('left', 'Joint 2', units='Deg')
pw2.setLabel('bottom', 'Time', units='ms')
pw2.setYRange(-2*math.pi, 2*math.pi)

pw3.setLabel('left', 'Joint 3', units='Deg')
pw3.setLabel('bottom', 'Time', units='ms')
pw3.setYRange(-2*math.pi, 2*math.pi)

#Inicializa as séries dos gráficos como lista.
data_J1x = []
data_J1y = []
data_J2x = []
data_J2y = []
data_J3x = []
data_J3y = []

#Função chamada toda vez que chega uma mensagem.
def callback(data):
	#Dados da Junta 1.
    data_J1x.extend([data.x])
    data_J1y.extend([data.y])

	#Dados da Junta 2.
    data_J2x.extend([data.x])
    data_J2y.extend([data.y])

	#Dados da Junta 3.
    data_J3x.extend([data.x])
    data_J3y.extend([data.y])

#Atualiza os gráficos.
def updateData():
	#Atualiza gráfico da Junta 1.
    J1_setpoint.setData(x=data_J1x, y=data_J1y)
    J1_data.setData(x=data_J1y, y=data_J1x)
    pw1.setXRange(0, 10)
    pw1.setYRange(0, 10)

	#Atualiza gráfico da Junta 1.
    J2_setpoint.setData(x=data_J2x, y=data_J2y)
    J2_data.setData(x=data_J2y, y=data_J2x)
    pw2.setXRange(0, 10)
    pw2.setYRange(0, 10)

	#Atualiza gráfico da Junta 1.
    J3_setpoint.setData(x=data_J3x, y=data_J3y)
    J3_data.setData(x=data_J3y, y=data_J3x)
    pw3.setXRange(0, 10)
    pw3.setYRange(0, 10)

#Timer para atualizar o gráfico.
t = QtCore.QTimer()
t.timeout.connect(updateData)
t.start(50)

#Inicia o nó do ROS.
rospy.init_node('Supervisorio')
rospy.Subscriber("/turtle1/pose", turtlesim.msg.Pose, callback)

#Inicia a GUI.
QtGui.QApplication.instance().exec_()

#Mantém o programa enquanto há conexão com ROS.
rospy.spin()