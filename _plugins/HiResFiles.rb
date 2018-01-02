module Jekyll
  module HiResFiles

    @@counter = 10000;

    def hires_name(input)
      name="#{input}".strip
      return name.gsub(/\_lo.png$/, '_hi.png') if name.end_with?('_lo.png')
      return name.gsub(/\_lo.jpg$/, '_hi.jpg') if name.end_with?('_lo.jpg')
      return name
    end
    
    def hires_exists(input)
      name="#{input}".strip
      hiresname=hires_name(name)
      return false if hiresname == name;
      return true if File.exists?(hires_name(name))
      return false
    end

    # generates a unique id, used for CSS generation
    def hires_uniqueid(prefix)
      @@counter = @@counter + 1;
      return "#{prefix}#{@@counter}";
    end

  end
end

Liquid::Template.register_filter(Jekyll::HiResFiles)
