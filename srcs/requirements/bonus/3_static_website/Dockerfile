# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mmeuric <mmeuric@student.42.fr>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/09/12 23:20:32 by mmeuric           #+#    #+#              #
#    Updated: 2025/10/01 21:02:47 by mmeuric          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #


# **************************************************************************** #
#                                                                              #
#    Dockerfile pour site statique                                             #
#                                                                              #
# **************************************************************************** #

ARG DEBIAN_VERSION
FROM debian:${DEBIAN_VERSION:-12}

RUN apt-get update && \
    apt-get install -y nginx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN rm -rf /var/www/html/*

COPY html/ /var/www/html/
COPY default.conf /etc/nginx/sites-available/default

EXPOSE 81

CMD ["nginx", "-g", "daemon off;"]

