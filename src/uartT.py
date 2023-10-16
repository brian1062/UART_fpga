import serial
import time
import sys

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

while True:
    #char_v = []
    print("(type 'exit' to quit) \n")
    print("Seleccione la operacion que desea realizar: ")
    print("1) SUMA=A+B\n2) RESTA=A-B \n3) AND=(A)&(B)")
    print("4) OR=(A)OR(B)\n5) XOR=(A)XOR(B)\n6) NOR=(A)NOR(B)")
    print("7) SRA=(A)>>>(B)\n8) SRL=(A)>>(B)")
    operation = input()
    if operation == 'exit':
        if ser.isOpen():
            ser.close()
        break

    if operation == '1':   # Suma
        op_val = 0b100000#32
    elif operation == '2': # Resta
        op_val = 0b100010#34
    elif operation == '3': # And
        op_val = 0b100100#36
    elif operation == '4': # Or
        op_val = 0b100101#37
    elif operation == '5': # Xor
        op_val = 0b100110#38
    elif operation == '6': # Nor
        op_val = 0b100111#39
    elif operation == '7': # Sra
        op_val = 0b000011#3
    elif operation == '8': # Srl
        op_val = 0b000010#2
    else:
        print("Opcion invalida")
        op_val = 0

    send_v = []
    ser.write(op_val.to_bytes(1, 'big'))


    #send_v.append(op_val.to_bytes(1, 'big'))
    ##----------
    #ser.write(send_v[0])
    ##------------

    val_a = input("Ingrese el valor de A: ")
    send_v.append(int(val_a).to_bytes(1, 'big'))
    ##----------
    ser.write(send_v[0])
    ##------------
    val_b = input("Ingrese el valor de B: ")

    send_v.append(int(val_b).to_bytes(1, 'big'))
    ##----------
    ser.write(send_v[1])
    ##------------
    print("")
    #for ptr in range(len(send_v)):
    #    ser.write(send_v[ptr])
    #print("Trama enviada:")
    #print(op_val,send_v)
    #     #Rx
    
    
    #out_op = ''
    #while ser.inWaiting() > 0:
    #    readData = ser.read()
    #    out_op = int.from_bytes(readData,byteorder='big')
    #    print (">>",out_op)
    #time.sleep(1)


    #out = str(int.from_bytes(readData,byteorder='big'))
    #print(ser.inWaiting())
    #if out_op != '':
    #    print (">>",out_op)
       