FROM ghost:5-alpine

ARG NAME=Royce_v3.0.1
COPY root/ .
RUN ls -la /var/lib/ghost/content.orig/themes && \
		mv heroku-entrypoint.sh /usr/local/bin && \
		mv content/themes/* /var/lib/ghost/content.orig/themes && \
		# Set theme to active
    (sed -i "s/casper/$NAME/" /var/lib/ghost/versions/$GHOST_VERSION/core/server/data/schema/default-settings/default-settings.json)
ENTRYPOINT ["heroku-entrypoint.sh"]
CMD ["node","current/index.js"]
