import TelegramBot from 'node-telegram-bot-api';

const TOKEN = "8854368089:AAGuSqO3TaPNTo1Ya6ojSf4YlNGQ71oiXM0";
const bot = new TelegramBot(TOKEN, { polling: true });

console.log("BOT AKTİF");

bot.on('channel_post', (msg) => {
  if (!msg.video) return;

  const fileId = msg.video.file_id;

  console.log("FILE_ID:", fileId);
});
