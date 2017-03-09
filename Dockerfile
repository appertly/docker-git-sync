FROM gcr.io/google_containers/git-sync:v2.0.4

USER root:root

ADD start.sh /start.sh

ENTRYPOINT ["/start.sh"]
