# admin set commands

# =========================================================
# Import libraries
# =========================================================

# import database
import telegram
from telegram import Bot
from telegram.constants import ParseMode
from datetime import datetime
import asyncio

# from chatbot import logger

import logging

# Enable logging
logging.basicConfig(
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s", level=logging.INFO
)
# set higher logging level for httpx to avoid all GET and POST requests being logged
logging.getLogger("httpx").setLevel(logging.WARNING)

logger = logging.getLogger(__name__)

from dotenv import dotenv_values

config = dotenv_values(".env")

# =========================================================
# Admin class function, Admin.fn
# =========================================================
class Admin:
    
    # empty initializer, a must 
    def __init__(self) -> None:
        pass
    
    
    # set user attributes by user_id or username
    # !!! can use user_id/ username to set any info, except user_id --> need to check the user_id for anything.
    @staticmethod
    async def set_info(self, db, username, key, value, broadcast = "Y"):
        
        # check username in the username list, if not, it's not a user_id, so get username
        # need to parse the incoming data first --> check str or int --> convert to int --> check in a list of int (if it's int in str format)
        # parse username
        username = Admin.parser(username)
        
        if username in map(Admin.parser, db.db["user_id"].unique().tolist()):        # database is db.db, .unique --> shorten the list for faster check, return a numpy ndarray --> tolist() convert ndarray to list --> convert list of floating/ int numbers to int
            user_id = username
            username = db.get_user_attribute(user_id, user_id, "username")
            
        # get user_id from user_name
        else:
            user_id = db.get_user_data_by_username(username,"user_id")
        
        # set chat_id to be user_id
        chat_id = user_id

        # parse value 
        value = Admin.parser(value)

        # set user value
        db.set_user_attribute(user_id, chat_id, key, value)    # parse value to integer/ datetime format from string
        
        # check if the attribute is amended
        check_user_attribute = db.get_user_attribute(user_id, chat_id, key)
        if check_user_attribute == value:                      # access functions of other class by using the class name Admin. 
            text = f"Admin set task done! <b>{username}</b>'s (id: <b>{user_id:.0f}</b>) <i>{key}</i> is successfully set to <i>{value}</i>"
            # check if result above is error or not, if error --> dont broadcast
            # broadcast messages on token balance change if Y (Yes)
            if broadcast == "Y":
                # check dictionary to convert the data columns to normal words 
                if key == "n_balance_tokens":
                    key_text = "token /balance"
                else:
                    key_text = key
                
                await Admin.broadcast(db, [user_id], f"<b>[Admin]</b>: \nYour <i>{key_text}</i> is now set to <i>{value}</i>. Please contact admin (@konyk001) if there're any problems.")
            
        else:
            text = f"Something went wrong, admin set task <b>{username}</b>'s (id: <b>{user_id:.0f}</b>) <i>{key}</i> to {value} failed. <b>{username}</b>'s current (id: <b>{user_id:.0f}</b>) <i>{key}</i> is {check_user_attribute}"
        
        return text, user_id, chat_id
    
    
    # get user attributes by user_id or username
    @staticmethod
    def get_info(db, username, key = 'All'):
        
        # check username in the user_id list, if not, it's not a user_id, so get username
        # need to parse the incoming data first --> check str or int --> convert to int --> check in a list of int (if it's int in str format)
        # parse username
        username = Admin.parser(username)
        
        if username in map(Admin.parser, db.db["user_id"].unique().tolist()):        # database is db.db, .unique --> shorten the list for faster check, return a numpy ndarray --> tolist() convert ndarray to list --> convert list of floating/ int numbers to int
            user_id = username
            username = db.get_user_attribute(user_id, user_id, "username")
            
        # get user_id from user_name
        else:
            user_id = db.get_user_data_by_username(username,"user_id")
        
        chat_id = user_id
        
        # get user_attribute
        attribute = db.get_user_attribute(user_id, chat_id, key)
        
        # return a single user attribute if key != 'All'
        if key != 'All':      
            return f"<b>{username}</b>'s (id: <b>{user_id}</b>) <i>{key}</i>: \n<i>{attribute}</i>"
        
        # if == 'All'
        else:
            return f"<b>{username}</b>'s (id: <b>{user_id}</b>) <i>info</i>: \n<i>{attribute}</i>"
    
    # record admin actions
    @staticmethod
    def record_admin_action(db, admin_user_id: int, command: str, tasks: str, result: str, user_id: int, chat_id: int, key ="admin_action")-> bool:
        
        # record dictionary
        admin_action_dict ={
            "datetime": datetime.now(),
            "admin_user_id": admin_user_id,
            "command": command,
            "tasks": tasks,
            "result": result,        
        }
        
        # add admin_action into the database
        db.set_user_attribute(user_id, chat_id, key, admin_action_dict)
        
        # check admin_action added
        if db.get_user_attribute(user_id, chat_id, key) == admin_action_dict:
            return True
        else:
            return False
        
    # get list from data with criteria
    # /admin get_list key criteria_1 operator(>=) value_1 criteria_2 operator(>=) value_2 ... multiple values
    # returning a list of str from tg: [criteria_1, operator(>=), value_1, criteria_2, operator(>=), value_2, ...]
    # check size of list in times of 3 --> determine the loop 
    @staticmethod
    def get_list(db, key):
        
        # return a list
        data_list = db.get_user_data_list(key)      # return a list
        
        # parse the data:
        data_list = list(map(Admin.parser, data_list))[:]      # parse any integers, convert map to list
        
        # drop nana data
        data_list = [i for i in data_list if str(i) != "nan"] # drop the first user_list nan --> UPDATE to see if other methods (or amend if changed databsae structure)
        
        # combine the list to a string
        data_list_str = "[" + ",".join(str(i) for i in data_list) + "]"     # convert any value into str
        
        # screen text size to <4000 words
        if len(data_list_str) > 4000:
            text = f"Result for {key} exceeds the 4000 word-limit, showing only the incomplete results:\n"
            text += data_list[:4000-len(text)]
        else:
            text = f"<b>{len(data_list)}</b> {key}:\n {data_list_str}"
        
        return text                # return a string
    
    # function to parse integers
    @staticmethod
    def parser(data):
        # text parse
        try:
            data = int(data)
        except ValueError:
            try:
                data = datetime.strptime(data, "%Y-%m-%d %H:%M:%S")    
            except ValueError:
                data = data
            except TypeError:
                data = data
        except TypeError:
            data = data
        finally:
            data = data
        return data

    # get all column headers from database
    @staticmethod
    def get_headers(db):
        
        data_headers = db.get_data_headers()
        
        data_headers = "[\n" + ",\n".join(str(i) for i in data_headers) + "\n]"     # convert any value into str       
        
        return f"Database headers are: {data_headers}"

    
    # sendmessage function to be used in broadcaster later
    @staticmethod
    async def sendmessage(user_id: int, messages: str):
        
        #add bot details
        bot = Bot(token= config["TOKEN"])
        
        try:
            await bot.send_message(user_id, messages, parse_mode= ParseMode.HTML)
        except telegram.error.RetryAfter as e:
            logger.error(f'Time: {datetime.now().strftime("%Y-%m-%d %H:%M:%S")}, User {user_id} flood limit is exceeded, sleep for 1s. Reason: {e}')
            await asyncio.sleep(1)      # sleep 5 seconds before retry
            return await Admin.sendmessage(user_id, messages)      # recursive function
        except Exception as e:
            logger.error(f'Time: {datetime.now().strftime("%Y-%m-%d %H:%M:%S")}, Something went wrong during sending message to usernames: {user_id}. Reason: {e}')
        else:
            logger.info(f"Send message to user_id: {user_id} is successful.")
            return True
        return False

    # broadcast use user_id 
    # broadcaster
    @staticmethod
    async def broadcast(db, user_list: list, messages: str):          # user_list: user_id list
        # set counter
        count = 0
        user_list_fail = user_list[:]             # cannot point to a list, need to copy the list value by using [:], otherwise, they will be the same, see ref: https://stackoverflow.com/questions/49594953/assigning-one-list-to-another
        try:
            for user_id in user_list:
                if await Admin.sendmessage(user_id, messages):            # successfully sent messages, count +1
                    count += 1
                    user_list_fail.remove(user_id)
                await asyncio.sleep(0.05)                           # flood limit is 30 messages per sec, so 1/30 = 0.03s per message
        finally:
            if len(user_list_fail) == 0:        # no failed users, object type = None, ["0"].remove("0"), return None object type
                text = f"<b>{count}</b> messages successfully sent, 0 messages failed."
            else:
                user_list_fail_usernames = [db.get_user_attribute(i, i, "username") for i in user_list_fail]    # get username using user_id
                text = f"<b>{count}</b> messages successfully sent, <b>{len(user_list_fail)}</b> messages failed, user ids are <i>{', '.join(user_list_fail_usernames)}</i>."
            logger.info(text)
        
        return text

    @staticmethod
    def help():

        help_message = """<b>Commands</b>:
- <b>set user attribute by username/id:</b> 
  /admin set username/user_id key value broadcast (default= "Y")
   > balance: /admin set username/id n_balance_tokens value Y
   > username: /admin set user_id username value N
- <b>get user attribute by username/id:</b> 
  /admin get username/user_id key
- <b>get data list:</b> /admin get_list key
   > usernames: /admin get_list username
   > user ids: /admin get_list user_id
- <b>get data headers (keys):</b> /admin get_headers
- <b>broadcast message to user(s):</b> /admin broadcast [all/usernames] message

        """

        return help_message


