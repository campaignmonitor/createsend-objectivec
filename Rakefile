task :default => :test

desc 'Run tests'
task :test do
  xctool_options = [
    '-project CreateSend.xcodeproj',
    '-scheme CreateSend' ]
  system "xctool #{xctool_options.join(' ')} clean build test"
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
