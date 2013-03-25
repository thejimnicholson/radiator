Radiator
========

[![Build Status](https://travis-ci.org/thejimnicholson/radiator.png)](https://travis-ci.org/thejimnicholson/radiator)

Radiator is a system for syndicating and displaying continuous integration server job statuses. It currently can act as a front-end to [Jenkins](http://jenkins-ci.org/)

Features
-------------------

* View settings are associated with a IP address; no user table maintenance required. 
* Each source is a discrete Jenkins view, so existing Jenkins view configurations can be leveraged.
* Multiple sources can be aggregated onto a single radiator display.
* Views can be filtered to only display selected job statuses.


The How of Radiator
-------------------

Radiator is generally being developed using TDD. Since Sinatra has no real test support (other than Rack::Test), that can be a challenge. But challenges help us grow, and growth is good. Radiator's tests use Test::Unit, rather than a fancier test framework like rspec. I'm sure there are a lot of advantages to using rspec. I'm also sure that most of the people using rspec have never (or only rarely) encountered situations where rspec is better than Test::Unit. But ultimately, I used Test::Unit because I knew it, and I decided not to add "learn a new test framework" to my requirements for Radiator.

* Radiator uses [HAML](http://haml.info). You either love or hate HAML. I love it. I also like Python, the little I've been able to use it.
* Radiator uses [SASS](http://sass-lang.com/). You don't get a choice here. SCSS is far superior to CSS. Drink the kool-aid. It's good for you.
* Radiator uses [Compass](http://compass-style.org/). I chose Compass for two reasons: I'm comfortable with Blueprint, and I didn't want to have to write my own toolchain for compiling SCSS into CSS. 
* Radiator uses [-prefix-free](http://leaverou.github.com/prefixfree/). *You really need this.* It means you don't have to put a bunch of browser-specific directives in your CSS3 files. Seriously. It's great. 
* Parts of Radiator's look-and-feel were prototyped using [dabblet](http://dabblet.com). Dabblet is great. Really great.
* Radiator uses jquery and jquery-ui
* Radiator uses [FakeWeb](http://fakeweb.rubyforge.org/) and [flexmock](https://github.com/jimweirich/flexmock) for testing.

TODO
----

* implement config

* implement switch

* need a more complementary jquery-ui theme

