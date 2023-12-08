
import requests

def ExchangeInfo():
    try:
        data = requests.get('https://fapi.binance.com/fapi/v1/exchangeInfo')
        dataJson = data.json()
        #print(dataJson)
        return dataJson

    except ConnectionError as e:    # This is the correct syntax
        #print(e)
        r = "No response"
        return 0

