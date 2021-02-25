import os
from subprocess import *
from git import Repo
from datetime import datetime
from shutil import *

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

# Clone AnyKernel3 repo
Repo.clone_from("https://github.com/Thagoo/AnyKernel3", "AnyKernel3")
rmtree("AnyKernel3/.git")

def build():
	os.environ['KBUILD_BUILD_USER'] = "Thago"
	os.environ['KBUILD_BUILD_HOST'] = "DroneCI"
	path= os.environ['PATH']
	os.environ['PATH'] = "/tmp/proton/bin:"+path
	call('make O=out ARCH=arm64 rova_defconfig; make -j32 O=out \ ARCH=arm64 \ CC=clang \ CROSS_COMPILE=aarch64-linux-gnu- \ CROSS_COMPILE_ARM32=arm-linux-gnueabi- \ AR=llvm-ar \ NM=llvm-nm', shell=True)

client.start()
build()
if not os.path.exists(k_out):
    client.send_message(CHANNEL_ID, 'Build stopped Compilation Error')
    exit()

copy(k_out, "AnyKernel3")
call('zip temp.zip AnyKernel3/* -r9', shell=True)
os.rename('temp.zip', zip_name+'.zip')
client.send_file(CHANNEL_ID,file=zip_name+'.zip', caption="Triton kernel for rolex or riva \nfollow @tboxxx for more updates", force_document=True)
