#!/bin/sh

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    if [[ -e "/usr/lib/slack/resources/" ]]; then
        SLACK_INTEROP_JS="/usr/lib/slack/resources/app.asar.unpacked/src/static/ssb-interop.js"
        SUDO="sudo -H"
        echo -e "You have slack installed in a non-writable directory. \nThis script will ask you for your password in order to apply the theme."
    else
        echo "Currently only the default .deb or .rpm installation are supported. Sorry"
        exit 1
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # Darkify Slack on Mac OS:
    SLACK_INTEROP_JS="/Applications/Slack.app/Contents/Resources/app.asar.unpacked/src/static/ssb-interop.js"
    SUDO=""
else
    echo "Unsupported operating system. Sorry"
    exit 1
fi


# Insipred from earlduque, thanks.
if [ -z "`grep tt__customCss ${SLACK_INTEROP_JS}`" ]; then
    # Backup original CSS for reverts:
    ${SUDO} cp ${SLACK_INTEROP_JS} ${SLACK_INTEROP_JS}.bak
    echo 'document.addEventListener("DOMContentLoaded",function(){;$.ajax({url: "https://raw.githubusercontent.com/earlduque/Slack-Dark-Theme/master/dark.css",success: function(css1) {$.ajax({url: "https://raw.githubusercontent.com/FallOutChonny/slack-dark-theme/master/darkify.css",success: function(css2) {$("<style></style>").appendTo("head").html(css1 + css2);}});}});});' \
       | ${SUDO} tee -a ${SLACK_INTEROP_JS} > /dev/null
    echo "Dark theme applied to Slack."
else
    echo "Dark theme already present on Slack."
fi
