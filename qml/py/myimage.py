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
import io
import shutil


#高斯模糊类
class MyGaussianBlur(ImageFilter.Filter):
    name = "GaussianBlur"
    def __init__(self, radius=40, bounds=None):
        self.radius = radius
        self.bounds = bounds


    def filter(self, image):
        if self.bounds:
            Utils.log(str(self.bounds))
            clips = image.crop(self.bounds)
            im = clips.filter(ImageFilter.GaussianBlur(self.radius))
#            tmp_im = io.BytesIO()
#            im.convert('RGB').save(tmp_im,format='PNG')
#            tmp_im.seek(0)
#            image.paste(Image.open(tmp_im), box = self.bounds)
            image.paste(im, box = self.bounds)
#            del tmp_im
            return image
        else:
            return image.filter(ImageFilter.GaussianBlur(self.radius))

class ImgHandler:
    def __init__(self):
        self.tmp_img = io.BytesIO()
        self.savePath = "%s/%s" % (HOME, "Pictures/DiyIMG" )
        self.isExis()

    def isExis(self):
        if not os.path.exists(self.savePath):
            os.makedirs(self.savePath)

    def cleanImg(self):
        self.tmp_img = io.BytesIO()

    def saveImg(self, savename):
        Utils.loading("true")
        try:
#            Utils.log("imgByteArr length:")
#            Utils.log(self.tmp_img.getbuffer().nbytes)
            self.tmp_img.seek(0)
            with open("%s/%s" % (self.savePath, savename),'wb') as out:
#                out.write(self.tmp_img.read())
                shutil.copyfileobj(self.tmp_img, out, length=131072)

            Utils.tips("saved")
        except Exception as e:
            Utils.log(traceback.format_exc())
            Utils.error(e.args[0])
        finally:
            Utils.loading("false")


    #亮度增强(adjust image brightness)
    def bright(self, img, num):
        brightness = ImageEnhance.Brightness(img) #调用Brightness类
        return brightness.enhance(num)

    #图像尖锐化(adjust image sharpness)
    def sharp(self, img,num):
        sharpness = ImageEnhance.Sharpness(img) #调用Sharpness类
        return sharpness.enhance(num)

    #对比度增强(adjust image contrast)
    def contrast(self, img,num):
        contrast = ImageEnhance.Contrast(img)
        return contrast.enhance(num)

    #同样色彩增强(adjust image color）
    def color(self, img,num):
        color = ImageEnhance.Color(img)
        return color.enhance(num)

    #局部模糊
    def gaussianblur(self, img, bounds):
        myblur = MyGaussianBlur(radius=40, bounds=bounds)
        return myblur.filter(img)

    def image_provider(self, image_id, requested_size):
        Utils.loading("true")
        ptype, pnum, filepath = image_id.split("___")
        try:
            image_id = filepath.replace("file://","")
            img = Image.open(filepath)
            width, height = img.size
            imgByteArr = io.BytesIO()
            if ptype == "null" or pnum == "-1":
                roiImg = img
            elif ptype == "blur":
                if self.tmp_img.getbuffer().nbytes > 0:
                    # use prev operator
                    Utils.log("use prev cached img")
                    self.tmp_img.seek(0)
                    img = Image.open(self.tmp_img)
                bounds = [int(x) for x in pnum.split(",")]
                roiImg = self.gaussianblur(img, bounds)
            else:
                num = float(pnum)
                if ptype == "bright":
                    roiImg = self.bright(img,num)
                if ptype == "sharp":
                    roiImg = self.sharp(img,num)
                if ptype == "contrast":
                    roiImg = self.contrast(img,num)
                if ptype == "color":
                    roiImg = self.color(img,num)
            roiImg.save(imgByteArr, format='PNG')
            self.tmp_img = imgByteArr
            del roiImg
            Utils.loading("false")
            return bytearray(imgByteArr.getvalue()), (width, height), pyotherside.format_data

        except Exception as e:
            Utils.log(traceback.format_exc())
            Utils.error(e.args[0])
        finally:
            Utils.loading("false")


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
    def loading(str):
        """
        Send if progress is doing
        """
        Utils.send("loading", str)

    @staticmethod
    def send(event, msg=None):
        """
        Send data to QML
        """

        pyotherside.send(event, msg)
        
utils = Utils()
imghaldler = ImgHandler()

pyotherside.set_image_provider(imghaldler.image_provider)
