FROM ghost:5-alpine

ARG NAME=Royce_v3.0.1
COPY root/ .
RUN ls -la /var/lib/ghost/content.orig/themes && \
		mv heroku-entrypoint.sh /usr/local/bin && \
		#create symlink
		ln -s content/themes/$NAME /var/lib/ghost/current/content/themes/$NAME
ENTRYPOINT ["heroku-entrypoint.sh"]
CMD ["node","current/index.js"]
