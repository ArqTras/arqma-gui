// Copyright (c) 2014-2019, The Monero Project
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

import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.2
import QtQuick.Dialogs 1.2

import "../js/Wizard.js" as Wizard
import "../js/Windows.js" as Windows
import "../js/Utils.js" as Utils
import "../components" as ArqmaComponents
import "../pages"

Item {
    id: wizardController
    anchors.fill: parent

    signal useArqmaClicked()

    function restart() {
        // reset wizard state
        wizardStateView.state = "wizardHome"
        wizardController.walletOptionsName = defaultAccountName;
        wizardController.walletOptionsLocation = '';
        wizardController.walletOptionsPassword = '';
        wizardController.walletOptionsSeed = '';
        wizardController.walletOptionsBackup = '';
        wizardController.walletRestoreMode = 'seed';
        wizardController.walletOptionsRestoreHeight = 0;
        wizardController.walletOptionsIsRecovering = false;
        wizardController.walletOptionsIsRecoveringFromDevice = false;
        wizardController.walletOptionsDeviceName = '';
        wizardController.tmpWalletFilename = '';
        wizardController.walletRestoreMode = 'seed'
        wizardController.walletOptionsSubaddressLookahead = "";
    }

    property var m_wallet;
    property alias wizardState: wizardStateView.state
    property int wizardSubViewWidth: 780 * scaleRatio

    // wallet variables
    property string walletOptionsName: ''
    property string walletOptionsLocation: ''
    property string walletOptionsPassword: ''
    property string walletOptionsSeed: ''
    property string walletOptionsBackup: ''
    property int    walletOptionsRestoreHeight: 0
    property string walletOptionsBootstrapAddress: persistentSettings.bootstrapNodeAddress
    property bool   walletOptionsIsRecovering: false
    property bool   walletOptionsIsRecoveringFromDevice: false
    property string walletOptionsSubaddressLookahead: ''
    property string walletOptionsDeviceName: ''
    property string tmpWalletFilename: ''

    // language settings, updated via sidebar
    property string language_locale: 'en_US'
    property string language_wallet: 'English'
    property string language_language: 'English (US)'

    // recovery made (restore wallet)
    property string walletRestoreMode: 'seed'  // seed, keys, qr

    property int layoutScale: {
        if(isMobile){
            return 0;
        } else if(appWindow.width < 800){
            return 1;
        } else {
            return 2;
        }
    }

    Image {
        opacity: 1.0
        anchors.fill: parent
        source: "../images/middlePanelBg.jpg"
    }

    Rectangle {
        id: wizardStateView
        property Item currentView
        property Item previousView
        property WizardLanguage wizardLanguageView: WizardLanguage { }
        property WizardHome wizardHomeView: WizardHome { }
        property WizardCreateWallet1 wizardCreateWallet1View: WizardCreateWallet1 { }
        property WizardCreateWallet2 wizardCreateWallet2View: WizardCreateWallet2 { }
        property WizardCreateWallet3 wizardCreateWallet3View: WizardCreateWallet3 { }
        property WizardCreateWallet4 wizardCreateWallet4View: WizardCreateWallet4 { }
        property WizardRestoreWallet1 wizardRestoreWallet1View: WizardRestoreWallet1 { }
        property WizardRestoreWallet2 wizardRestoreWallet2View: WizardRestoreWallet2 { }
        property WizardRestoreWallet3 wizardRestoreWallet3View: WizardRestoreWallet3 { }
        property WizardRestoreWallet4 wizardRestoreWallet4View: WizardRestoreWallet4 { }
        property WizardCreateDevice1 wizardCreateDevice1View: WizardCreateDevice1 { }
        property WizardOpenWallet1 wizardOpenWallet1View: WizardOpenWallet1 { }
        anchors.fill: parent

        signal previousClicked;

        // Layout.preferredWidth: wizardController.width
        // Layout.preferredHeight: wizardController.height
        color: "transparent"
        state: ''

        onPreviousClicked: {
            if (previousView && previousView.viewName != null){
                state = previousView.viewName;
            } else {
                state = "wizardHome";
            }
        }

        onCurrentViewChanged: {
            if (previousView) {
               if (typeof previousView.onPageClosed === "function") {
                   previousView.onPageClosed();
               }
            }

            previousView = currentView;
            if (currentView) {
                stackView.replace(currentView)
                // Component.onCompleted is called before wallet is initilized
//                if (typeof currentView.onPageCompleted === "function") {
//                    currentView.onPageCompleted();
//                }
            }
        }

        states: [
            State {
                name: "wizardLanguage"
                PropertyChanges { target: wizardStateView; currentView: wizardStateView.wizardLanguageView }
            }, State {
                name: "wizardHome"
                PropertyChanges { target: wizardStateView; currentView: wizardStateView.wizardHomeView }
            }, State {
                name: "wizardCreateWallet1"
                PropertyChanges { target: wizardStateView; currentView: wizardStateView.wizardCreateWallet1View }
            }, State {
                name: "wizardCreateWallet2"
                PropertyChanges { target: wizardStateView; currentView: wizardStateView.wizardCreateWallet2View }
            }, State {
                name: "wizardCreateWallet3"
                PropertyChanges { target: wizardStateView; currentView: wizardStateView.wizardCreateWallet3View }
            }, State {
                name: "wizardCreateWallet4"
                PropertyChanges { target: wizardStateView; currentView: wizardStateView.wizardCreateWallet4View }
            }, State {
                name: "wizardRestoreWallet1"
                PropertyChanges { target: wizardStateView; currentView: wizardStateView.wizardRestoreWallet1View }
            }, State {
                name: "wizardRestoreWallet2"
                PropertyChanges { target: wizardStateView; currentView: wizardStateView.wizardRestoreWallet2View }
            }, State {
                name: "wizardRestoreWallet3"
                PropertyChanges { target: wizardStateView; currentView: wizardStateView.wizardRestoreWallet3View }
            }, State {
                name: "wizardRestoreWallet4"
                PropertyChanges { target: wizardStateView; currentView: wizardStateView.wizardRestoreWallet4View }
            }, State {
                name: "wizardCreateDevice1"
                PropertyChanges { target: wizardStateView; currentView: wizardStateView.wizardCreateDevice1View }
            }, State {
                name: "wizardOpenWallet1"
                PropertyChanges { target: wizardStateView; currentView: wizardStateView.wizardOpenWallet1View }
            }
        ]

        StackView {
            id: stackView
            initialItem: wizardStateView.wizardHomeView;
            anchors.fill: parent
            clip: false

            delegate: StackViewDelegate {
                pushTransition: StackViewTransition {
                    // PropertyAnimation {
                    //     target: enterItem
                    //     property: "x"
                    //     from: target.width
                    //     to: 0
                    //     duration: 300
                    //     easing.type: Easing.OutCubic
                    // }
                    // PropertyAnimation {
                    //     target: exitItem
                    //     property: "x"
                    //     from: 0
                    //     to: 0 - target.width
                    //     duration: 300
                    //     easing.type: Easing.OutCubic
                    // }
                }
            }
        }
	}

    //Open Wallet from file
    FileDialog {
        id: fileDialog
        title: qsTr("Please choose a file") + translationManager.emptyString
        folder: "file://" + ArqmaAccountsDir
        nameFilters: [ "Wallet files (*.keys)"]
        sidebarVisible: false

        onAccepted: {
            wizardController.openWalletFile(fileDialog.fileUrl);
        }
        onRejected: {
            console.log("Canceled")
            appWindow.rootItem.state = "wizard";
        }
    }

    function createWallet() {
        // Creates wallet in a temp. location

        // Always delete the wallet object before creating new - we could be stepping back from recovering wallet
        if (typeof wizardController.m_wallet !== 'undefined') {
            walletManager.closeWallet()
            console.log("deleting wallet")
        }

        var tmp_wallet_filename = oshelper.temporaryFilename();
        console.log("Creating temporary wallet", tmp_wallet_filename)
        var nettype = appWindow.persistentSettings.nettype;
        var kdfRounds = appWindow.persistentSettings.kdfRounds;
        var wallet = walletManager.createWallet(tmp_wallet_filename, "", wizardController.language_wallet, nettype, kdfRounds)

        wizardController.walletOptionsSeed = wallet.seed

        // saving wallet in "global" object
        // @TODO: wallet should have a property pointing to the file where it stored or loaded from
        wizardController.m_wallet = wallet;
        wizardController.tmpWalletFilename = tmp_wallet_filename
    }

    function writeWallet() {
        // Save wallet files in user specified location
        var new_wallet_filename = Wizard.createWalletPath(
            isIOS,
            wizardController.walletOptionsLocation,
            wizardController.walletOptionsName);

        if(isIOS) {
            console.log("saving in ios: " + ArqmaAccountsDir + new_wallet_filename)
            wizardController.m_wallet.store(ArqmaAccountsDir + new_wallet_filename);
        } else {
            console.log("saving in wizard: " + new_wallet_filename)
            wizardController.m_wallet.store(new_wallet_filename);
        }

        // make sure temporary wallet files are deleted
        console.log("Removing temporary wallet: " + wizardController.tmpWalletFilename)
        oshelper.removeTemporaryWallet(wizardController.tmpWalletFilename)

        // protecting wallet with password
        m_wallet.setPassword(walletOptionsPassword);

        // Store password in session to be able to use password protected functions (e.g show seed)
        appWindow.walletPassword = walletOptionsPassword

        // save to persistent settings
        persistentSettings.language = wizardController.language_language
        persistentSettings.locale   = wizardController.language_locale

        persistentSettings.account_name = wizardController.walletOptionsName
        persistentSettings.wallet_path = new_wallet_filename
        persistentSettings.restore_height = (isNaN(walletOptionsRestoreHeight))? 0 : walletOptionsRestoreHeight

        persistentSettings.allow_background_mining = false
        persistentSettings.is_recovering = (wizardController.walletOptionsIsRecovering === undefined) ? false : wizardController.walletOptionsIsRecovering
        persistentSettings.is_recovering_from_device = (wizardController.walletOptionsIsRecoveringFromDevice === undefined) ? false : wizardController.walletOptionsIsRecoveringFromDevice
    }

    function createWalletFromDevice() {
        // TODO: create wallet in temporary filename and a) move it to the path specified by user after the final
        // page submitted or b) delete it when program closed before reaching final page

        // Always delete the wallet object before creating new - we could be stepping back from recovering wallet
        if (typeof wizardController.m_wallet !== 'undefined') {
            walletManager.closeWallet()
            console.log("deleting wallet")
        }

        var tmp_wallet_filename = oshelper.temporaryFilename();
        console.log("Creating temporary wallet", tmp_wallet_filename)
        var nettype = persistentSettings.nettype;
        var restoreHeight = wizardController.walletOptionsRestoreHeight;
        var subaddressLookahead = wizardController.walletOptionsSubaddressLookahead;
        var deviceName = wizardController.walletOptionsDeviceName;

        var wallet = walletManager.createWalletFromDevice(tmp_wallet_filename, "", nettype, deviceName, restoreHeight, subaddressLookahead);

        var success = wallet.status === Wallet.Status_Ok;
        if (success) {
            wizardController.m_wallet = wallet;
            wizardController.walletOptionsIsRecoveringFromDevice = true;
            wizardController.tmpWalletFilename = tmp_wallet_filename;
        } else {
            console.log(wallet.errorString)
            walletErrorDialog.text = wallet.errorString;
            walletErrorDialog.open();
            walletManager.closeWallet();
        }
        return success;
    }

    function openWallet(){
        if (typeof wizardController.m_wallet !== 'undefined' && wizardController.m_wallet != null) {
            walletManager.closeWallet()
        }

        appWindow.viewState = "normal";
        fileDialog.open();
    }

    function openWalletFile(fn) {
        appWindow.viewState = "normal";

        persistentSettings.restore_height = 0;
        persistentSettings.is_recovering = false;

        appWindow.restoreHeight = 0;
        appWindow.walletPassword = "";

        if(typeof fn == 'object')
            persistentSettings.wallet_path = walletManager.urlToLocalPath(fn);
        else
            persistentSettings.wallet_path = fn;

        if(isIOS)
            persistentSettings.wallet_path = persistentSettings.wallet_path.replace(ArqmaAccountsDir, "");

        console.log(ArqmaAccountsDir);
        console.log(fn);
        console.log(persistentSettings.wallet_path);

        passwordDialog.onAcceptedCallback = function() {
            walletPassword = passwordDialog.password;
            appWindow.initialize();
        }
        passwordDialog.onRejectedCallback = function() {
            console.log("Canceled");
            appWindow.viewState = "wizard";
        }

        passwordDialog.open(appWindow.usefulName(appWindow.walletPath()));
    }
}
