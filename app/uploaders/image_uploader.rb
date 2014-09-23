# encoding: utf-8
class ImageUploader < BaseUploader
  
  process :resize_to_limit => [680, nil]
  
  def filename
    if super.present?
      @name ||= Digest::MD5.hexdigest(current_path)
      "#{Time.now.year}/#{@name}.#{file.extension.downcase}"
    end
  end

end
