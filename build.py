import os
from git import Repo
from datetime import datetime
from shutil import copyfile
import shutil

from telethon import TelegramClient, events, sync
from telethon.sessions import StringSession
from dotenv import load_dotenv
load_dotenv("env")

now = datetime.now().strftime("%H%M")
zip_name = "Triton-Storm-Rova-" + now
k_out = "out/arch/arm64/boot/Image.gz-dtb"

API_ID = os.environ.get('API_ID')
API_HASH = os.environ.get('API_HASH')
STRING_SESSION = os.environ.get('STRING_SESSION')
CHANNEL_ID = os.environ.get('CHANNEL_ID')
client = TelegramClient(StringSession(STRING_SESSION), API_ID, API_HASH)
client.start()

# Clone AnyKernel3 repo
Repo.clone_from("https://github.com/Thagoo/AnyKernel3", "AnyKernel3")

def build():
	os.environ['KBUILD_BUILD_USER'] = "Thago"
	os.environ['KBUILD_BUILD_HOST'] = "DroneCI"
	os.environ['PATH'] = "/tmp/proton/bin:$PATH"
	os.system("make O=out ARCH=arm64 rova_defconfig")           
	os.system("make -j$(nproc --all) O=out \
                      ARCH=arm64 \
                      CC=clang \
                      CROSS_COMPILE=aarch64-linux-gnu- \
                      CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
                      AR=llvm-ar \
                      NM=llvm-nm")
                      
    if not os.path.exists(k_out):
	client.send_message(CHANNEL_ID, 'Build stopped Compilation Error')
	exit()
	
	copyfile(k_out, "AnyKernel3")
shutil.make_archive(zip_name, 'zip', 'AnyKernel3')
client.send_file(CHANNEL_ID,file=zip_name+'.zip', caption="Triton kernel for rolex or riva \nfollow @tboxxx for more updates", force_document=True)
