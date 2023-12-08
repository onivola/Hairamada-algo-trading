#!/usr/bin/env python

# WS client example
from tkinter import * 
import asyncio
import websocket
import json
import time
import threading
import requests


sctOrderbk = f'wss://stream.binance.com:9443/ws/{cc}@depth@100ms'
sctPrice = 'wss://fstream.binance.com/ws/btcusdt@markPrice'

def on_close(ws):
	print('connection closed')

def on_orderbook(ws,message):
	dataJS = json.loads(message)
	#print(dataJS[])
	#print("sell"+str(dataJS['a'][0])) #asc  sell

#def Add order
def thread2(d,f):
	ws = websocket.WebSocketApp(sctPrice,on_message=on_orderbook,on_close=on_close)
	ws.run_forever()

t2 = threading.Thread(target=thread2,args=(1,1))
t2.start()



