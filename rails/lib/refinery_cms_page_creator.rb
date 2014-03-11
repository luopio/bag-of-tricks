#coding=utf-8

class PageCreator

  def initialize master_locale
    @master_locale = master_locale
  end

  def recursive_destroy_page page
    return unless page
    page.children.each do |child|
      recursive_destroy_page child
    end
    puts "--- Remove page #{page}"
    page.deletable = true
    page.save
    page.destroy!
  end


  # Create pages from external data. Bit of dedicated format, will require 
  # work to function in different context
  def recursive_create_page(page, parent=nil)
    Globalize.locale = @master_locale
    puts "#{page['title']}"
    p = Refinery::Page.find_by_title page['title']
    if not p or p.parent != parent
      puts "+++ Create page #{page['title']} (#{page['type']})"
      if parent then
        p = parent.children.create :title => page['title'],
                                   :deletable => false,
                                   :view_template => page['type']
      else
        p = Refinery::Page.create :title => page['title'],
                                  :deletable => false,
                                  :view_template => page['type']
      end
    else
      puts "  === Found existing page #{page['title']} (#{page['type']})"
    end
    if page.has_key?('skip_to_first_child') and page['skip_to_first_child'] != p.skip_to_first_child
      p.skip_to_first_child = page['skip_to_first_child']
      p.save
    end
    if page['parts'] then
      page['parts'].each_pair do |key, part|
        puts "  ++ create page part #{key}"
        pp = p.parts.find_by_title(key)
        pp.body = part.strip
        pp.save
      end
    end
    if page['children'] then
      page['children'].each do |child|
        recursive_create_page child, p
      end
    end
  end

  def import_to_pages parent_pages, import_data, view_template='article', import_tabs_as_pages=false
    Globalize.locale = @master_locale
    parent_pages.each do |k, v|
      raise "Can't find page #{k}" unless v
    end
    parent_pages.each { |_, c| c.children.each { |cc| cc.destroy! } }
    import_data.each do |recipe|
      print "\n#{recipe[:id]}: "
      page = nil
      master_locale = Refinery::I18n.config.frontend_locales[0]
      master_locale_data = recipe[:lang][master_locale]
      Refinery::I18n.config.frontend_locales.each do |loc|
        Globalize.locale = loc
        d = recipe[:lang][loc]
        recipe[:lang][:category]['name'].strip!
        next unless d
        parent = parent_pages[recipe[:lang][:category]['name']]
        print "\n'#{d[:name]}' (#{loc}) parent: '#{recipe[:lang][:category]['name']}'"
        unless page
          page = parent.children.create title: d[:name],
                                        ext_id: recipe[:id],
                                        view_template: view_template
          print " | NEW #{view_template}"
        else
          page.translations.create title: d[:name], locale: loc
          print " | TRANSLATION "
        end

        if import_tabs_as_pages
          page.skip_to_first_child = true
          page.save!
        end

        # Has only :text field => create one part page or translation of one
        if d[:text] and not import_tabs_as_pages
          mt = 'Body'
          pp = page.parts.find_by_title mt
          print "\n -- PP title (1) #{mt} "
          unless pp
            page.parts.create! title: mt, body: d[:text]
            print "NEW"
          else
            translation = pp.translations.find_by_locale loc
            if translation
              print " (exists translation) "
              translation.body = d[:text]
              translation.save
            else
              pp.translations.create! body: d[:text], locale: loc
            end
            print "TRANSLATE"
          end
        # Has only :text field, but we want tabs as pages => create one child page
        elsif d[:text] and import_tabs_as_pages
          Globalize.locale = master_locale
          mt = page.title
          pagepage = page.children.find_by_title mt
          puts "SINGLE TAB FIX find a child of #{page.title} with title #{mt}"
          Globalize.locale = loc
          unless pagepage
            pagepage = page.children.create title: mt, view_template: view_template
            pagepage.parts.create(:title => 'Body', :body => d[:text])
          else
            pagepage.translations.create title: page.title, locale: loc
            pagepage.parts.find_by_title('Body').translations.create :body => d[:text], :locale => loc
          end
        # has several tabs, go through and create parts or child pages
        else
          ['tab1', 'tab2', 'tab3', 'tab4', 'tab5', 'tab6'].each do |tab|
            next unless d[tab]
            mt = master_locale_data[tab][:title]
            unless import_tabs_as_pages
              mt = 'Body' if mt.empty?
              pp = page.parts.find_by_title mt
              print "\n -- PP title #{mt} => need new? #{pp.nil?} = "
              unless pp
                pp = page.parts.create(:title => mt, :body => d[tab][:content])
                print "NEW #{page.parts.length}"
              else
                pp.translations.create :body => d[tab][:content], :locale => loc
                print "TRANSLATE #{page.parts.length}"
              end
            else
              # instead of creating new page parts for each tab, create whole pages
              # (this is required for pages that have individual, unique tabs)
              # raise "No tab title defined, but require that tabs are created as pages. Such wrong!" if mt.empty?
              Globalize.locale = master_locale
              if mt.empty?
                mt = page.title
              end
              pagepage = page.children.find_by_title mt
              puts "find a child of #{page.title} with title #{mt}"
              Globalize.locale = loc
              puts "=> #{page.title}, #{mt}"
              print "\n -- PAGE_AS_TAB title #{mt} => need new? #{pagepage.nil?} = "
              unless pagepage
                pagepage = page.children.create title: mt, view_template: view_template
                existing_part = pagepage.parts.find_by_title 'Body'
                if existing_part
                  existing_part.body = d[tab][:content]
                  existing_part.save
                else
                  pagepage.parts.create!(:title => 'Body', :body => d[tab][:content])
                end

                print " | PAGE_AS_TAB NEW #{view_template} #{d[tab][:content].length}"
              else
                pagepage.translations.create title: d[tab][:title], locale: loc
                pagepage.parts.find_by_title('Body').translations.create :body => d[tab][:content], :locale => loc
                print " | PAGE_AS_TAB TRANSLATION"
              end
            end
          end
        end
        print "\n"
      end
      recipe[:lang][:images].uniq.each do |im_id|
        #p "look for image #{im_id}"
        image = Refinery::Image.find_by_ext_id im_id
        unless image
          p "Failed to find image with old id #{im_id} for #{page.id} #{page.title}"
        else
          if import_tabs_as_pages
            page.children.each { |p| p.images << image }
          end
          page.images << image
        end
      end
    end
  end
end