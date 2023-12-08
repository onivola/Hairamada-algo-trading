from pynput.mouse import Controller 
#import Controller 
#import Buttton 
import pyautogui
import time
import threading
mouse = Controller()





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
		pyautogui.click(upX ,upY)
	elif direction == False:
		print("Click midina")
		pyautogui.click(downX,downY)
		
	else:
    	 return 2

def CheckAcross(listAX,listAY,listBX,listBY,limit):

	AsupB = 0
	BsupA = 0
	listc = []
	"""if not listAX:
		return False
	if not listAY:
		return False
	if not listBX:
		return False
	if not listBY:
		return False"""
	for ax in range(0,len(listAX)):
		#print("Pink X=")
		#print(listAX[ax])
		
		AX = listAX[ax]
		
		#ibx = listBX.index(listAX[ax])
		ibx = Index(listBX,listAX[ax])
		if(ibx==-1): #not in list
			print("not in list")
		else: #in list
			#print(ibx)
			BX = listBX[ibx]
			#print("Bleau X=")
			#print(BX)
			AY=listAY[ax]
			BY=listBY[ibx]
			if(AY<=BY):
				#print("Pink>=BY")
				AsupB+=1
				listc.append(1)
			else:
				#print("BY>Pink")
				listc.append(2)
				BsupA+=1
			if(BsupA>=1 and AsupB>=1):
				break
			elif(AsupB>limit):
				return "A>>B"
			elif(BsupA>limit):
				return "B>>A"
				
	print(listc)
	'''print(len(listc))
	print(limit)
	print(AsupB)
	print(BsupA)'''
	print("len list="+str(len(listc)))
	print("limit="+str(limit)+"px")
	if(listc[0]==1 and listc[len(listc)-1]==2 and AsupB<=limit):
		#print("Pink>=BY")
		return "A>=B"
	elif(listc[0]==2 and listc[len(listc)-1]==1 and BsupA<=limit):
		#print("BY>Pink")
		return "B>A"
	elif(listc[0]==2 and listc[len(listc)-1]==2 and BsupA<=limit):
		#print("BY>>>>Pink")
		return "B>>A"
	elif(listc[0]==1 and listc[len(listc)-1]==1 and AsupB<=limit):
		#print("Pink>>>>BY")
		return "A>>B"


def Index(list,value):
	for ax in range(0,len(list)):
		if(list[ax]==value):
			return ax
	return -1

def GetMousePosition():
	while 1:
		mouse = pyautogui.position()
		print(mouse)
		
def SymbolScreem(symbol,xb,xe,yb,ye,BUY,SELL):
	i=0
	sleep = 60
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
				if(CheckYellow(rgb)):
					if(xty!=x):
						#pyautogui.click(x,y)
						#pyautogui.moveTo(x,y)
						
						ListYellowX.append(x)
						ListYellowY.append(y)
						xty = x
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

		#print(ListPinkX)
		#print(ListPinkY)

		if(len(ListYellowX)>0 and len(ListYellowY)>0 and len(ListBleuX)>0 and len(ListBleuY)>0 and len(ListPinkX)>0 and len(ListPinkY)>0):
			PinkBleau = CheckAcross(ListPinkX,ListPinkY,ListBleuX,ListBleuY,40)
			PinkYellow = CheckAcross(ListPinkX,ListPinkY,ListYellowX,ListYellowY,10)
			BleuYellow = CheckAcross(ListBleuX,ListBleuY,ListYellowX,ListYellowY,40)
			print("SYMBOL="+str(symbol))
			if(PinkBleau=="B>A" and PinkYellow=="A>>B"):
				#print(PinkBleau)
				#print(PinkYellow)
				print("Miakatra BxP||y")
				clic_fonction(True,BUY[0],BUY[1],SELL[0],SELL[1])
				time.sleep(sleep)
				result = pyautogui.screenshot(str(symbol)+'result'+str(i)+'.png',region=(xb,yb,xe-xb,ye-yb))
				i+=1
			elif(PinkBleau=="A>=B" and PinkYellow=="B>>A"):
				#print(PinkBleau)
				#print(PinkYellow)
				print("Midina BxP||Y")
				clic_fonction(False,BUY[0],BUY[1],SELL[0],SELL[1])
				time.sleep(sleep)
				result = pyautogui.screenshot(str(symbol)+'result'+str(i)+'.png',region=(xb,yb,xe-xb,ye-yb))
				i+=1
			elif(BleuYellow=="A>=B"):
				print(BleuYellow)
				print("Miakatra BxY")
				clic_fonction(True,BUY[0],BUY[1],SELL[0],SELL[1])
				time.sleep(sleep)
				result = pyautogui.screenshot(str(symbol)+'result'+str(i)+'.png',region=(xb,yb,xe-xb,ye-yb))
				i+=1
			elif(BleuYellow=="B>A"):
				print(BleuYellow)
				print("Midina BxY")
				clic_fonction(False,BUY[0],BUY[1],SELL[0],SELL[1])
				time.sleep(sleep)
				result = pyautogui.screenshot(str(symbol)+'result'+str(i)+'.png',region=(xb,yb,xe-xb,ye-yb))
				i+=1
			else:
				print("diso")

			print("time = "+str(time.time()-t0))
		
		time.sleep(2)
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
symbolThread1 = threading.Thread(target=SymbolScreem,args=("EURUSD",427,1320,223,472,[1517,371],[1517,434]))  
symbolThread2 = threading.Thread(target=SymbolScreem,args=("GBPUSD",395,1255,593,784,[1517,686],[1517,745]))
symbolThread1.start()
symbolThread2.start()

symbolThread1.join()
symbolThread2.join()

#img = pyautogui.screenshot('my_screenshot.png',region=(55,166, 683-55, 438-166))
#img = pyautogui.screenshot('my_screenshot.png',region=(xb,yb,xe-xb,ye-yb))
#------------------------------------------------------xb,yb,xe-xb,ye-yb

#GetMousePosition()
#clic_fonction(True,XUp[0],YUP[0],XDown[0],YDown[0])


	