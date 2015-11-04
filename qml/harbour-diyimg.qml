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
import "pages"
import io.thp.pyotherside 1.3
import org.nemomobile.notifications 1.0
ApplicationWindow
{
    id:window
    property real currentnum:1.0
    property string currentUrl
    allowedOrientations: Orientation.All
    initialPage: Component { FirstPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")

    Notification{
        id:notification
    }
    //Component.onDestroyed: imgpy.clean()
    function showMsg(message) {
        notification.previewBody = qsTr("DiyIMG");
        notification.previewSummary = message;
        notification.close();
        notification.publish();
    }

    function getNowFormatDate() {
        var date = new Date();
        var seperator1 = "-";
        var seperator2 = ":";
        var month = date.getMonth() + 1;
        var strDate = date.getDate();
        if (month >= 1 && month <= 9) {
            month = "0" + month;
        }
        if (strDate >= 0 && strDate <= 9) {
            strDate = "0" + strDate;
        }
        var currentdate = "DiyImg-"+date.getFullYear() + seperator1 + month + seperator1 + strDate
                + "--" + date.getHours() + seperator2 + date.getMinutes()
                + seperator2 + date.getSeconds();
        return currentdate;
    }

    Python{
        id:imgpy
        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('./py')); // adds import path to the directory of the Python script
            imgpy.importModule('myimage', function () { // imports the Python module
            });
        }
        function parse(url,num,type){
            call('myimage.parseImg',[url,num,type],function(result){
            })
        }
        function save(cachepath,savename){
            call('myimage.saveImg',[cachepath,savename],function(result){
            })
        }
        function clean(){
            call('myimage.cleanImg',[],function(result){})
        }

        onReceived:{
            //console.log(data.toString())
            if(data.toString() == "saved"){
                showMsg(qsTr("saved"))
            }else if(data.toString() == "error"){
                showMsg(qsTr("error"))
            }else{

                currentUrl ="";
                var newpath = data.toString();
                if(newpath.substring(0,4) == "file"){
                    newpath = newpath.substring(7,newpath.length)
                }
                currentUrl = newpath;
            }
        }
    }
}


