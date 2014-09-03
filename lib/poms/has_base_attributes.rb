module Poms
  module HasBaseAttributes
    def title
      return @title if @title
      main_title = select_title_by_type 'MAIN'
      sub_title = select_title_by_type 'SUB'
      @titel = (sub_title && sub_title.match(main_title)) ? sub_title : [main_title, sub_title].compact.join(": ")
    end

    def description
      @description ||= descriptions.first.value rescue nil
    end

    private

    def select_title_by_type(type)
      titles.select { |t| t.type == type }.map(&:value).first
    end
  end
end
