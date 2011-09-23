desc 'Generate documentation'
task :docs => [:'docs:clean'] do
  appledoc_options = [
    '--output Documentation',
    '--project-name CreateSend',
    '--project-company \'Campaign Monitor\'',
    '--company-id com.campaignmonitor',
    '--keep-intermediate-files',
    '--create-html',
    '--templates ~/.appledoc/',
    '--no-repeat-first-par',
    '--no-create-docset',
    '--verbose 6']
  
  puts `appledoc #{appledoc_options.join(' ')} Classes/CSAPI*.h`
end

namespace :docs do
  desc 'Clean docs'
  task :clean do
    `rm -rf Documentation/*`
  end
end
