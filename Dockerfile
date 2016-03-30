FROM justbuchanan/docker-archlinux
MAINTAINER Justin Buchanan <justbuchanan@gmail.com>

RUN pacman -S --noconfirm base-devel ruby

# ENV PATH $(ruby -e 'print Gem.user_dir')/bin:$PATH
ENV PATH /root/.gem/ruby/2.3.0/bin:$PATH

RUN gem install jekyll pygments.rb rdiscount

RUN pacman -S --noconfirm python2 python2-pip
RUN pip2 install pygments

RUN mkdir site
WORKDIR site
COPY ./ ./

EXPOSE 3000
CMD ["jekyll", "serve", "--host=0.0.0.0"]
