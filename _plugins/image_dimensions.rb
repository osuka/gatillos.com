module Jekyll
  module ImageDimensionsFilter

    @@cache = {}

    # check if sips exists (on a mac), else go the imagemagick route
    `which sips` # found if $?.exitstatus == 0
    @@use_sips = $?.exitstatus == 0
    puts "- sips not detected"
    puts "- attempting to use imagemagick's identify"
	

    # Calculates (CURRENTLY ONLY IN MAC OS X) the dimensions of an image
    # and returns it as an array with [width, height], "" if non existent, nil if error.
    # numbers are Float
    #
    def _dimensions(input)
      # this will only work in mac os x!!!
      name="#{input}".strip
      puts "File " + name + " DOES NOT EXIST!!! " unless File.exists?(name)
      return @@cache[name] if @@cache[name] # simple caching because it's an expensive operation
      return "" unless File.exists?(name)

      if @@use_sips
        h_s = %x[sips -g pixelHeight "#{name}"]
        h = h_s[/.*: (.*)/, 1]
      else
        h_s = %x[identify -verbose "#{name}" |grep '  Geometry:']
        h = h_s[/.*: (\d+)x(\d+)\+(\d+)\+(\d+)/,2]
      end

      begin
        h_i = Float(h)
      rescue Exception => e
        puts "  - bad image, or tool could not calculate size"
        return nil
      end

      if @@use_sips
        w_s = %x[sips -g pixelWidth "#{name}"]
        w = w_s[/.*: (.*)/, 1]
      else
        w_s = %x[identify -verbose "#{name}" |grep '  Geometry:']
        w = w_s[/.*: (\d+)x(\d+)\+(\d+)\+(\d+)/,1]
      end

      begin
        w_i = Float(w)
      rescue Exception => e
        puts "  - bad image, or tool could not calculate size"
        return nil
      end
      @@cache[name] = [w_i, h_i]
      return @@cache[name]
    end

    # Returns an expression of width and height to be embedded as an attribute to an HTML img node
    #
    def image_dimensions(input)      
      dims=_dimensions(input);
      w = dims[0]
      h = dims[1]
      "width='#{w.ceil}px' height='#{h.ceil}px'"
    end

    # Returns an expression of width and height to be embedded in CSS or inline-css
    # in the form of two rules: width:XXXpx;height:YYYYpx;
    #
    def image_dimensions_css_rules(input)      
      dims=_dimensions(input);
      w = dims[0]
      h = dims[1]
      "width:#{w.ceil}px;height:#{h.ceil}px;"
    end

    # Returns an expression of width and height as a background-size: Xpx Ypx; rule
    # complete
    #
    def image_dimensions_background_css_rule(input)      
      dims=_dimensions(input);
      w = dims[0]
      h = dims[1]
      "background-size: #{w.ceil}px #{h.ceil}px;"
    end

    # Same as image_dimensions, but if it is called using the hires image name, it will return
    # half the size (which is what you want in your html, since '1px' = '2 real pixels')
    #
    def image_dimensions_hires(input)      
      dims=_dimensions(input);
      w = dims[0]/2
      h = dims[1]/2
      "width='#{w.ceil}px' height='#{h.ceil}px'"
    end

    # Returns image dimensions of a file, but adjusts it to be of a maximum number of pixels based
    # on width.
    #
    def image_dimensions_maxwidth(input, maxwidth)      
      dims=_dimensions(input);
      w = dims[0]
      h = dims[1]
      if w > maxwidth.to_i then
      	h = h*(1.0*maxwidth/w) # scale down, google plugin will take care of generating thumbnail this size, yay google!
      	w = maxwidth
      end
      "width='#{w.ceil}px' height='#{h.ceil}px'"
    end

  end
end

Liquid::Template.register_filter(Jekyll::ImageDimensionsFilter)
