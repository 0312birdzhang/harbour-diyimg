import os,sys
import pyotherside
import random
import base64
import traceback
from PIL import Image
from PIL import ImageDraw
from PIL import ImageEnhance
from PIL import ImageFilter
from basedir import *
import imghdr
import hashlib
import math
import io


tmp_img = io.BytesIO()
savePath = "%s/%s" % (HOME, "Pictures/save/diyimg/" )

def isExis():
    if not os.path.exists(savePath):
        os.makedirs(savePath)

def saveImg(savename):
    isExis()
    try:
        image.save("%s/%s" % (savePath, savename))
        with open("%s/%s" % (savePath, savename),'wb') as out:
            out.write(tmp_img.read())
        Utils.tips("saved")
    except Exception as e:
        Utils.log(traceback.format_exc())
        Utils.error(e.args[0])


#亮度增强(adjust image brightness)
def bright(img,num):
    brightness = ImageEnhance.Brightness(img) #调用Brightness类
    return brightness.enhance(num)

#图像尖锐化(adjust image sharpness)
def sharp(img,num):
    sharpness = ImageEnhance.Sharpness(img) #调用Sharpness类
    return sharpness.enhance(num)

#对比度增强(adjust image contrast)
def contrast(img,num):
    contrast = ImageEnhance.Contrast(img)
    return contrast.enhance(num)

#同样色彩增强(adjust image color）
def color(img,num):
    color = ImageEnhance.Color(img)
    return color.enhance(num)

#局部模糊
def gaussianblur(img,left,upper,right,lower):
    bounds = (left,upper,right,lower)
    return img.filter(MyGaussianBlur(radius=29, bounds=bounds))

def image_provider(image_id, requested_size):
    ptype, pnum, filepath = image_id.split("___")
    try:
#        Utils.log("triggered")
#        Utils.log(filepath)
        image_id = filepath.replace("file://","")
        img = Image.open(filepath)
        width, height = img.size
#        Utils.log("img size: %s,%s" % (width, height))
        imgByteArr = io.BytesIO()
        if ptype == "null" or pnum == "-1":
            roiImg = img
        elif ptype == "blur":
            left,upper,right,lower = pnum.split(",")
            roiImg = gaussianblur(img,int(left),int(upper),int(right),int(lower))
        else:
            num = float(pnum)
            if ptype == "bright":
                roiImg = bright(img,num)
            if ptype == "sharp":
                roiImg = sharp(img,num)
            if ptype == "contrast":
                roiImg = contrast(img,num)
            if ptype == "color":
                roiImg = color(img,num)
        roiImg.save(imgByteArr, format='PNG')
        tmp_img = imgByteArr
        return bytearray(imgByteArr.getvalue()), (width, height), pyotherside.format_data

    except Exception as e:
        Utils.log(traceback.format_exc())
        Utils.error(e.args[0])


class Utils:
    def __init__(self):
        pass

    @staticmethod
    def log(str):
        """
        Print log to console
        """

        Utils.send('log', str)

    @staticmethod
    def error(str):
        """
        Send error string to QML to show on banner
        """

        Utils.send('error', str)

    @staticmethod
    def tips(str):
        """
        Send tips message
        """
        Utils.send("tips", str)

    @staticmethod
    def send(event, msg=None):
        """
        Send data to QML
        """

        pyotherside.send(event, msg)
        
utils = Utils()
#initPath()

pyotherside.set_image_provider(image_provider)
