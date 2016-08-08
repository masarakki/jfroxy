require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

namespace :docker do
  name = 'masarakki/jfrog'

  task :build do
    sh "docker build -t #{name} ."
  end

  task push: :build do
    sh "docker push #{name}"
  end
end

desc 'docker build and push'
task docker: 'docker:push'

task default: :spec
