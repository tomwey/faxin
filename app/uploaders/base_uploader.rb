# coding: utf-8
require 'carrierwave/processing/mini_magick'
class BaseUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}"
  end
  
  def default_url
    "photo/#{version_name}.jpg"
  end
  
  def extension_white_list
    %w(jpg jpeg gif png)
  end
  
end 