import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.6
Page{
    id:cameraPage
    property bool flashopen:false
    Item {
        anchors.fill: parent
        width: Screen.width
        height: Screen.height

        Camera {
            id: camera

            flash.mode:flashopen?Camera.FlashOn:Camera.FlashOff

            imageCapture {
                onImageCaptured: {
                    // Show the preview in an Image
                    photoPreview.source = preview
                }
                onImageSaved: {
                    window.currentUrl = path;
                    window.pageStack.replace(Qt.resolvedUrl("SecondPage.qml"),
                                                 { "url": path} );

                }
                onCaptureFailed:{
                    window.showMsg(message);
                    window.pageStack.pop();
                    PageStack.pop(undefined,PageStackAction.Immediate);
                }
            }
            focus {
                focusMode: Camera.FocusAuto
                //focusPointMode: Camera.FocusPointCustom
                //customFocusPoint: Qt.point(0.2, 0.2) // Focus relative to top-left corner
            }
        }

        VideoOutput {
            source: camera
            focus : visible // to receive focus and capture key events when visible
            anchors.fill: parent
            Image{
                anchors{
                    right:parent.right
                    bottom:parent.bottom
                    bottomMargin: Theme.paddingLarge * 3
                    rightMargin: Theme.paddingLarge * 2
                }
                source:flashopen?"/usr/share/themes/base/meegotouch/icons/icon-m-camera-flash-always-screen.svg":
                                  "/usr/share/themes/base/meegotouch/icons/icon-m-camera-flash-off-screen.svg"
                width: Theme.iconSizeMedium
                height:Theme.iconSizeMedium
                MouseArea {
                    anchors.fill: parent;
                    onClicked: flashopen=flashopen?false:true
                }
            }

            Image{
                id:takpic
                source:  "/usr/share/themes/base/meegotouch/icons/icon-m-viewfinder-camera.svg"
                fillMode: Image.PreserveAspectFit
                width: Theme.iconSizeLarge
                height: Theme.iconSizeLarge
                anchors{
                    bottom:parent.bottom
                    bottomMargin: Theme.paddingLarge * 2
                    horizontalCenter: parent.horizontalCenter
                }

                MouseArea {
                    anchors.fill: parent;
                    onClicked: camera.imageCapture.capture();
                }
            }
        }

        Image {
            id: photoPreview
        }
    }
}
