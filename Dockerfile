FROM ruby:2.3.1-onbuild

RUN compass compile

EXPOSE 3000

CMD ["rackup","-p","3000","-o","0.0.0.0"]
