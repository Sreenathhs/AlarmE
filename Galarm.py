from flask import Flask
from flask import jsonify
from flask import request
from pyfcm import FCMNotification
from datetime import datetime

import asyncio
import websockets
import requests
import json
import mysql.connector
import time


mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    passwd="",
    database="sample"
)

mycursor = mydb.cursor(buffered=True)

app = Flask(__name__)

@app.route('/', methods=['GET'])
# def hello_world():
#     push_service = FCMNotification(
#         api_key="AAAAIOlLZ2E:APA91bH3xaxOKS2Gl6EoGTcJZhV0trsaXiaO1cFpPeDYFk_gSwU_gsPn5x5YAt55pdijbm-SYtNxIjYgdZ3-5Rjxqgko1QX-3z6XWTb0GM3v9wshyjiCGy1CBIPi3d-JUihiekwOz3_g")
#     registration_ids = [
#         "ehP25Xs0pfM:APA91bGAnJwSHz3p_1ki5u11uFqmVBnenfPmfahmwGsW5tyfXuwERohU6TZibhWhmOELBgzNxEk7FvWc2AeIvau9gWYeTIZUGP4VDeX8bu3HK-tduy9eVPRttUZDscIflneYUKA_kpb0",
#         "ffukl3IDClQ:APA91bFXfG27GySxazLOSHHfQ0MNGcvYZJYqnZfxUItSR7g9eogx27ygr5NofzXCknla-kIPGy9lkVtjejxZmdGIqfrlG_TgX0g3rqm-ROIgFk9C1Zec2mK-IfrCojsAuZLtnFSHbE1c"]
#     message_title = "BSRHSR"
#     message_body = "Hfdhdhghforget to check today's news"
#     result = push_service.notify_multiple_devices(registration_ids=registration_ids, message_title=message_title,
#                                                   message_body=message_body)
#     print(result)

@app.route('/register', methods=['POST'])
def register_user():

    # Gather Registration Data
    req_data = request.get_json()
    name = req_data['Name']
    email = req_data['Email']
    password = req_data['Password']
    phone = req_data['Phone']

    #Check for dupliate user
    sql = "SELECT * from users where Email=%s"
    values = [email]
    mycursor.execute(sql,values)
    result = mycursor.fetchall()
    if (result):
        return jsonify({'success' : False,
                       'error_info' : 'Duplicate'})
    else:
    # On Successfull verification of new user, insert into DB
        sql = "INSERT INTO users(Name, Email, Password, Phone) VALUES (%s,%s,%s,%s)"
        values = [name, email, password, phone]
        mycursor.execute(sql, values)
        mydb.commit()
        return jsonify({'success': True})

@app.route('/login', methods=['POST'])
def login_user():

    #Gather Login Data
    req_data = request.get_json()
    email = req_data['Email']
    password = req_data['Password']
    token = req_data['Token']

    #Check if User exists
    sql = "SELECT Email,Password,Name,ID from users where Email=%s"
    values = [email]
    mycursor.execute(sql,values)
    result = mycursor.fetchone()
    if (result):
        if (result[1] == password):
            sql = "UPDATE users SET DeviceID = %s WHERE ID = %s"
            values = [token,result[3]]
            mycursor.execute(sql,values)
            mydb.commit()
            return jsonify({'success': True,
                            'user_details' : {
                                'name' : result[2],
                                'email' : result[0],
                                'id' : result[3]
                            }})
        else:
            return jsonify({'success' : False,
                            'error_info' : 'Incorrect password'})
    else:
        print("User does not exists")
        return jsonify({'success' : False,
                        'error_info' : 'User does not exist'})

@app.route('/logout', methods=['POST'])
def logout_user():
    req_data = request.get_json()
    id = req_data['ID']

    print(id)
    sql = "UPDATE users set DeviceID = NULL WHERE ID = %s"
    values = [id]
    mycursor.execute(sql,values)
    mydb.commit()
    return  jsonify({'success': True})

@app.route('/getsession', methods=['POST'])
def get_session():
    req_data = request.get_json()
    Token = req_data['Token']
    sql = "SELECT Email,Password,Name,ID from users where DeviceID=%s"
    values = [Token]
    mycursor.execute(sql,values)
    result = mycursor.fetchone()
    if (result):
        print("Found it")
        return jsonify({'success': True,
                        'user_details': {
                            'name': result[2],
                            'email': result[0],
                            'id': result[3]
                        }})
    else:
        print("Did not find")
        return jsonify({'success': False})


@app.route('/fetchgroups', methods=['POST'])
def fetch_groups():
    req_data = request.get_json()
    userID = req_data['id']

    #Check for groups
    sql = "SELECT group_id from group_members where user_id=%s"
    values = [userID]
    mycursor.execute(sql,values)
    result = mycursor.fetchall() # Has Group IDs
    print(userID)
    groups = []
    for record in result:
        group_info = {}
        sql = "SELECT name from groups where id=%s"
        values = [record[0]]
        mycursor.execute(sql,values)
        group_name = mycursor.fetchone()[0]
        group_info['gname'] = group_name
        group_info['groupID'] = record[0]
        sql = "SELECT user_id from group_members where group_id=%s"
        values = [record[0]]
        mycursor.execute(sql,values)
        user_ids = mycursor.fetchall()
        group_members_arr = []
        for user_id in user_ids:
            sql = "SELECT Name from users where ID=%s"
            values = [user_id[0]]
            mycursor.execute(sql,values)
            group_members_arr.append(mycursor.fetchone()[0])
        group_info['members'] = group_members_arr
        groups.append(group_info)
    return json.dumps(groups)


@app.route('/fetchuseralarms', methods=['POST'])
def fetch_useralarms():
    req_data = request.get_json()
    userID = req_data['id']
    sql = "SELECT group_id from group_members where user_id=%s"
    values = [userID]
    mycursor.execute(sql,values)
    result = mycursor.fetchall()
    alarm_list = []
    for i in result:
        sql = "SELECT timeset from alarms where group_id=%s"
        values = i
        mycursor.execute(sql,values)
        res = mycursor.fetchall()
        if (res):
            for j in res:
                alarmtime = datetime.strptime(str(j), "(datetime.datetime(%Y, %m, %d, %H, %M),)")
                alarm_list.append(str(alarmtime.year) + '-' + str(alarmtime.strftime("%m")) + '-' + str(alarmtime.strftime("%d")) + ' ' + str(alarmtime.strftime("%H")) + ':' + str(alarmtime.strftime("%M")) + ':00')
    return jsonify(alarm_list)

@app.route('/fetchgroupalarms', methods=['POST'])
def fetch_groupalarms():
    req_data = request.get_json()
    groupID = req_data['groupID']
    sql = "SELECT * from alarms where group_id=%s"
    values = [groupID]
    mycursor.execute(sql,values)
    result = mycursor.fetchall()
    alarms = []
    for record in result:
        alarm = {}
        alarm['id'] = record[0]
        alarm['group_id'] = record[1]
        alarm['timeset'] = record[2]
        alarm['description'] = record[3]
        alarms.append(alarm)
    print(alarms)
    return  jsonify(alarms)

async def hello(websocket, path):
    name = await websocket.recv()
    print(f"< {name}")

    greeting = f"Hello {name}!"

    await websocket.send(greeting)
    print(f"> {greeting}")


if __name__ == "__main__":
    # app.run(debug=True)
    start_server = websockets.serve(hello, "localhost", 5001)

    asyncio.get_event_loop().run_until_complete(start_server)
    asyncio.get_event_loop().run_forever()