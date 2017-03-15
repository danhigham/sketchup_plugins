module Sketchup
  class Console
    def puts(msg)
      open('/tmp/console.out', 'a') { |f|
        f.puts msg
      }
    end

    def sync=(new_sync)
      @sync=new_sync
    end
  end
end
