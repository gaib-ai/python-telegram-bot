#!/usr/bin/env python
# pylint: disable=unused-argument
# This program is dedicated to the public domain under the CC0 license.

"""
Simple Bot to forward Telegram messages.

First, a few handler functions are defined. Then, those functions are passed to
the Application and registered at their respective places.
Then, the bot is started and runs until we press Ctrl-C on the command line.

Usage:
Forward message.
Press Ctrl-C on the command line or send a signal to the process to stop the bot.
"""

import logging

from telegram import ForceReply, Update
from telegram.ext import Application, CommandHandler, ContextTypes
from ptbcontrib.send_by_kwargs import send_by_kwargs

from tests.test_botcommandscope import chat_id

# Enable logging
logging.basicConfig(
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s", level=logging.INFO
)

# set higher logging level for httpx to avoid all GET and POST requests being logged
logging.getLogger("httpx").setLevel(logging.WARNING)

logger = logging.getLogger(__name__)

from dotenv import dotenv_values

config = dotenv_values(".env")


recipient_group_chat_ids = ["-1002431029666", "-1002347417100"]


# Define a few command handlers. These usually take the two arguments update and context.
async def start(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    """Send a message when the command /start is issued."""
    user = update.effective_user
    await update.message.reply_html(
        rf"Hi {user.mention_html()}! I am the GAIB AI Bog.",
        reply_markup=ForceReply(selective=True),
    )


async def forward(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    """Forward a message when the command /forward is issued."""
    if update.message.reply_to_message:
        # Forward the message to the chat where the original message was sent
        # await update.message.reply_to_message.forward(chat_id=update.message.chat_id)
        for chat_id in recipient_group_chat_ids:
            await update.message.reply_to_message.forward(chat_id)
    else:
        await update.message.reply_text("Please reply to a message you want to forward.")


async def copy(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    """Copy a message when the command /copy is issued."""
    if update.message.reply_to_message:
        for chat_id in recipient_group_chat_ids:
            await update.message.reply_to_message.copy(chat_id)
    else:
        await update.message.reply_text("Please reply to a message you want to copy.")


async def help_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    """Send a message when the command /help is issued."""
    await update.message.reply_text("Use /start to start to greet the bot. "
                                    "Use /copy to copy message. "
                                    "User /forward to forward a message.")


def main() -> None:
    """Start the bot."""
    # Create the Application and pass it your bot's token.
    application = Application.builder().token(config["TOKEN"]).build()

    # on different commands - answer in Telegram
    application.add_handler(CommandHandler("start", start))
    application.add_handler(CommandHandler("copy", copy))
    application.add_handler(CommandHandler("forward", forward))
    application.add_handler(CommandHandler("help", help_command))

    # Run the bot until the user presses Ctrl-C
    application.run_polling(allowed_updates=Update.ALL_TYPES)


if __name__ == "__main__":
    main()
