/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.3

Page {
    id: parseImg
    property string url
    property int currentindex: 0

    onCurrentindexChanged: {
        console.log("currentUrl:"+window.currentUrl)
        //window.currentUrl = url
        //window.currentnum = 1.0
        //slider.value = 1.0
        switch(currentindex){
        case 1:
            imgpy.parse(parseUrl(url),2.2,currentindex)
            break;
        case 2:
            imgpy.parse(parseUrl(url),1.8,currentindex)
            break;
        case 3:
            imgpy.parse(parseUrl(url),1.3,currentindex)
            break;
        case 4:
            imgpy.parse(parseUrl(url),"150,130,280,230",currentindex)
            break;
        default:
            break;
        }
//        if(currentindex == 4){//blur
//            slider.enabled = false
//            imgpy.parse(parseUrl(),"150,130,280,230",currentindex)
//        }else{
//            slider.enabled = true
//        }
    }

    function parseUrl(url){
        var pypath="";
        if(url.substring(0,4) == "file"){
            pypath=url.substring(7,url.length)
        }else{
            pypath=url;
        }
        return pypath;
    }

    SilicaFlickable{
        id:flickable
        anchors.fill: parent

        PageHeader{
            id:header
            //title:qsTr("Parse Img")
        }
        PullDownMenu{
            flickable:flickable
            MenuItem{
                text:qsTr("Save")
                onClicked:imgpy.save(window.currentUrl,getNowFormatDate())
            }
//            MenuItem{
//                text:qsTr("clear")
//                onClicked:resetSlider();
//            }
        }

        contentHeight: parent.height

        function resetSlider(){
            imgpage.localUrl = url;
            window.currentnum = 1.0
            //slider.value = 1.0
        }

        ImagePage{
            id:imgpage
            localUrl:currentUrl
            height: Screen.height - header.height - tabHeader.height - viewIndicator.height //- slider.height
            anchors{
                top:header.bottom
                left:parent.left
                right:parent.right
                margins: Theme.paddingMedium
            }
        }


//        Slider{
//            anchors{
//                top:imgpage.bottom
//                left:parent.left
//                right:parent.right

//            }
//            id:slider
//            value: window.currentnum
//            minimumValue:-1.0
//            maximumValue:3.0
//            stepSize: 0.2
//            valueText: value.toFixed(1)
//            width: parent.width - Theme.paddingMedium * 2
//            onValueChanged: {
//                imgpy.parse(parseUrl(),value.toFixed(1),currentindex)
//            }
//        }
//        Image{
//            id:recover
//            source:  "image://theme/icon-l-cancel"
//            fillMode: Image.PreserveAspectFit
//            width: Theme.iconSizeMedium
//            height: Theme.iconSizeMedium
//            anchors{
//                right:parent.right
//                rightMargin: Theme.paddingSmall
//                verticalCenter: slider.verticalCenter

//            }
//            MouseArea{
//                anchors.fill: parent
//                onClicked:resetSlider();

//            }
//        }

        Rectangle {
            id: viewIndicator
            anchors.top: imgpage.bottom
            color: Theme.highlightColor
            height: Theme.paddingSmall
            width: parseImg.width / 5
            x: currentindex * width
            z: 2

            Behavior on x {
                NumberAnimation {
                    duration: 200
                }
            }
        }

        Rectangle {
            anchors.top: imgpage.bottom
            color: "gray"
            opacity: 0.5
            height: Theme.paddingMedium
            width: parseImg.width
            z: 1
        }


        Row {
            id: tabHeader
            anchors.top: viewIndicator.bottom

            Repeater {
                model: [qsTr("Sharp"), qsTr("Color"),qsTr("Bright"),qsTr("Contrast"),qsTr("Blur")]
                Rectangle {
                    color: "black"
                    height: Theme.paddingLarge * 4
                    width: parseImg.width / 5

                    Label {
                        anchors.centerIn: parent
                        text: modelData
                        color: Theme.highlightColor
                        font {
                            bold: true
                            pixelSize: Theme.fontSizeExtraSmall
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            var selectedIndex = parent.x/(imgpage.width / 5) /* === 0 ? 0 :(parent.x === 180?1:360)*/
                            currentindex = selectedIndex;
                            //window.currentnum = 1.0;
                            //slider.value = 1.0
                        }
                    }
                }
            }
        }

    }



}

