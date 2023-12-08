from pynput.mouse import Controller 
#import Controller 
#import Buttton 
import pyautogui
import time
import threading
mouse = Controller()



#bougie 241 g81 b49
#zigzag241 g81 49
#240 80 48

def Check_grand(rgb):
    if(rgb[0]==30 and rgb[1]==58 and rgb[2]==118):
        return True
    else:
        return False

def Check_petit(rgb):
    if(rgb[0]==240 and rgb[1]==80 and rgb[2]==48):
        return True
    else:
        return False
        
def CheckYellow(rgb):
    if(rgb[0]==237 and rgb[1]==213 and rgb[2]==2):
        return True
    elif(rgb[0]==183 and rgb[1]==168 and rgb[2]==13):
        return True
    else:
        return False

def CheckBleu(rgb):
    if(rgb[0]==9 and rgb[1]==229 and rgb[2]==215):
        return True
    elif(rgb[0]==12 and rgb[1]==181 and rgb[2]==174):
        return True
    elif(rgb[0]==11 and rgb[1]==205 and rgb[2]==195):
        return True
    else:
        return False
def CheckPink(rgb):
	if(rgb[0]==254 and rgb[1]==73 and rgb[2]==149):
		return True
	elif(rgb[0]==197 and rgb[1]==64 and rgb[2]==124):
		return True
	else:
		return False
def clic_fonction(direction,upX,upY,downX,downY):
    print("anaty fonction click")
    if direction == True:
        print("Click miakatra")
        pyautogui.click(upX,upY)
    elif direction == False:
        print("Click midina")
        pyautogui.click(downX,downY)
    else:
        return 2
def CheckDirection(listAX,listAY):
    print(listAY[0])
    print(listAY[5])
    if(listAY[0]>listAY[5]):
        return 1
    else:
        return 2

def CheckAcross(listAX,listAY,listBX,listBY,limit):
    AsupB = 0
    BsupA = 0
    listc = []
    Abx=0
    Bbx=0
    Aby=0
    Bby=0
    Asup=0
    notin=0
    for ax in range(0,len(listAX)):
        #print("Pink X=")
        #print(listAX[ax])

        AX = listAX[ax]

        #ibx = listBX.index(listAX[ax])
        ibx = Index(listBX,listAX[ax])
        #indice 
        if(ibx==-1): #not in list
            print("not in list")
            notin=notin+1
        else: #in list
            #print(ibx)
            BX = listBX[ibx]
            #print("Bleau X=")
            #print(BX)
            AY=listAY[ax]
            BY=listBY[ibx]
            print("df="+str((BY)-(BY)))
            if(Asup==1):
                Bey=BY
                print("Bby = "+str(Bby))
                print("Bey = "+str(Bey))
                if(ax>10):
                    if(Bey>Bby and Bby!=0):
                        return 2
                    elif(Bey<Bby and Bby!=0):
                        return 1
                    else:
                        return False
            if(Asup<1):
                print("df="+str((BY)-(AY)))
                Abx=AX
                Bbx=BX
                Aby=AY
                Bby=BY
                Asup=1
    return False
    
    
    



def Index(list,value):
	for ax in range(0,len(list)):
		if(list[ax]==value):
			return ax
	return -1

def GetMousePosition():
	while 1:
		mouse = pyautogui.position()
		print(mouse)
		
def SymbolScreem(symbol,xb,xe,yb,ye,BUY,SELL,sleep):
    i=0
    while 1:

        t0 = time.time()
        xty=0 #x temp
        xtb=0 #x temp
        xtp=0 #x temp
        ListYellowX = [] #old yellow
        ListYellowY = []
        ListBleuX = [] #old green
        ListBleuY = []
        ListPinkX = [] #old Red
        ListPinkY = []
        #img=pyautogui.screenshot()
        #img = pyautogui.screenshot(region=(xb,xe, yb, ye))
        img = pyautogui.screenshot('my_screenshot.png',region=(xb,yb,xe-xb,ye-yb))
        bxe=xe-xb-1
        bye=ye-yb-1
        print(img)
        for x in range(bxe,0,-1):
            for y in range(bye,0,-1):
                rgb = img.getpixel((x,y))
                if(CheckBleu(rgb)):
                    if(xtb!=x):
                        #pyautogui.click(x,y)
                        #pyautogui.moveTo(x,y)
                        ListBleuX.append(x)
                        ListBleuY.append(y)
                        xtb = x
                if(CheckPink(rgb)):
                    if(xtp!=x):
                        #pyautogui.click(x,y)
                        #pyautogui.moveTo(x,y)
                        ListPinkX.append(x)
                        ListPinkY.append(y)
                        xtp = x
                        #print(x)
                        #print(y)

        if(len(ListPinkX)>0 and len(ListPinkY)>0):
            PinkBleau = CheckDirection(ListPinkX,ListPinkY)
            print("SYMBOL="+str(symbol))
            print("PINK BLEAU="+str(PinkBleau))
            if(PinkBleau==1):
                #print(PinkBleau)
                #print(PinkYellow)
                print("Miakatra BxP||y")
                clic_fonction(True,BUY[0],BUY[1],SELL[0],SELL[1])
                time.sleep(sleep)
                result = pyautogui.screenshot(str(symbol)+'result'+str(i)+'.png',region=(xb,yb,xe-xb,ye-yb))
                i+=1
            elif(PinkBleau==2):
                #print(PinkBleau)
                #print(PinkYellow)
                print("Midina BxP||Y")
                clic_fonction(False,BUY[0],BUY[1],SELL[0],SELL[1])
                time.sleep(sleep)
                result = pyautogui.screenshot(str(symbol)+'result'+str(i)+'.png',region=(xb,yb,xe-xb,ye-yb))
                i+=1
            else:
                print("diso")

        print("time = "+str(time.time()-t0))

        time.sleep(1)
def thread(t,y):
	for i in range(100,-1,-1):
		print("1111111111111111"+str(t)+str(y))
def thread2():
	for i in range(100,-1,-1):
		print("2222222222222222")
XUp = [1512,1264,1310,622,962,1310,622,962,1310]
YUP = [571,290,224,410,410,410,603,603,603]
XDown = [1512,1264,1310,622,962,1310,622,962,1310]
YDown = [635,344,260,410,410,410,634,634,634]
tempSygnal = [400,400,400,400,400,400,400,400,400]

SYMBOL = ["EUR/USD","GBP/USD","GBP/JPY","EUR/JPY","GBP/USD","AUD/CHF","AUD/USD","USD/CAD","AUD/JPY"]


#symbolThread1 = threading.Thread(target=SymbolScreem,args=("EURUSD",0,1599,0,899)) # 1 marcher 165 437
symbolThread1 = threading.Thread(target=SymbolScreem,args=("EURUSD",419,1187,177,686,[1487,606],[1487,675],60)) #hp 1 
#symbolThread1 = threading.Thread(target=SymbolScreem,args=("EURUSD",430,1364,168,482,[1517,371],[1517,434],180))  
#symbolThread2 = threading.Thread(target=SymbolScreem,args=("GBPUSD",402,1370,545,770,[1517,686],[1517,745],180))
symbolThread1.start()
#symbolThread2.start()

symbolThread1.join()
#symbolThread2.join()

#img = pyautogui.screenshot('my_screenshot.png',region=(55,166, 683-55, 438-166))
#img = pyautogui.screenshot('my_screenshot.png',region=(xb,yb,xe-xb,ye-yb))
#------------------------------------------------------xb,yb,xe-xb,ye-yb

#GetMousePosition()
#clic_fonction(True,XUp[0],YUP[0],XDown[0],YDown[0])


	