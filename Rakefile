# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

CodeWorkout::Application.load_tasks

namespace :docker do
  desc "Remove docker container"
  task :clean do
    sh './clean.sh'
  end

  desc "Build and push base image"
  task :build_base => [:clean] do
    sh './build.sh'
  end

  desc "Build and push app image"
  task :build_app => [:build_base] do
    sh './deploy.sh'
  end
end
