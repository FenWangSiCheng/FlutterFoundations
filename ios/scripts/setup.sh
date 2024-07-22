# Install ruby using rbenv
ruby_version=`cat .ruby-version`
if [[ ! -d "$HOME/.rbenv/versions/$ruby_version" ]]; then
  rbenv install $ruby_version;
fi
# Install bunlder
gem install bundler:2.4.22
# Install all gems
bundle install --path vendor/bundle
# Install all pods
bundle exec pod install --repo-update
