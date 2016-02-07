nginx
php5-fpm
mv user user_original
chown -R grav:www-data user_mount/ logs
ln -s user_mount/ user
if [ -z "$(ls -A user_mount)" ]; then
	cp -rp user_original/* user_mount/
fi
chmod -R u=rw,g=rwxs,o= user_mount/ logs/
/bin/bash
