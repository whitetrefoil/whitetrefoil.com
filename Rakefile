# encoding: utf-8
require 'fileutils'

namespace :compile do
  require 'yaml'
  config = YAML::load_file('dir.yml') rescue config = nil

  desc 'Compile Coffee-Script'
  task :coffee do
    c = config['coffee']
    input_path = c['input']
    output_path = c['output']

    if File.exist? input_path
      FileUtils.mkdir_p output_path

      cmd = 'coffee'
      cmd << (c['bare'] ? ' -b' : '')
      cmd << %[ -o "#{output_path}"]
      cmd << %[ "#{input_path}"]

      system(cmd)
    else
      puts "Coffee-script input path isn't existing, skipped."
    end
  end

  desc 'Compile Sass/Scss'
  task :sass do
    require 'sass'
    c = config['sass']
    input_path = c['input']
    output_path = c['output']

    if File.exist? input_path
      options = {}
      options[:style] = c['style'].to_sym if c['style']
      options[:cache] = false
      options[:always_update] = true
      FileUtils.mkdir_p output_path

      Dir.open(input_path).each do |f|
        next if File.extname(f) != '.sass' and File.extname(f) != '.scss'
        ioptions = options
        ioptions[:syntax] = :scss if File.extname(f) == '.scss'
        input_file = File.join(input_path, f)
        output_file = File.basename(f, File.extname(f)) + '.css'
        output_file = File.join(output_path, output_file)
        render = Sass::Engine.for_file(input_file, ioptions)

        File.open(output_file, 'wb') do |io|
          io.write render.to_css
        end
      end
    end
  end

  desc 'Compile Less'
  task :less do
    c = config['less']
    input_path = c['input']
    output_path = c['output']

    if File.exist? input_path
      FileUtils.mkdir_p output_path

      cmd = 'lessc'
      cmd << (c['compress'] ? ' -x' : '')
      cmd << (c['yui'] ? ' --yui-compress' : '')

      Dir.open(input_path).each do |f|
        if File.extname(f) == '.less'
          input_file = File.join(input_path, f)
          output_file = File.basename(f, '.less') + '.css'
          output_file = File.join(output_path, output_file)
          icmd = cmd + %[ "#{input_file}"]
          icmd << %[ > "#{output_file}"]
          system(icmd)
        end
      end
    else
      puts "Less input path isn't existing, skipped."
    end
  end

  desc 'Generate docco Documents'
  task :docco do
    c = config['docco']
    input_path = c['input']
    output_path = c['output']

    if File.exist? input_path
      FileUtils.mkdir_p output_path
      input_files = c['input']
      if c['pattern']
        if input_files[-1] != '/' then input_files << '/' end
        input_files << c['pattern']
      end

      cmd = 'docco'
      cmd << (c['css'] ? " -c #{c['css']}" : '')
      cmd << %[ -o "#{output_path}"]
      cmd << %[ "#{input_files}"]

      system(cmd)
      FileUtils.rm_rf '-p'
    else
      puts "Docco input path isn't existing, skipped."
    end
  end

  desc 'Check the config file'
  task :check_config do
    puts config
  end

  desc 'Compile Coffee-Script, Sass/Scss, Less, Docco, etc..'
  multitask :all => %w(coffee sass less docco)

  desc 'Compile all CSS relative files'
  multitask :css => %w(sass less)

  desc 'Compile all JavaScript relative files'
  multitask :js => %w(coffee docco)
end

namespace :clean do
  require 'yaml'
  config = YAML::load_file('dir.yml') rescue config = nil

  def clean(input_path, output_path, extname)
    return unless Dir.exist? (input_path) and Dir.exist? (output_path)
    Dir.open(input_path).each do |fn|
      next if fn == '.' or fn == '..'
      output_file = File.basename(fn, File.extname(fn)) + extname
      puts %[Cleaning "#{output_file}" ...]
      output_file = File.join(output_path, output_file)
      if File.exist? output_file
        File.delete output_file
        puts 'Done.'
      else
        puts 'Not found.'
      end
    end
  end

  desc 'Clean compiled coffee-script files'
  task :coffee do
    c = config['coffee']
    input_path = c['input']
    output_path = c['output']
    clean(input_path, output_path, '.js')
  end

  desc 'Clean compiled Sass/Scss files'
  task :sass do
    c = config['sass']
    input_path = c['input']
    output_path = c['output']
    clean(input_path, output_path, '.css')
  end

  desc 'Clean compiled Less files'
  task :less do
    c = config['less']
    input_path = c['input']
    output_path = c['output']
    clean(input_path, output_path, '.css')
  end

  desc 'Clean generated docco documents'
  task :docco do
    c = config['docco']
    input_path = c['input']
    output_path = c['output']
    clean(input_path, output_path, '.html')
  end

  desc 'Clean compiled files'
  multitask :all => %w(coffee sass less docco)

  desc 'Clean all CSS relative files'
  multitask :css => %w(sass less)

  desc 'Clean all JavaScript relative files'
  multitask :js => %w(coffee docco)
end

namespace :rebuild do
  desc 'Clean all compiled files and recompile them'
  multitask :all => %w(clean:all compile:all)

  desc 'Clean and rebuild CSS relative files'
  multitask :css => %w(clean:sass clean:less compile:sass compile:less)

  desc 'Clean and rebuild JavaScript relative files'
  multitask :js => %w(clean:coffee clean:docco compile:coffee compile:docco)

  desc 'Clean then re-compile coffee-scripts'
  multitask :coffee => %w(clean:coffee compile:coffee)

  desc 'Clean then re-compile Sass/Scss files'
  multitask :sass => %w(clean:sass compile:sass)

  desc 'Clean then re-compile Less files'
  multitask :less => %w(clean:less compile:less)

  desc 'Clean then re-generate docco documents'
  multitask :docco => %w(clean:docco compile:docco)

end
