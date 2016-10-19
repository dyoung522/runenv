require "optparse"

module RunEnv
  class OptParse
    attr_accessor :options

    # Class to hold options and set defaults
    class Options
      attr_accessor :build, :cmd, :dryrun, :package, :run, :verbose

      def initialize
        self.build   = false
        self.cmd     = {
          build:   "npm run package:build",
          package: "bundle install && npm install",
          run:     "bundle exec foreman start -f Procfile.dev"
        }
        self.dryrun  = false
        self.package = false
        self.run     = true
        self.verbose = 1
      end
    end

    #
    # Version String
    #
    def self.version
      sprintf "%s - v%s\n", RunEnv::PROGRAM.capitalize, RunEnv::VERSION
    end

    #
    # Return a structure describing the options.
    #
    def self.parse(args, unit_testing=false)
      # The options specified on the command line will be collected in *options*.
      # We set default values here.

      @options = Options.new
      @parser  ||= OptionParser.new do |opts|
        verbose_count = 0

        opts.banner = "Usage: #{File.basename(RunEnv::PROGRAM)} [OPTIONS]"
        opts.banner += "  Runs development environment, optionally with a package and/or build first"

        opts.separator ""
        opts.separator "[OPTIONS]"

        opts.separator ""
        opts.separator "Specific options:"

        # Options
        opts.on("-b", "--[no-]build", "Run the build command") do |do_build|
          @options.build = do_build
        end

        opts.on("-p", "--[no-]package", "Install packages") do |do_package|
          @options.package = do_package
        end

        opts.on("-r", "--[no-]run", "Run the development environment (default: yes)") do |do_run|
          @options.run = do_run
        end

        # Verbose switch
        opts.on("-q", "--quiet", "Run quietly") do
          @options.verbose = verbose_count = 0
        end

        opts.on("-v", "--verbose", "Run verbosely (may be specified more than once)") do
          @options.verbose = verbose_count += 1
        end

        opts.separator ""
        opts.separator "Commands:"

        opts.on("--build-cmd CMD", "Overwrite build command: '#{@options.cmd[:build]}'") do |cmd|
          @options.cmd[:build] = cmd
        end

        opts.on("--package-cmd CMD", "Overwrite package command: '#{@options.cmd[:package]}'") do |cmd|
          @options.cmd[:package] = cmd
        end

        opts.on("--run-cmd CMD", "Overwrite run command: '#{@options.cmd[:run]}'") do |cmd|
          @options.cmd[:run] = cmd
        end

        opts.separator ""
        opts.separator "Common options:"

        opts.on("--dry-run", "Don't actually run commands") do
          @options.dryrun = true
        end

        opts.on("-h", "--help", "Show this message") do
          unless unit_testing
            puts version + "\n"
            puts opts
            exit
          end
        end

        opts.on("-V", "--version", "Show version") do
          unless unit_testing
            puts @options.version
            exit
          end
        end
      end

      @parser.parse!(args)

      return @options
    end # self.parse

  end # class OptParse
end #module
