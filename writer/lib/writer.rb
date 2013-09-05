# -*- encoding: utf-8 -*-
$:.unshift File.dirname(__FILE__)

require 'bundler'
Bundler.require(:default, (ENV["RACK_ENV"]|| 'development').to_sym)

require 'writer/config'
require 'writer/consumer'
