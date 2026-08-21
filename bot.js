const TelegramBot = require('node-telegram-bot-api');
const fs = require('fs');

const TOKEN = "8854368089:AAGuSqO3TaPNTo1Ya6ojSf4YlNGQ71oiXM0";

const bot = new TelegramBot(TOKEN, { polling: true });

let list = [];

if (fs.existsSync("playlist.json")) {
  list = JSON.parse(fs.readFileSync("playlist.json"));
}

bot.on('message', (msg) => {
  if (msg.video) {
    list.push(msg.video.file_id);
    fs.writeFileSync("playlist.json", JSON.stringify(list, null, 2));
    console.log("video eklendi");
  }
});
