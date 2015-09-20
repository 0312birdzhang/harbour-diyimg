import os,sys,shutil
import pyotherside
import subprocess
import random
from PIL import Image
from PIL import ImageDraw
from PIL import ImageEnhance
from basedir import *
import imghdr
import hashlib
cachePath=XDG_CACHE_HOME+"/harbour-diyimg/diyimg/"
savePath=HOME+"/Pictures/save/diyimg/"

def saveImg(cachePath,savename):
    try:
        realpath=cachePath
        isExis()
        shutil.copy(realpath,savePath+savename+"."+findImgType(realpath))
        pyotherside.send("saved")
    except:
        pyotherside.send("error")
        pass

def isExis():
    if os.path.exists(savePath):
        pass
    else:
        os.makedirs(savePath)

def initPath():
    if not os.path.exists(savePath):
        os.makedirs(savePath)
    if not os.path.exists(cachePath):
        os.makedirs(cachePath)
"""
    缓存图片
"""
def cacheImg(url,md5name,imgtype):
    cachedFile = cachePath+md5name+"."+imgtype
    if os.path.exists(cachedFile):
        pass
    else:
        if os.path.exists(cachePath):
            pass
        else:
            os.makedirs(cachePath)
        downloadImg(cachedFile,url)
    return cachedFile

#处理图片

"""
    圆角
"""
def circle_img(cachedFile):
    ima = Image.open(cachedFile).convert("RGBA")
    size = ima.size
    r2 = min(size[0], size[1])
    if size[0] != size[1]:
        ima = ima.resize((r2, r2), Image.ANTIALIAS)
    circle = Image.new('L', (r2, r2), 0)
    draw = ImageDraw.Draw(circle)
    draw.ellipse((0, 0, r2, r2), fill=255)
    alpha = Image.new('L', (r2, r2), 255)
    alpha.paste(circle, (0, 0))
    ima.putalpha(alpha)
    ima.save(cachedFile)

#判断图片格式
def findImgType(cachedFile):
    imgType = imghdr.what(cachedFile)
    return imgType



#亮度增强(adjust image brightness)
def bright(img,imgpath,num):
    brightness = ImageEnhance.Brightness(img) #调用Brightness类
    bright_img = brightness.enhance(num)
    bright_img.save(imgpath)

#图像尖锐化(adjust image sharpness)
def sharp(img,imgpath,num):
    sharpness = ImageEnhance.Sharpness(img) #调用Sharpness类
    sharp_img = sharpness.enhance(num)
    sharp_img.save(imgpath)

#对比度增强(adjust image contrast)
def contrast(img,imgpath,num):
    contrast = ImageEnhance.Contrast(img)
    contrast_img = contrast.enhance(num)
    contrast_img.save(imgpath)

#同样色彩增强(adjust image color）
def color(img,imgpath,num):
    color = ImageEnhance.Color(img)
    color_img = color.enhance(num)
    color_img.save(imgpath)

#处理图片主类
#qsTr("Sharp"), qsTr("Color"),qsTr("Bright"),qsTr("Contrast")
def parseImg(path,num,type):
    initPath()
    if not os.path.exists(path):
        #pyotherside.send("status","not exist")
        return
    newpath =cachePath+md5(path.encode('utf-8'))+"."+findImgType(path)
    #if not os.path.exists(newpath):
    shutil.copy(path,newpath)
    num=float(num)
    img = Image.open(newpath)
    if type == 2:
        bright(img,newpath,num)
    if type == 0:
        sharp(img,newpath,num)
    if type == 3:
        contrast(img,newpath,num)
    if type == 1:
        color(img,newpath,num)

    pyotherside.send(newpath)

def md5(str):
    m = hashlib.md5()
    m.update(str)
    return m.hexdigest()
