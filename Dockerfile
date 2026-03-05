FROM nginx:alpine

ARG BUILD_NUMBER="local"
ARG GIT_COMMIT="unknown"
ARG BUILD_DATE="unknown"

#Copy site files
COPY site/ /usr/share/nginx/html/


#Replace template markers with build metadata
RUN sed -i "s/__BUILD_NUMBER__/${BUILD_NUMBER}/g" /usr/share/nginx/html/version.html && \
    sed -i "s/__GIT_COMMIT__/${GIT_COMMIT}/g" /usr/share/nginx/html/version.html && \
    sed -i "s/__BUILD_DATE__/${BUILD_DATE}/g" /usr/share/nginx/html/version.html
