# A sample Guardfile
# More info at https://github.com/guard/guard#readme

group 'front' do
  guard 'livereload' do
    watch(%r{app/.+\.(erb|haml)})
    watch(%r{app/helpers/.+\.rb})
    watch(%r{(public/|app/assets).+\.(css|js|html)})
    watch(%r{(app/assets/.+\.css)\.s[ac]ss}) { |m| m[1] }
    watch(%r{(app/assets/.+\.js)\.coffee}) { |m| m[1] }
    watch(%r{config/locales/.+\.yml})
  end

  guard 'sass',
    :input => 'app/assets/stylesheets',
    :noop => true
end



group 'back' do
  guard 'rspec', :version => 2, :all_on_start => false,  :all_after_pass => false do
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
    watch('spec/spec_helper.rb')  { "spec" }

    # Rails example
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
    watch(%r{^app/(.*)(\.erb|\.haml)$})                 { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
    watch(%r{^lib/(.+)\.rb$})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
    watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
    watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
    watch('spec/spec_helper.rb')                        { "spec" }
    watch('config/routes.rb')                           { "spec/routing" }
    watch('app/controllers/application_controller.rb')  { "spec/controllers" }
    # Capybara request specs
    watch(%r{^app/views/(.+)/.*\.(erb|haml)$})          { |m| "spec/requests/#{m[1]}_spec.rb" }
  end

  guard 'bundler' do
    watch 'Gemfile'
  end
end



