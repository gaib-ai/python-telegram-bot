CREATE SCHEMA IF NOT EXISTS bot_schema;

CREATE TABLE IF NOT EXISTS bot_schema.reaction (
  "reaction_id" int PRIMARY KEY NOT NULL,
  "user_id" int NOT NULL,
  "message_id" int NOT NULL,
  "reaction_type" varchar(20) NOT NULL,
  "reacted_at" timestamp NOT NULL
);

CREATE TABLE IF NOT EXISTS bot_schema.notification (
  "notification_id" int PRIMARY KEY NOT NULL,
  "user_id" int NOT NULL,
  "notification_content" text NOT NULL,
  "sent_at" timestamp NOT NULL,
  "read_at" timestamp
);

CREATE TABLE IF NOT EXISTS bot_schema.contact (
  "contact_id" int PRIMARY KEY NOT NULL,
  "user_id" int NOT NULL,
  "contact_user_id" int NOT NULL,
  "added_at" timestamp NOT NULL
);

CREATE TABLE IF NOT EXISTS bot_schema.subscription (
  "subscription_id" int PRIMARY KEY NOT NULL,
  "user_id" int NOT NULL,
  "plan_name" varchar(50) NOT NULL,
  "start_date" timestamp NOT NULL,
  "end_date" timestamp NOT NULL
);

CREATE TABLE IF NOT EXISTS bot_schema.bot (
  "bot_id" int PRIMARY KEY NOT NULL,
  "bot_name" varchar(100) NOT NULL,
  "bot_token" varchar(255) NOT NULL,
  "creator_user_id" int NOT NULL,
  "created_at" timestamp NOT NULL
);

