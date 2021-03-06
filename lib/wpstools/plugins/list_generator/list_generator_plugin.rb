# encoding: UTF-8

class ListGeneratorPlugin < Plugin

  def initialize
    super(author: 'WPScanTeam - @FireFart')

    register_options(
      ['--generate-plugin-list [NUMBER_OF_PAGES]', '--gpl', Integer, 'Generate a new data/plugins.txt file. (supply number of *pages* to parse, default : 150)'],
      ['--generate-full-plugin-list', '--gfpl', 'Generate a new full data/plugins.txt file'],

      ['--generate-theme-list [NUMBER_OF_PAGES]', '--gtl', Integer, 'Generate a new data/themes.txt file. (supply number of *pages* to parse, default : 150)'],
      ['--generate-full-theme-list', '--gftl', 'Generate a new full data/themes.txt file'],

      ['--generate-all', '--ga', 'Generate a new full plugins, full themes, popular plugins and popular themes list']
    )
  end

  def run(options = {})
    @verbose     = options[:verbose] || false
    generate_all = options[:generate_all] || false

    if options.has_key?(:generate_plugin_list) || generate_all
      most_popular('plugin', options[:generate_plugin_list] || 150)
    end

    if options[:generate_full_plugin_list] || generate_all
      full('plugin')
    end

    if options.has_key?(:generate_theme_list) || generate_all
      most_popular('theme', options[:generate_theme_list] || 150)
    end

    if options[:generate_full_theme_list] || generate_all
      full('theme')
    end
  end

  private

  def most_popular(type, number_of_pages)
    puts "[+] Generating new most popular #{type} list"
    puts
    GenerateList.new(type + 's', @verbose).generate_popular_list(number_of_pages)
  end

  def full(type)
    puts "[+] Generating new full #{type} list"
    puts
    GenerateList.new(type + 's', @verbose).generate_full_list
  end
end
