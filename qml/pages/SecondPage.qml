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
import io.thp.pyotherside 1.5

Page {
    id: parseImg
    property string url
    property int currentindex: 0
    property string ptype: "null"
    property string pnum: "-1"

    SilicaFlickable{
        id: flickable
        anchors.fill: parent
        contentHeight: column.height + extraCol.height

        function parse(num){
            // [qsTr("Sharp"), qsTr("Color"),qsTr("Bright"),qsTr("Contrast"),qsTr("Blur")]
            pnum = num.toString();
            switch(currentindex){
            case 0:
                ptype = "sharp";
                break;
            case 1:
                ptype = "color";
                break;
            case 2:
                ptype = "bright";
                break;
            case 3:
                ptype = "contrast"
                break;
            case 4:
                ptype = "blur"
                break;
            default:
                ptype = "null"
                pnum = "-1"
                break;
            }
            handleUrl()
        }

        function handleUrl(){
            imgpage.localUrl = "image://python/" + ptype + "___" + pnum + "___" + url
        }

        Column{
            id: column
            spacing: Theme.paddingSmall
            width: parent.width
            PageHeader{
                id:header
                //title:qsTr("Parse Img")
            }
            PullDownMenu{
                flickable:flickable
                MenuItem{
                    text: qsTr("Save")
                    enabled: !window.loading
                    onClicked: {
                        imgpy.save()
                    }
                }
                MenuItem{
                    text: qsTr("Reset")
                    visible: false
                    onClicked: {
                        ptype = "null"
                        pnum = "-1"
                        slider.value = 1
                        parseImg.handleUrl()
                    }
                }
            }


            ImagePage{
                id: imgpage
                localUrl: {
                    if(url.indexOf("file://") > -1){
                        return Qt.resolvedUrl(url.substring("file://".length))
                    }else{
                        return Qt.resolvedUrl(url)
                    }
                }
                height: Screen.height - header.height - extraCol.height
                anchors{
                    left:parent.left
                    right:parent.right
                    margins: Theme.paddingMedium
                }

                onPainted: {

                    if(!loading && currentindex == 4){
                        var num = parseInt(left)+ ","+ parseInt(upper)+ "," + parseInt(right) + "," + parseInt(lower);
                        flickable.parse(num);
                    }
                }
            }
        }

        Column{
            id: extraCol
            anchors{
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            Row{
                width: parent.width
                anchors{
                    left:parent.left
                    right:parent.right
                    margins: Theme.paddingSmall

                }
                Slider{
                    id:slider
                    value: 1
                    enabled: !window.loading && currentindex != 4
                    opacity: ( !window.loading && currentindex != 4 )? 1: 0.3
                    minimumValue:-2.0
                    maximumValue:4.0
                    stepSize: 0.2
                    valueText: value.toFixed(1)
                    width: parent.width// - iconBack.width - iconSave.width
                    onValueChanged: {
                        if(!loading){
                            flickable.parse(value.toFixed(1));
                        }
                    }
                }

                Image{
                    id: iconBack
                    source: "image://theme/icon-m-back"
                    anchors.verticalCenter: slider.verticalCenter
                    sourceSize.width: Theme.iconSizeMedium
                    sourceSize.height: Theme.iconSizeMedium
                    enabled: window.steps.length > 0
                    opacity: enabled?1:0.3
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            var prevStep = window.steps.pop();
                            pnum = prevStep.pnum;

                        }
                    }
                }

                Image{
                    id: iconSave
                    source: "image://theme/icon-m-clipboard"
                    anchors.verticalCenter: slider.verticalCenter
                    width: Theme.iconSizeMedium
                    height: Theme.iconSizeMedium
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            imgpy.save();
                        }
                    }
                }
            }

            Row{
                id: row
                width: parent.width
                y: Screen.height - viewIndicator.height
                Rectangle {
                    id: viewIndicator
                    anchors.top: parent.top
                    color: Theme.highlightColor
                    height: Theme.paddingSmall
                    width: parseImg.width / 4
                    x: currentindex * width
                    z: 2
                    Behavior on x {
                        NumberAnimation {
                            duration: 200
                        }
                    }
                }

//                Rectangle {
//                    anchors.top: parent.top
//                    color: "gray"
//                    opacity: 0.5
//                    height: Theme.paddingMedium
//                    width: parseImg.width
//                    z: 1
//                }

            }

            Row {
                id: tabHeader
                Repeater {
                    model: [qsTr("Sharp"), qsTr("Color"),qsTr("Bright"),qsTr("Contrast")/*,qsTr("Blur")*/]
                    Rectangle {
                        color: "black"
                        height: Theme.paddingLarge * 4
                        width: parseImg.width / 4
                        Label {
                            anchors.centerIn: parent
                            text: modelData
                            opacity: !window.loading ? 1: 0.4
                            color: Theme.highlightColor
                            font {
                                bold: true
                                pixelSize: Theme.fontSizeExtraSmall
                            }
                        }
                        MouseArea {
                            anchors.fill: parent
                            enabled: !window.loading
                            onClicked: {
                                var selectedIndex = parent.x/(parseImg.width / 4) /* === 0 ? 0 :(parent.x === 180?1:360)*/
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


    Component.onDestruction: {
        imgpy.clean()
    }

}

