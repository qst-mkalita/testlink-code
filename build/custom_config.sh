#!/bin/sh

echo
echo "Configuring TestLink..."
echo

file="/var/www/testlink/custom_config.inc.php"

### SMTP settings ###
echo '<?php' > $file;
echo "\$g_repositoryPath = '/var/testlink/upload_area/';" >> $file
echo "\$tlCfg->log_path = '/var/testlink/logs/';" >> $file
echo "\$tlCfg->config_check_warning_mode = 'SCREEN';" >> $file
echo "\$g_smtp_host = '$SMTP_HOST';" >> $file
echo "\$g_smtp_port = $SMTP_PORT;" >> $file
echo "\$g_smtp_connection_mode = '$SMTP_PROTOCOL';" >> $file
if [ ! -z "$SMTP_USERNAME" ]
then
    echo "\$g_smtp_username = '$SMTP_USERNAME';" >> $file
    echo "\$g_smtp_password = '$SMTP_PASSWORD';" >> $file
fi
echo "\$g_mail_priority = $MAIL_PRIORITY;" >> $file
echo "\$g_phpMailer_method = $MAIL_METHOD;" >> $file
echo "\$g_tl_admin_email = '$MAIL_ADMIN';" >> $file
echo "\$g_from_email = '$MAIL_FROM';" >> $file
echo "\$g_return_path_email = '$MAIL_RETURN';" >> $file

### Other settings ###
echo "\$tlCfg->document_generator->company_name = '$COMPANY_NAME';" >> $file

chown www-data $file

echo
echo "Done."
echo