# https://github.com/jessek/hashdeep/releases/tag/release-4.4

require 'glue/tasks/base_task'
require 'open3'

class Glue::FIM < Glue::BaseTask

  Glue::Tasks.add self

  def initialize(trigger, tracker)
    super(trigger,tracker)
    @name = "FIM"
    @description = "File integrity monitor"
    @stage = :file
    @result = ''
    @labels << "filesystem"
  end

  def run
    rootpath = @trigger.path
    if File.exists?("/area81/tmp/#{rootpath}/filehash")
      Glue.notify "File Hashes found, comparing to file system"
      cmd="hashdeep -j99 -r -a -vv -k /area81/tmp/#{rootpath}/filehash #{rootpath}"

      # Ugly stdout parsing
      r=/(.*): No match/
      Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
        while line = stdout.gets
          if line.match r
            @result << line
          end
        end
      end
    else
      Glue.notify "No existing baseline - generating initial hashes"
      cmd="mkdir -p /area81/tmp/#{rootpath}; hashdeep -j99 -r #{rootpath} > /area81/tmp/#{rootpath}/filehash"
      Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
        while line = stdout.gets
          puts "."
          end
      end
      @result = ''
    end
  end

  def analyze
    list = @result.split(/\n/)
    list.each do |v|
       # v.slice! installdir
       Glue.notify v
       report "File changed.", v, @name, :low
    end
  end

  def supported?
    # In future, verify tool is available.
    return true
  end

end
