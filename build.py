import os
from subprocess import *
from git import Repo
from datetime import datetime
from shutil import *

from telethon import TelegramClient, events, sync
from telethon.sessions import StringSession
from dotenv import load_dotenv

# Set environmental variables
load_dotenv("env")

# Set Additional variables
now = datetime.now().strftime("%d%m%Y-%M")
zip_name = "Triton-Storm-Rova-" + now
k_out = "out/arch/arm64/boot/Image.gz-dtb"
anyk_repo_link = "https://github.com/Thagoo/AnyKernel3"
API_ID = os.environ.get('API_ID')
API_HASH = os.environ.get('API_HASH')
STRING_SESSION = os.environ.get('STRING_SESSION')
CHANNEL_ID = os.environ.get('CHANNEL_ID')
client = TelegramClient(StringSession(STRING_SESSION), API_ID, API_HASH)
client.start()

def Get_AnyK():
    """ Clone AnyKernel repo from git"""
    Repo.clone_from(anyk_repo_link, "AnyKernel3")
    rmtree("AnyKernel3/.git")

def Cp_Ul():
    """ Copy build output, archive and upload to TG """
    copy(k_out, "AnyKernel3")
    call('cd AnyKernel3;zip temp.zip * -r9;mv temp.zip ..', shell=True)
    os.rename('temp.zip', zip_name+'.zip')
    # Upload file to Telegram
    client.send_file(CHANNEL_ID, file=zip_name+'.zip', caption="Triton kernel for rolex or riva \nfollow @tboxxx for more updates", force_document=True)
    print("Compilation Successfull \n" + zip_name)
    
def Build():
    """ Compilation """
    print("Compiling Triton kernel")
    Get_AnyK()
    os.environ['KBUILD_BUILD_USER'] = "Thago"
    os.environ['KBUILD_BUILD_HOST'] = "DroneCI"
    path= os.environ['PATH']
    os.environ['PATH'] = "/tmp/proton/bin:"+path
    call('make O=out ARCH=arm64 rova_defconfig; make -j32 O=out \ ARCH=arm64 \ CC=clang \ CROSS_COMPILE=aarch64-linux-gnu- \ CROSS_COMPILE_ARM32=arm-linux-gnueabi- \ AR=llvm-ar \ NM=llvm-nm', shell=True)
    
    if not os.path.exists(k_out):
        print('Compilation error')
        # Send a message to TG about error and exit
        client.send_message(CHANNEL_ID, 'Build stopped Compilation Error')
        exit()
    else:
        Cp_Ul()

if __name__ == "__main__":
    Build()
