# encoding: UTF-8

require_relative('wpscan_controller.rb')

class RedirectionController < WPScanController

  def initialize
    register_options(
      ['--follow-redirection', 'If the target url has a redirection, it will be followed without asking if you wanted to do so or not']
    )
  end

  # return [ WpTarget, nil ]
  def check_redirection
    if redirection = wp_target.redirection
      if @parsed_options[:follow_redirection]
        puts render('following', url: redirection)
        return redirection
      else
        if user_interaction?
          puts "The remote host tried to redirect us to #{redirection}"
          print 'Do you want follow the redirection ? [y/N] '

          if Readline.readline =~ /^y/i
            return redirection
          else
            raise render('aborted')
          end
        else
          raise render('redirection', url: redirection)
        end
      end
    end
  end

end