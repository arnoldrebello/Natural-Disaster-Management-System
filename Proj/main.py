from flask import Flask
from flask import Flask, redirect, url_for, render_template,request,jsonify
import numpy as np
import os
import datetime
import json
import urllib.request
from src.fwi import *
import pickle
import pandas as pd

app = Flask(__name__,template_folder='template')

@app.route("/",methods=["POST","GET"])
def home():
	return render_template("index.html")

@app.route("/chat")
def chat():
    return render_template("chat.html")
@app.route('/predict',methods = ["POST","GET"])
def predict():
    data = request.get_json(force=True)
    x = data['data1']
    y = data['data2']
    url = "http://api.openweathermap.org/data/2.5/weather?lat={}&" \
          "lon={}&appid=997248ab2a9c56c05cf48c93efca9b27".format(y, x)
    j = json.load(urllib.request.urlopen(url))
    dates = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
    now = datetime.datetime.now()
    month = now.month
    day = dates.index(now.strftime("%A")) + 1
    temp = 0
    wind = 0
    rh = 0
    rain = 0
    ffmc = 0
    dmc = 0
    dc = 0
    isi = 0
    lat = float(x)
    try:
        temp = j['main']['temp'] - 273.15
    except KeyError:
        pass
    try:
        wind = j['wind']['speed'] * 3.6
    except KeyError:
        pass
    try:
        rh = j['main']['humidity']
    except KeyError:
        pass
    try:
        rain = ((j['rain']['1h']) / 3) / ((742300000 / 9) ** 2)
    except KeyError:
        pass
    try:
        ffmc = FFMC(temp, rh, wind, rain, 57.45)
    except KeyError:
        pass
    try:
        dmc = DMC(temp, rh, rain, 146.2, lat, month)
    except KeyError:
        pass
    try:
        dc = DC(temp, rain, 434.25, lat, month)
    except KeyError:
        pass
    try:
        isi = ISI(wind, ffmc)
    except KeyError:
        pass
    print("values:",temp,wind,rh,rain,ffmc,dmc,dc,isi)
    
    with open('model_pickle','rb') as f:
        mp = pickle.load(f)
    
    used_features = ["DMC","temp","RH","wind"]
    data = {'DMC':[dmc],'temp':[temp],'RH':[rh],'wind':[wind]}
    dataframe = pd.DataFrame(data,used_features)
    
    print(dataframe)
    
    res = mp.predict(dataframe)/5
    
    if(res[0]>10):
        predi="Area prone to fire. Watch out!{} estimated ha. to be burnt".format(res[0])
    else:
        predi="Prediction: {} ha".format(res[0])
    return render_template('predict.html',pred=predi)

if __name__ == "__main__":
    app.run()