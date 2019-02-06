FROM alpine:3.9

MAINTAINER John Yeary <jyeary@bluelotussoftware.com>

ENV SPAMASSASSIN_VERSION 3.4.2-r0

RUN apk update && \
    apk add spamassassin=$SPAMASSASSIN_VERSION && \
    apk add razor && \
    apk add sed && \
    apk add py2-pip && \
#    apk add py3-pyzor --update-cache --repository \
#    http://dl-3.alpinelinux.org/alpine/edge/testing/ \
#    --allow-untrusted && \
    rm -rf /var/cache/apk/*

# We are using pip to install pyzor since it does not exist in the Alpine 3.9
# package repository. The py3-pyzor had errors when I tested it.
RUN pip install pyzor

#RUN addgroup -S alpine-spamd && adduser -S -G alpine-spamd alpine-spamd

RUN mkdir -p /etc/spamassassin/sa-update-keys && \
    chmod 700 /etc/spamassassin/sa-update-keys && \
#    chown alpine-spamd:alpine-spamd /etc/spamassassin/sa-update-keys && \
    mkdir -p /var/lib/spamassassin/.pyzor && \
    chmod 700 /var/lib/spamassassin/.pyzor && \
    echo "public.pyzor.org:24441" > /var/lib/spamassassin/.pyzor/servers && \
    chmod 600 /var/lib/spamassassin/.pyzor/servers
    # && \
#    chown -R alpine-spamd:alpine-spamd /var/lib/spamassassin/.pyzor

# RUN sed -i 's/^logfile = .*$/logfile = \/dev\/stderr/g' /etc/razor/razor-agent.conf

COPY spamd.sh rule-update.sh run.sh /

RUN chown root:root /spamd.sh && \
    chown root:root /rule-update.sh && \
    chown root:root /run.sh

# Run sa-update before attempting to start spamd otherwise it will not start
# without a set of rules.
RUN sa-update

EXPOSE 783

CMD ["/run.sh"]
