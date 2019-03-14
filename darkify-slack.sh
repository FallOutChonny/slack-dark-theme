#!/bin/sh
# Darkify Slack on Mac OS:

SLACK_INTEROP_JS="/Applications/Slack.app/Contents/Resources/app.asar.unpacked/src/static/ssb-interop.js"

# Insipred from earlduque, thanks.
if [ -z "`grep tt__customCss ${SLACK_INTEROP_JS}`" ]; then
    # Backup original CSS for reverts:
    cp ${SLACK_INTEROP_JS} ${SLACK_INTEROP_JS}.bak
    echo 'document.addEventListener("DOMContentLoaded",function(){;$.ajax({url: "https://raw.githubusercontent.com/earlduque/Slack-Dark-Theme/master/dark.css",success: function(css1) {$.ajax({url: "https://raw.githubusercontent.com/FallOutChonny/slack-dark-theme/master/darkify.css",success: function(css2) {$("<style></style>").appendTo("head").html(css1 + css2);}});}});});' \
        >> ${SLACK_INTEROP_JS}
    echo "Dark theme applied to Slack."
else
    echo "Dark theme already present on Slack."
fi
