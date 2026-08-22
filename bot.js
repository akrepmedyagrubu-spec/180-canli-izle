import fs from "fs";
import TelegramBot from "node-telegram-bot-api";

const TOKEN = "8854368089:AAGuSqO3TaPNTo1Ya6ojSf4YlNGQ71oiXM0";
const CHANNEL = "@viodeu";

const bot = new TelegramBot(TOKEN, { polling: true });

const DB = "db.json";

function load() {
  if (!fs.existsSync(DB)) return [];
  return JSON.parse(fs.readFileSync(DB));
}

function save(data) {
  fs.writeFileSync(DB, JSON.stringify(data, null, 2));
}

// YENİ MESAJLAR
bot.on("channel_post", (msg) => {
  if (!msg.video) return;

  const list = load();

  list.push({
    file_id: msg.video.file_id,
    caption: msg.caption || ""
  });

  save(list);

  console.log("NEW VIDEO SAVED:", msg.video.file_id);
});

console.log("BOT AKTIF");
