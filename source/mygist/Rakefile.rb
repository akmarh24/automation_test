require 'rubygems'
require 'cucumber'
require 'cucumber/rake/task'
require 'parallel_tests'
require 'cuke_sniffer'
require 'report_builder'
# rubocop:disable Metrics/BlockLength, Metrics/LineLength
namespace :deadpool do
  @status = true
  Cucumber::Rake::Task.new do |t|
    t.cucumber_opts = %w[--format progress]
  end

  Cucumber::Rake::Task.new(:test, 'Run Sleekr Automation Test') do |t|
    # sample use: rake deadpool:test t=@login REPORT_NAME=2
    t.cucumber_opts = ["-t #{ENV['t']}"] unless ENV['t'].nil?
    t.cucumber_opts = ["features/#{ENV['f']}"] unless ENV['f'].nil?
    t.profile = 'rake_run'
  end

  desc 'Parallel run'
  task :parallel do
    abort '=====:: Failed to proceed, tags needed for parallel (t=@sometag)' if ENV['t'].nil?
    puts "=====:: Parallel execution tag: #{ENV['t']} about to start "
    # these exec no needed, already covered in "deadpool:parallel_run"
    # Rake::Task['deadpool:clear_report'].execute
    # Rake::Task['deadpool:init_report'].execute

    begin
      @status = system "bundle exec parallel_cucumber features/ -n 4 -o '-t #{ENV['t']}'"
      puts "Testing @status after parallel #{@status}"
    rescue StandardError => exception
      p 'Found error!'
      pp exception
    ensure
      puts '=====::  ::====='
      # p "merging report:"
      # Rake::Task["deadpool:merge_report"].execute
    end
  end

  task :clear_report do
    puts '=====:: Delete report directory '
    report_root = File.absolute_path('./report')
    FileUtils.rm_rf(report_root, secure: true)
    FileUtils.mkdir_p report_root
  end

  task :init_report do
    report_root = File.absolute_path('./report')
    ENV['REPORT_PATH'] = Time.now.strftime('%F_%H-%M-%S')
    puts "=====:: about to create report #{ENV['REPORT_PATH']} "
    FileUtils.mkdir_p "#{report_root}/#{ENV['REPORT_PATH']}"
  end

  task :merge_report do
    # Merging all report found in the directory
    # sample usage `rake deadpool:merge_report REPORT_PATH=2018-09-21_14-42-22`
    output_report = "report/output/test_report_#{ENV['REPORT_PATH']}"
    puts "=====:: Merging report #{output_report}"
    FileUtils.mkdir_p 'report/output'
    options = {
      input_path: "report/#{ENV['REPORT_PATH']}",
      report_path: output_report,
      report_types: %w[retry html json],
      report_title: 'deadpool Report',
      color: 'blue',
      additional_info: { 'Browser' => 'Chrome', 'Environment' => ENV['BASE_URL'].to_s, 'Generated report' => Time.now }
    }
    ReportBuilder.build_report options
    puts "After rerun @status in merging report is #{@status}"
    exit(1) unless @status
  end

  task :run do
    # Before all
    Rake::Task['deadpool:clear_report'].execute

    # Test 1
    Rake::Task['deadpool:init_report'].execute
    system 'rake deadpool:test t=@login'

    # Test 2
    Rake::Task['deadpool:init_report'].execute
    system 'rake deadpool:test t=@signup'

    # After all
    Rake::Task['deadpool:merge_report'].execute
  end

  task :rerun do
    if File.size("report/#{ENV['REPORT_PATH']}/rerun.txt").zero?
      puts '=====:: Nice, All is well '
    else
      puts '=====:: Rerun Failed Scenarios '
      # Copy rerun to root, so it same level with features/
      puts "Original file: ./report/#{ENV['REPORT_PATH']}/rerun.txt"
      FileUtils.cp_r "./report/#{ENV['REPORT_PATH']}/rerun.txt", './rerun.txt'
      system "bundle exec cucumber @rerun.txt --format pretty --format html --out report/#{ENV['REPORT_PATH']}/features_report_rerun.html --format json --out=report/#{ENV['REPORT_PATH']}/cucumber_rerun.json -f rerun  -o report/#{ENV['REPORT_PATH']}/afterrerun.txt"
      if File.size("report/#{ENV['REPORT_PATH']}/afterrerun.txt").zero?
        @status = true
        puts '=====:: Nice, rerun makes all is well '
      else
        puts '=====:: Even after rerun, it still failed :('
      end
    end
  end

  task :police do
    sh 'bundle exec cuke_sniffer --out html report/cuke_sniffer.html'
  end

  task :start_appium do
    puts '=====:: Installing Appium '
    sh 'npm install'
    sh ' ./node_modules/.bin/appium > /dev/null 2>&1'
  end

  task :install do
    # this task needed in docker to update gems file
    # Gemfile located outside directory of Rakefile, so we add relative path
    puts '=====:: Installing Gems '
    system 'pwd && bundle install --path ../Gemfile'
  end
  task parallel_run: %i[clear_report init_report parallel rerun merge_report]
end
# rubocop:enable Metrics/BlockLength, Metrics/LineLength
