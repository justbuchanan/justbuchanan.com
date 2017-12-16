FROM justbuchanan/docker-archlinux
MAINTAINER Justin Buchanan <justbuchanan@gmail.com>

# switch from https to http for mirror
# TODO: switch back to https
RUN sed -i 's/https/http/' /etc/pacman.d/mirrorlist

RUN pacman -Sy
RUN pacman -S --noconfirm base-devel ruby

# TODO: don't hardcode ruby version
# ENV PATH $(ruby -e 'print Gem.user_dir')/bin:$PATH
ENV PATH /root/.gem/ruby/2.4.0/bin:$PATH

RUN gem install bundler

RUN pacman -S --noconfirm python2 python2-pip
RUN pip2 install pygments

RUN mkdir site
WORKDIR site
COPY ./ ./

RUN bundle install

EXPOSE 3000
CMD ["jekyll", "serve", "--host=0.0.0.0"]
