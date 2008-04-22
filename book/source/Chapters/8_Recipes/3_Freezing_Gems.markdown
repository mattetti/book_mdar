## Freezing Gems

This recipe was contributed by __Michael Klishin__

One thing Merb community gets right is gems bundling. config/init.rb in Merb apps has the following magic line that shows idea of independency of the application from environment it runs in is baked into the core:

	Gem.path.unshift(Merb.root / "gems")

Yay, no need to reinvent Gem plugin. It is that simple. A note here: to actually get up and running with Merb and Edge ActiveSupport and ActiveRecord bundled under /gems directory you have to specify installation directory with -i option:

	sudo gem install -i ~/dev/workspace/some-merb-application/gems


This sets up a directory structure RubyGems' custom require expects to see.

Another thing Merb community gets right is freezing of Merb itself. I want to run this app on Edge Merb, I want to be independent from what Merb gems are on the box I deploy to. Rails does it by exporting a tarball since it moved to Git so you absolutely cannot track the tree you currently use.

In Merb there is a nice plugin merb-freezer. What it does is using either gems unpack strategy or Git submodules strategy if you use Git for your Merb application. This is very cool. Git submodules is like Subversion's externals but adapted to distributed nature of Git and packed with features Subversion lacks.

With git modules freezing you can track what commit hash app is frozen to, what recent log messages say, update it one by one or all at once, use the branch you want from repository as a submodule, see meaningful submodules state summary. Compare this to tarballs management.

To use merb freezer all you have to do is to install merb-freezer from merb-more repo and include a line

	require 'merb-freezer'

into your config/init.rb. Then run

	rake freeze:core

if you want to use Git submodules or

	MODE=gems rake freeze:core

if you want to go with installed gems.

`freeze:more` and `freeze:plugins` do freezes of merb-more and merb-plugins, respectively.

If you choose submodules, make sure you start with a clean branch. Submodules meta information file (.gitmodules) and frameworks directory where Merb is frozen to have to be commited after run of Rake task that does the freeze.

To update Merb use the same Rake task with UPDATE env variable set to true. To see what commits application is frozen to, use

	git submodule status

To see N recent commits in Merb core installed as a submodule use

	git submodule summary -n <N> frameworks/merb-core
