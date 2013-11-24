# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'bundler'
Bundler.require

Motion::Project::App.setup do |app|
  app.name = 'controls'
  app.identifier = 'com.errancarey.controlsinsight'

  app.pods do
    # TODO: Switch to 2.0+
    pod 'AFNetworking', '~> 1.0.0'
  end
#  app.detect_dependencies = false
#  app.files_dependencies  'app/model/configuration.rb' => 'app/model/coverage_item.rb'
end
