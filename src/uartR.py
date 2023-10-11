import serial
import time
import sys
import signal

portUSB = sys.argv[1]


ser = serial.Serial(
     port='/dev/ttyUSB{}'.format(int(portUSB)),	#Configurar con el puerto
     baudrate = 19200,
#     baudrate=115200,
#     baudrate = 9600,
     parity   = serial.PARITY_NONE,
     stopbits = serial.STOPBITS_ONE,
     bytesize = serial.EIGHTBITS
 )

#ser = serial.serial_for_url('loop://', timeout=None)

#ser.isOpen()
ser.timeout=None
print(ser.timeout)

#limpiamos las pilas
ser.flushInput()
ser.flushOutput()

# Función para manejar la señal SIGINT (Control+C)
def handle_sigint(signum, frame):
    print("Recibida la señal SIGINT (Control+C). Cerrando el puerto serial...")
    ser.close()
    sys.exit(0)

signal.signal(signal.SIGINT, handle_sigint)

while True:
    

    
    out_op = ''
    while ser.inWaiting() > 0:
        readData = ser.read()
        out_op = int.from_bytes(readData,byteorder='big')
        print (">>",out_op)


    #out = str(int.from_bytes(readData,byteorder='big'))
    #print(ser.inWaiting())
    #if out_op != '':
    #    print (">>",out_op)
       