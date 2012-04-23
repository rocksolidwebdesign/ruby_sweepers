#!/usr/bin/env ruby
$:.unshift File.dirname($0)

require 'Qt4'
require 'lcdrange.rb'
require 'mine.rb'
require 'tank.rb'
require 'field.rb'

class Simulator < Qt::Widget
  def initialize(parent=nil)
    super

    quit  = Qt::PushButton.new('Quit')
    reset = Qt::PushButton.new('New Game')
    start = Qt::PushButton.new('Start')
    stop  = Qt::PushButton.new('Stop')

    connect(quit, SIGNAL('clicked()'), $qApp, SLOT('quit()'))

    @mineField = MineField.new
    @mineField.sizePolicy = Qt::SizePolicy::Fixed
    @mineField.updateGeometry

    connect(start, SIGNAL('clicked()'), @mineField, SLOT('beginSweeping()'))
    connect(stop,  SIGNAL('clicked()'), @mineField, SLOT('stopSweeping()'))
    connect(reset, SIGNAL('clicked()'), @mineField, SLOT('newGame()'))

    topLayout = Qt::HBoxLayout.new()
    topLayout.addWidget(reset)
    topLayout.addStretch(1)

    leftLayout = Qt::VBoxLayout.new()
    leftLayout.addWidget(start)
    leftLayout.addWidget(stop)

    gridLayout = Qt::GridLayout.new
    gridLayout.addWidget(quit, 0, 0)
    gridLayout.addLayout(topLayout, 0, 1)
    gridLayout.addLayout(leftLayout, 1, 0)
    gridLayout.addWidget(@mineField, 1, 1, 3, 3)
    gridLayout.setColumnStretch(1, 10)
    setLayout(gridLayout)
  end
end

app = Qt::Application.new(ARGV)

widget = Simulator.new
widget.show

app.exec
