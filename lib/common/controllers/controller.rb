# encoding: UTF-8

class Controller

  attr_reader :registered_options, :parsed_options

  def name
    self.class.to_s.gsub(/Controller/, '')
  end

  def self.allowed_formats
    %w{cli json}
  end

  # param [ Array ] options
  def register_options(*options)
    options.each do |option|
      unless option.is_a?(Array)
        raise "Each option must be an array, #{option.class} supplied"
      end
    end
    @registered_options = options
  end

  def validate_parsed_options(options)
    @parsed_options = options
  end

  # param [ String ] action
  #
  # return [ String ] The rendered result of the action
  def result(action)
    send(action.to_sym)
    render(action)
  end

  # param [ String ] action
  # return [ String ] The rendered action
  def render(action)
    view = File.join(views_dir, "#{action}.#{self.format}.erb")

    if File.exists?(view)
      ERB.new(File.read(view)).result(binding)
    else
      raise "The file #{view} does not exist"
    end
  end

  # return [ String ] The output format (default: cli)
  def format
    format = @parsed_options ? (@parsed_options[:format] || 'cli').downcase : 'cli'
    format = 'cli' unless Controller.allowed_formats.include?(format)
    format
  end

  # return [ Boolean ] Return true if the controller can have user interaction, false otherwise
  def user_interaction?
    if format == 'cli'
      return true if @parsed_options && !@parsed_options[:output]
    end
    false
  end

  protected

  # return [ String ] The absolute path of the views directory
  def views_dir
    unless @views_dir
      @views_dir = File.expand_path(File.join(
        self.class.instance_method(:initialize).source_location[0], '..', '..' , 'views',
        self.name.downcase
      ))
    end
    @views_dir
  end
end
