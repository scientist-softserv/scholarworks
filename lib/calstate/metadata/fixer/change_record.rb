# frozen_string_literal: true

module CalState
  module Metadata
    module Fixer
      #
      # Change record
      #
      class ChangeRecord
        # @return [Array]
        attr_reader :changes

        #
        # New change record
        #
        # @param xml_record [Nokogiri::XML]
        #
        def initialize(xml_record)
          @changes = []
          @work = ActiveFedora::Base.find(xml_record['id'])
          fix_abstract(xml_record)
          normalize_resource_type
          fix_degree_level if @work.class.name == 'Thesis'
          fix_xml_chars
        end

        #
        # Save changes to Fedora
        #
        def save
          @work.save
        end

        protected

        #
        # Fix the abstract and notes fields
        #
        # @param record [Nokogiri::XML]
        #
        def fix_abstract(xml_record)
          %w[description description_note].each do |field|
            node_list = xml_record.xpath(field)
            next if node_list.count.zero?

            values = []
            node_list.each do |value|
              values.append value.text
            end

            next if @work[field] == values

            add_change(field, @work[field], values)
            @work[field] = values
          end

          add_change('abstract', @work.abstract, [])
          @work.abstract = []
        end

        #
        # Fix some wonky resource types
        #
        def normalize_resource_type
          return if @work.resource_type.blank?

          type = @work.resource_type.first
          map = {
            'Book chapter' => 'Book Chapter',
            'Book review' => 'Book Review',
            'Capstone project' => 'Capstone Project',
            'Conference proceedings' => 'Conference Proceeding',
            'Conference program' => 'Conference Program',
            'Graduate project' => 'Graduate Project',
            'Internal report' => 'Internal Report',
            'Journal issue' => 'Journal Issue',
            'Learning object' => 'Learning Object',
            'Liner notes' => 'Liner Notes',
            'Masters thesis' => 'Masters Thesis',
            'Published Article' => 'Article',
            'Published article' => 'Article',
            'Sound recording' => 'Sound Recording',
            'Student Reserach' => 'Student Research',
            'Thesis' => 'Masters Thesis'
          }

          return unless map.key?(type)

          add_change('resource_type', @work.resource_type, [map[type]])
          @work.resource_type = [map[type]]
        end

        #
        # Fix degree name (and other stuff) in degree level field
        #
        def fix_degree_level
          return if @work.degree_level.blank?

          outliers = ['1973', '1', '1971', '1972', 'i',
                      'Graduate Project', 'Graduate certificate']
          punc = {
            'B.A' => 'B.A.',
            'BA' => 'B.A.',
            'B.S' => 'B.S.',
            'M' => 'M.',
            'MA' => 'M.A.',
            'M. A.' => 'M.A.',
            'M,A,' => 'M.A.',
            'M.A' => 'M.A.',
            'M.A,' => 'M.A.',
            'M.A..' => 'M.A.',
            'M.Am' => 'M.Am.',
            'MBA' => 'M.B.A.',
            'M. E.' => 'M.E.',
            'M.E.' => 'M.E.',
            'M.F.A' => 'M.F.A.',
            'M.M' => 'M.M.',
            'MPA' => 'M.P.A.',
            'M.P.A' => 'M.P.A.',
            'M.P H.' => 'M.P.H.',
            'M.P.H' => 'M.P.H.',
            'M. S.' => 'M.S.',
            'M.S' => 'M.S.',
            'M.S .' => 'M.S.',
            'MS' => 'M.S.',
            'Ms' => 'M.S.',
            'MSEE' => 'M.S.E.E.',
            'M.S.E.E' => 'M.S.E.E.',
            'MSHM' => 'M.S.H.M.',
            'M.U.R.P' => 'M.U.R.P.',
            'MURP' => 'M.U.R.P.'
          }

          map = {
            'B.A.' => 'Undergraduate',
            'B.M.' => 'Undergraduate',
            'B.S.' => 'Undergraduate',
            'Ed.D.' => 'Doctoral',
            'M.' => 'Masters',
            'M.A.' => 'Masters',
            'M.A.Ed.' => 'Masters',
            'M.Am.' => 'Masters',
            'M.B.A.' => 'Masters',
            'M.E.' => 'Masters',
            'M.Ed.' => 'Masters',
            'M.F.A.' => 'Masters',
            'M.H.A.' => 'Masters',
            'M.L.A.' => 'Masters',
            'M.M.' => 'Masters',
            'M.P.A.' => 'Masters',
            'M.P.H.' => 'Masters',
            'M.P.T.' => 'Masters',
            'M.S.' => 'Masters',
            'M.S.E.M.' => 'Masters',
            'M.S.W.' => 'Masters',
            'M.U.P.' => 'Masters',
            'M.U.R.P.' => 'Masters',
            'M.S.E.E' => 'Masters',
            'M.S.H.M.' => 'Masters',
            'Ph.D.' => 'Doctoral'
          }

          level = @work.degree_level.squish
          original = level.dup
          swap = false

          # fix bad punctuation
          level = punc[level] if punc.key?(level)

          if level == 'doctoral'
            @work.degree_level = 'Doctoral'
          elsif level == 'masters'
            @work.degree_level = 'Masters'
          elsif outliers.include?(level)
            @work.degree_level = nil
          elsif level.include?('Master of')
            @work.degree_level = 'Masters'
            swap = true
          elsif map.key?(level)
            @work.degree_level = map[level]
            swap = true
          elsif level[0..7] == 'Masters '
            @work.degree_level = 'Masters'
            swap = true
          elsif level[0..3] == 'M.S.' || level[0..3] == 'M.A.'
            @work.degree_level = 'Masters'
            swap = true
          elsif level[0..3] == 'B.A.' || level[0..3] == 'B.S.'
            @work.degree_level = 'Undergraduate'
            swap = true
          else
            return nil
          end

          # swap value into degree name field
          if swap
            add_change('degree_name', @work.degree_name, [level])
            @work.degree_name = [level]
          end

          # record degree level change
          add_change('degree_level', original, @work.degree_level)
        end

        #
        # Fix XML characters in fields
        #
        def fix_xml_chars
          attrs = %w[title description description_note subject department]
          attrs.each do |attr|
            field = @work[attr]

            # multi-valued field
            if field.is_a?(ActiveTriples::Relation) || field.is_a?(Array)
              new_values = []
              found = false
              field.each do |value|
                next unless value.include?('&#')

                new_value = clean_value(value)
                new_values.append(new_value)
                found = true
              end

              if found
                add_change(attr, @work[attr], new_values)
                @work[attr] = new_values
              end

            # single-valued field
            else
              next unless field.include?('&#')

              new_value = clean_value(field)
              add_change(attr, @work[attr], new_value)
              @work[attr] = new_value
            end
          end
        end

        #
        # Clean field of XML values
        #
        # @param value [String]
        #
        def clean_value(value)
          value = value.gsub('& ', '&amp; ')
          doc = Nokogiri::XML.fragment(value)
          doc.text.squish
        end

        #
        # Add to changes
        #
        # @param field [String]
        # @param old [String|Array]
        # @param new [String|Array]
        #
        def add_change(field, old, new)
          change = {
            field: field,
            old: old,
            new: new
          }
          @changes.append change
        end
      end
    end
  end
end