CREATE TABLE IF NOT EXISTS bot_schema.chat (
  "chat_id" int PRIMARY KEY NOT NULL,
  "chat_name" varchar(100) NOT NULL,
  "created_at" timestamp NOT NULL,
  "chat_type" varchar(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS bot_schema.user_status  (
  "status_id" int PRIMARY KEY NOT NULL,
  "user_id" int NOT NULL,
  "status_text" varchar(150),
  "status_created_at" timestamp NOT NULL
);

CREATE TABLE IF NOT EXISTS bot_schema.channel_message (
  "channel_message_id" int PRIMARY KEY NOT NULL,
  "channel_id" int NOT NULL,
  "user_id" int NOT NULL,
  "message_content" text NOT NULL,
  "sent_at" timestamp NOT NULL
);

CREATE TABLE IF NOT EXISTS bot_schema.group_message (
  "group_message_id" int PRIMARY KEY NOT NULL,
  "group_id" int NOT NULL,
  "user_id" int NOT NULL,
  "message_content" text NOT NULL,
  "sent_at" timestamp NOT NULL
);

CREATE TABLE IF NOT EXISTS bot_schema.user_setting (
  "setting_id" int PRIMARY KEY NOT NULL,
  "user_id" int NOT NULL,
  "setting_key" varchar(50) NOT NULL,
  "setting_value" varchar(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS bot_schema.channel (
  "channel_id" int PRIMARY KEY NOT NULL,
  "channel_name" varchar(100) NOT NULL,
  "creator_user_id" int NOT NULL,
  "created_at" timestamp NOT NULL,
  "channel_description" text
);

CREATE TABLE IF NOT EXISTS bot_schema.group (
  "group_id" int PRIMARY KEY NOT NULL,
  "group_name" varchar(100) NOT NULL,
  "creator_user_id" int NOT NULL,
  "created_at" timestamp NOT NULL,
  "group_description" text
);

CREATE TABLE IF NOT EXISTS bot_schema.device (
  "device_id" int PRIMARY KEY NOT NULL,
  "user_id" int NOT NULL,
  "device_name" varchar(100) NOT NULL,
  "device_type" varchar(50) NOT NULL,
  "last_active" timestamp NOT NULL
);

CREATE TABLE IF NOT EXISTS bot_schema.poll (
  "poll_id" int PRIMARY KEY NOT NULL,
  "chat_id" int NOT NULL,
  "question" text NOT NULL,
  "created_at" timestamp NOT NULL,
  "expires_at" timestamp
);

CREATE TABLE IF NOT EXISTS bot_schema.channel_member (
  "channel_id" int NOT NULL,
  "user_id" int NOT NULL,
  "joined_at" timestamp NOT NULL
);

CREATE TABLE IF NOT EXISTS bot_schema.banned_user (
  "ban_id" int PRIMARY KEY NOT NULL,
  "user_id" int NOT NULL,
  "banned_at" timestamp NOT NULL,
  "unban_at" timestamp,
  "reason" text
);

CREATE TABLE IF NOT EXISTS bot_schema.poll_option (
  "option_id" int PRIMARY KEY NOT NULL,
  "poll_id" int NOT NULL,
  "option_text" varchar(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS bot_schema.bot_command (
  "bot_command_id" int PRIMARY KEY NOT NULL,
  "bot_id" int NOT NULL,
  "command" varchar(50) NOT NULL,
  "response" text NOT NULL,
  "created_at" timestamp NOT NULL
);

CREATE TABLE IF NOT EXISTS bot_schema.poll_vote (
  "poll_vote_id" int PRIMARY KEY NOT NULL,
  "poll_id" int NOT NULL,
  "option_id" int NOT NULL,
  "user_id" int NOT NULL,
  "voted_at" timestamp NOT NULL
);

CREATE TABLE IF NOT EXISTS bot_schema.admin (
  "admin_id" int PRIMARY KEY NOT NULL,
  "user_id" int NOT NULL,
  "role_id" int NOT NULL,
  "assigned_at" timestamp NOT NULL
);

CREATE TABLE IF NOT EXISTS bot_schema.user_role (
  "user_role_id" int PRIMARY KEY NOT NULL,
  "user_id" int NOT NULL,
  "role_id" int NOT NULL,
  "assigned_at" timestamp NOT NULL
);

CREATE TABLE IF NOT EXISTS bot_schema.role (
  "role_id" int PRIMARY KEY NOT NULL,
  "role_name" varchar(50) NOT NULL,
  "role_description" text
);

CREATE TABLE IF NOT EXISTS bot_schema.payment (
  "payment_id" int PRIMARY KEY NOT NULL,
  "user_id" int NOT NULL,
  "amount" numeric(10, 2) NOT NULL,
  "payment_method" varchar(50) NOT NULL,
  "payment_date" timestamp NOT NULL
);

CREATE TABLE IF NOT EXISTS bot_schema.group_member (
  "group_id" int NOT NULL,
  "user_id" int NOT NULL,
  "joined_at" timestamp NOT NULL
);

CREATE TABLE IF NOT EXISTS bot_schema.attachment (
  "attachment_id" int PRIMARY KEY NOT NULL,
  "message_id" int NOT NULL,
  "file_path" varchar(255) NOT NULL,
  "file_type" varchar(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS bot_schema.call (
  "call_id" int PRIMARY KEY NOT NULL,
  "caller_user_id" int NOT NULL,
  "receiver_user_id" int NOT NULL,
  "started_at" timestamp NOT NULL,
  "ended_at" timestamp,
  "call_type" varchar(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS bot_schema.user_invitation (
  "invitation_id" int PRIMARY KEY NOT NULL,
  "inviter_user_id" int NOT NULL,
  "invited_user_id" int NOT NULL,
  "invited_at" timestamp NOT NULL
);

CREATE TABLE IF NOT EXISTS bot_schema.sticker (
  "sticker_id" int PRIMARY KEY NOT NULL,
  "sticker_name" varchar(50) NOT NULL,
  "file_path" varchar(255) NOT NULL,
  "created_by_user_id" int NOT NULL,
  "created_at" timestamp NOT NULL
);

CREATE TABLE IF NOT EXISTS bot_schema.session (
  "session_id" int PRIMARY KEY NOT NULL,
  "user_id" int NOT NULL,
  "ip_address" varchar(45) NOT NULL,
  "login_at" timestamp NOT NULL,
  "logout_at" timestamp
);

CREATE TABLE IF NOT EXISTS bot_schema.user (
  "user_id" int PRIMARY KEY NOT NULL,
  "username" varchar(50) NOT NULL,
  "phone_number" varchar(15) NOT NULL,
  "email" varchar(100),
  "password_hash" char(64) NOT NULL,
  "last_seen" timestamp NOT NULL
);

CREATE TABLE IF NOT EXISTS bot_schema.message (
  "message_id" int PRIMARY KEY NOT NULL,
  "chat_id" int NOT NULL,
  "user_id" int NOT NULL,
  "message_content" text NOT NULL,
  "sent_at" timestamp NOT NULL,
  "edited_at" timestamp
);

ALTER TABLE bot_schema.channel ADD FOREIGN KEY ("creator_user_id") REFERENCES bot_schema.user ("user_id");

ALTER TABLE bot_schema.poll_vote ADD FOREIGN KEY ("poll_id") REFERENCES bot_schema.poll ("poll_id");

ALTER TABLE bot_schema.channel_message ADD FOREIGN KEY ("channel_id") REFERENCES bot_schema.channel ("channel_id");

ALTER TABLE bot_schema.device ADD FOREIGN KEY ("user_id") REFERENCES bot_schema.user ("user_id");

ALTER TABLE bot_schema.bot_command ADD FOREIGN KEY ("bot_id") REFERENCES bot_schema.bot ("bot_id");

ALTER TABLE bot_schema.group_member ADD FOREIGN KEY ("group_id") REFERENCES bot_schema.group ("group_id");

ALTER TABLE bot_schema.call ADD FOREIGN KEY ("caller_user_id") REFERENCES bot_schema.user ("user_id");

ALTER TABLE bot_schema.group_message ADD FOREIGN KEY ("user_id") REFERENCES bot_schema.user ("user_id");

ALTER TABLE bot_schema.poll_vote ADD FOREIGN KEY ("user_id") REFERENCES bot_schema.user ("user_id");

ALTER TABLE bot_schema.reaction ADD FOREIGN KEY ("user_id") REFERENCES bot_schema.user ("user_id");

ALTER TABLE bot_schema.channel_member ADD FOREIGN KEY ("user_id") REFERENCES bot_schema.user ("user_id");

ALTER TABLE bot_schema.user_role ADD FOREIGN KEY ("user_id") REFERENCES bot_schema.user ("user_id");

ALTER TABLE bot_schema.channel_message ADD FOREIGN KEY ("user_id") REFERENCES bot_schema.user ("user_id");

ALTER TABLE bot_schema.user_invitation ADD FOREIGN KEY ("invited_user_id") REFERENCES bot_schema.user ("user_id");

ALTER TABLE bot_schema.poll_vote ADD FOREIGN KEY ("option_id") REFERENCES bot_schema.poll_option ("option_id");

ALTER TABLE bot_schema.user_role ADD FOREIGN KEY ("role_id") REFERENCES bot_schema.role ("role_id");

ALTER TABLE bot_schema.banned_user ADD FOREIGN KEY ("user_id") REFERENCES bot_schema.user ("user_id");

ALTER TABLE bot_schema.call ADD FOREIGN KEY ("receiver_user_id") REFERENCES bot_schema.user ("user_id");

ALTER TABLE bot_schema.admin ADD FOREIGN KEY ("role_id") REFERENCES bot_schema.role ("role_id");

ALTER TABLE bot_schema.attachment ADD FOREIGN KEY ("message_id") REFERENCES bot_schema.message ("message_id");

ALTER TABLE bot_schema.payment ADD FOREIGN KEY ("user_id") REFERENCES bot_schema.user ("user_id");

ALTER TABLE bot_schema.subscription ADD FOREIGN KEY ("user_id") REFERENCES bot_schema.user ("user_id");

ALTER TABLE bot_schema.group ADD FOREIGN KEY ("creator_user_id") REFERENCES bot_schema.user ("user_id");

ALTER TABLE bot_schema.admin ADD FOREIGN KEY ("user_id") REFERENCES bot_schema.user ("user_id");

ALTER TABLE bot_schema.message ADD FOREIGN KEY ("chat_id") REFERENCES bot_schema.chat ("chat_id");

ALTER TABLE bot_schema.sticker ADD FOREIGN KEY ("created_by_user_id") REFERENCES bot_schema.user ("user_id");

ALTER TABLE bot_schema.bot ADD FOREIGN KEY ("creator_user_id") REFERENCES bot_schema.user ("user_id");

ALTER TABLE bot_schema.group_message ADD FOREIGN KEY ("group_id") REFERENCES bot_schema.group ("group_id");

ALTER TABLE bot_schema.user_status ADD FOREIGN KEY ("user_id") REFERENCES bot_schema.user ("user_id");

ALTER TABLE bot_schema.notification ADD FOREIGN KEY ("user_id") REFERENCES bot_schema.user ("user_id");

ALTER TABLE bot_schema.poll_option ADD FOREIGN KEY ("poll_id") REFERENCES bot_schema.poll ("poll_id");

ALTER TABLE bot_schema.contact ADD FOREIGN KEY ("user_id") REFERENCES bot_schema.user ("user_id");

ALTER TABLE bot_schema.user_setting ADD FOREIGN KEY ("user_id") REFERENCES bot_schema.user ("user_id");

ALTER TABLE bot_schema.message ADD FOREIGN KEY ("user_id") REFERENCES bot_schema.user ("user_id");

ALTER TABLE bot_schema.channel_member ADD FOREIGN KEY ("channel_id") REFERENCES bot_schema.channel ("channel_id");

ALTER TABLE bot_schema.group_member ADD FOREIGN KEY ("user_id") REFERENCES bot_schema.user ("user_id");

ALTER TABLE bot_schema.reaction ADD FOREIGN KEY ("message_id") REFERENCES bot_schema.message ("message_id");

ALTER TABLE bot_schema.poll ADD FOREIGN KEY ("chat_id") REFERENCES bot_schema.chat ("chat_id");

ALTER TABLE bot_schema.session ADD FOREIGN KEY ("user_id") REFERENCES bot_schema.user ("user_id");
