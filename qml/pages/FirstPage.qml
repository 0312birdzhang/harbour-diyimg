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


Page {
    id: page

    SilicaFlickable {
        anchors.fill: parent


        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(aboutPage)
            }
        }
        contentHeight: column.height


        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge * 3
            PageHeader {
                title: qsTr("DiyIMG")
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Button{
                id:openLabel
                text:qsTr("Open a image")
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: pageStack.push(Qt.resolvedUrl("PreviewGrid.qml"));

            }
            Button{
                id:takeLaebl
                text:qsTr("Take a photo")
                anchors.horizontalCenter: parent.horizontalCenter
                 onClicked: pageStack.push(Qt.resolvedUrl("CameraPage.qml"));
            }

        }
    }

    Page{
        id:aboutPage
        SilicaFlickable {
                id: about
                anchors.fill: parent
                contentHeight: aboutRectangle.height

                VerticalScrollDecorator { flickable: about }

                Column {
                    id: aboutRectangle
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width
                    spacing: Theme.paddingSmall

                    PageHeader {
                        //: headline of application information page
                        title: qsTr("About")
                    }

                    Image{
                        source: "image://theme/harbour-diyimg"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    SectionHeader {
                        //: headline for application description
                        text: qsTr("Description")
                    }

                    Label {
                        //: application description
                        textFormat: Text.RichText;
                        text: qsTr('This software is base on python PIL module,'+
                              "If you have any good idea, please contact me.") +
                              qsTr("My email:") + "0312birdzhang@gmail.com<br/>"
                        width: parent.width - Theme.paddingLarge * 2
                        anchors.horizontalCenter: parent.horizontalCenter
                        wrapMode: Text.WordWrap
                        font.pixelSize: Theme.fontSizeSmall
                    }

                    SectionHeader {
                        text: qsTr("License")
                    }

                    Label {
                        text: qsTr("Copyright © by") + " 0312birzhang"
                        width: parent.width - Theme.paddingLarge * 2
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: Theme.fontSizeSmall
                    }
                    Label {
                        text: qsTr("License") + ": GPL v2"
                        width: parent.width - Theme.paddingLarge * 2
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: Theme.fontSizeSmall
                    }

                    SectionHeader {
                        //: headline for application project information
                        text: qsTr("Source code")
                        font.pixelSize: Theme.fontSizeSmall
                    }

                    Label {
                        textFormat: Text.RichText;
                        text: "<style>a:link { color: " + Theme.highlightColor + "; }</style><a href=\"https://github.com/0312birdzhang/harbour-diyimg\">https://github.com/0312birdzhang/harbour-diyimg\</a>"
                        width: parent.width - Theme.paddingLarge * 2
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: Theme.fontSizeTiny

                        onLinkActivated: {
                            Qt.openUrlExternally(link)
                        }
                    }

                }
            }
    }
}


