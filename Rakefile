task :default => :test

desc 'Run tests'
task :test do
  xcodebuild_options = [
    '-sdk iphonesimulator',
    '-project CreateSend.xcodeproj',
    '-scheme CommandLineUnitTests',
    '-configuration Debug' ]
    environment_variables = [
      'RUN_APPLICATION_TESTS_WITH_IOS_SIM=YES',
      'ONLY_ACTIVE_ARCH=NO' ]
  system "xcodebuild #{xcodebuild_options.join(' ')} #{environment_variables.join(' ')} clean build 2>&1"
end

namespace :docs do
  
  desc 'Generate documentation'
  task :generate => [:'docs:clean'] do
    appledoc_options = [
      '--output Documentation',
      '--project-name CreateSend',
      '--project-company \'Campaign Monitor\'',
      '--company-id com.campaignmonitor',
      '--keep-intermediate-files',
      '--create-html',
      '--no-repeat-first-par',
      '--no-create-docset',
      '--no-merge-categories',
      '--verbose 3']
  
    puts `appledoc #{appledoc_options.join(' ')} CreateSend/CS*.h`
  end

  desc 'Clean docs'
  task :clean do
    `rm -rf Documentation/*`
  end
  
end
