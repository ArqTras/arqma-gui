// Copyright (c) 2018, The Arqma Network
// Copyright (c) 2014-2018, The Monero Project
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification, are
// permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice, this list of
//    conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright notice, this list
//    of conditions and the following disclaimer in the documentation and/or other
//    materials provided with the distribution.
//
// 3. Neither the name of the copyright holder nor the names of its contributors may be
//    used to endorse or promote products derived from this software without specific
//    prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
// THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Window 2.0

import ArqmaComponents.NetworkType 1.0
import "../components" as ArqmaComponents

Item {
    id: root
    visible: false
    z: parent.z + 2

    function open() {
        inactiveOverlay.visible = true // draw appwindow inactive
        leftPanel.enabled = false
        middlePanel.enabled = false
        titleBar.enabled = false
        show()
        root.visible = true;
    }

    function close() {
        inactiveOverlay.visible = false
        leftPanel.enabled = true
        middlePanel.enabled = true
        titleBar.enabled = true
        root.visible = false;
        closeCallback();
    }

    ColumnLayout {
        z: inactiveOverlay.z + 1
        id: mainLayout
        spacing: 10
        anchors { fill: parent; margins: 35 * scaleRatio }

        ColumnLayout {
            id: column

            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            Layout.maximumWidth: 400 * scaleRatio
            Layout.topMargin: inactiveOverlay.height * 0.35
            Layout.leftMargin: inactiveOverlay.width * 0.075

            Label {
                text: qsTr("Please choose how to connect to the Arq-Net Blockchain")
                anchors.left: parent.left
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 16 * scaleRatio
                font.family: ArqmaComponents.Style.fontLight.name
                color: ArqmaComponents.Style.defaultFontColor
            }

            RowLayout {
                id: buttons
                spacing: 16 * scaleRatio
                Layout.topMargin: 16

                ArqmaComponents.StandardButton {
                    id: remoteNodeButton
                    height: 48 * scaleRatio
                    //enabled: appWindow.getRemoteNodeList().length > 0
                    //text: appWindow.getRemoteNodeList().length > 0 ? qsTr("Use Remote Node\n(Recommended, fast but less private)") + translationManager.emptyString : qsTr("Use Remote Node\n    (No default nodes available)     ") + translationManager.emptyString
                    text: qsTr("Use Remote Node\n(Recommended, fast but less private)") + translationManager.emptyString
                    fontSize: 15 * scaleRatio
                    onClicked: {
                        var remoteNodeList = appWindow.getRemoteNodeList();
                        var random_index = Math.floor(Math.random() * Math.floor(remoteNodeList.length));
                        persistentSettings.remoteNodeAddress = remoteNodeList[random_index];
                        appWindow.connectRemoteNode()
                        root.close()
                    }
                }

                ArqmaComponents.StandardButton {
                    id: localNodeButton
                    height: 48 * scaleRatio
                    text: qsTr("Start Local Daemon\n(Downloads blockchain, slow but private)") + translationManager.emptyString
                    fontSize: 15 * scaleRatio
                    onClicked: {
                        appWindow.startDaemon(persistentSettings.daemonFlags)
                        root.close()
                    }
                }

                ArqmaComponents.StandardButton {
                    id: customSettingsButton
                    height: 48 * scaleRatio
                    text: qsTr("Use Custom Settings\n(Setup later in settings)") + translationManager.emptyString
                    fontSize: 15 * scaleRatio
                    onClicked: {
                        root.close()
                    }
                }
            }
        }

    }
}
