$:.unshift File.dirname(__FILE__)

require 'sketchup.rb'
require 'extensions.rb'
require 'rubygems'

GEMS = ['sinatra', 'webrick']

GEMS.each do |name|
  spec = Gem::Specification.find_all.select { |x| x.name == name }
  if spec.count == 0
    require 'rubygems/commands/install_command'

    inst = Gem::DependencyInstaller.new
    inst.install name
  end
end


require 'sinatra'
require 'board_feet/server'
require 'board_feet/sketchup_console'
require 'board_feet/sketchup_group'

module BoardFeet

  @@server_thread = nil
  def self.set_server_thread(thread)
    @@server_thread = thread
  end

  def self.get_server_thread()
    @@server_thread
  end

  def self.start_server
    BoardFeet.set_server_thread(Thread.new {
      BoardFeetServer.set_data(Sketchup.active_model)
      puts "*** Starting server ***"
      BoardFeetServer.run!
    })
  end

  def self.augment_data(model)
    # iterate all entities
    model.entities.each do |entity|
      if entity.is_a? Sketchup::Group
        b = entity.decimal_bounds
        min_thickness = [b[:width], b[:height], b[:depth]].min
        entity.stock_size = stock_size(min_thickness)
      end
    end
    # find minimum length in bounds
    # categorize min in stock size (4/4, 8/4 etc)
    # add stock size and board feet to object
    model.entities.select { |e| e.is_a? Sketchup::Group }
  end

  # stock size in quaters at S2S
  def self.stock_size(thickness)
    case thickness
    when 0..0.75 then return 4 # 4/4 (13/16)
    when 0.75..1 then return 5 # 5/4 (1 1/16)
    when 1..1.25 then return 6 # 6/4 (1 5/16)
    when 1.25..1.75 then return 8 # 8/4 (1 13/16)
    when 1.75..2.75 then return 12 # 12/4 (2 3/4)
    end
  end

  def self.open_server_page
    entities = augment_data(Sketchup.active_model)
    BoardFeetServer.set_data(entities)
    UI.openURL('http://localhost:4567/model')
    sleep(1.5)
  end

  unless file_loaded?(__FILE__)
    menu = UI.menu('Plugins')
    menu.add_item('Board Feet Calc') {
      self.open_server_page
    }

    self.start_server()
    file_loaded(__FILE__)
  end
end
