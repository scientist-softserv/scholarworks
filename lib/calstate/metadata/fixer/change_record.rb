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
          fix_doi
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
        # Fix DOI based on mapping file
        #
        def fix_doi
          map = {
            '10.1002/(SICI)1098-237X(199706)81:3<333::AID-SCE5>3.0.CO;2-E' => 'https://doi.org/10.1002/(SICI)1098-237X(199706)81:3<333::AID-SCE5>3.0.CO;2-E',
            '10.1002/tea.20182' => 'https://doi.org/10.1002/tea.20182',
            'https://doi-org.falcon.lib.csub.edu/10.1002/tea.3660320806' => 'https://doi.org/10.1002/tea.3660320806',
            '10.1007/11840817_50' => 'https://doi.org/10.1007/11840817_50',
            '<a href="http://dx.doi.org/10.1007/978-1-4614-8839-2_27">http://dx.doi.org/10.1007/978-1-4614-8839-2_27</a>' => 'https://doi.org/10.1007/978-1-4614-8839-2_27',
            '<a href="http://dx.doi.org/10.1007/b100500">http://dx.doi.org/10.1007/b100500</a>' => 'https://doi.org/10.1007/b100500',
            'http://dx.doi.org/10.1007/b100500' => 'https://doi.org/10.1007/b100500',
            '10.1016/j.margeo.2020.106376' => 'https://doi.org/10.1016/j.margeo.2020.106376',
            'http://dx.doi.org/10.1016/j.tetlet.2012.05.055' => 'https://doi.org/10.1016/j.tetlet.2012.05.055',
            '10.1017/S1368980021001300' => 'https://doi.org/10.1017/S1368980021001300',
            '10.1021/acsomega.8b02201' => 'https://doi.org/10.1021/acsomega.8b02201',
            '10.1046/j.0266-8254.2003.03701.x-i1' => 'https://doi.org/10.1046/j.0266-8254.2003.03701.x-i1',
            '10.1056/NEJMp1605740' => 'https://doi.org/10.1056/NEJMp1605740',
            '10.1063/1.2217440' => 'https://doi.org/10.1063/1.2217440',
            '10.1080/00031305.2018.1437078' => 'https://doi.org/10.1080/00031305.2018.1437078',
            'https://doi-org.falcon.lib.csub.edu/10.1080/00220979709601397' => 'https://doi.org/10.1080/00220979709601397',
            '10.1080/09644016.2011.573357' => 'https://doi.org/10.1080/09644016.2011.573357',
            '10.1080/17437270802124384' => 'https://doi.org/10.1080/17437270802124384',
            '10.1080/17524032.2011.586713' => 'https://doi.org/10.1080/17524032.2011.586713',
            '10.1080/1941126X.2016.1243436' => 'https://doi.org/10.1080/1941126X.2016.1243436',
            'http://dx.doi.org/10.1080/24694452.2017.1310020' => 'https://doi.org/10.1080/24694452.2017.1310020',
            '10.1086/696582' => 'https://doi.org/10.1086/696582',
            'http://dx.doi.org/10.1098/rspb.2015.2830' => 'https://doi.org/10.1098/rspb.2015.2830',
            'http://link.aps.org/doi/10.1103/PhysRevB.59.8943' => 'https://doi.org/10.1103/PhysRevB.59.8943',
            'DOI: 10.1103/PhysRevB.59.8943' => 'https://doi.org/10.1103/PhysRevB.59.8943',
            '10.1103/PhysRevD.101.034501' => 'https://doi.org/10.1103/PhysRevD.101.034501',
            '10.1103/PhysRevD.101.054512' => 'https://doi.org/10.1103/PhysRevD.101.054512',
            '10.1103/PhysRevD.101.094510' => 'https://doi.org/10.1103/PhysRevD.101.094510',
            '10.1103/PhysRevD.98.094502' => 'https://doi.org/10.1103/PhysRevD.98.094502',
            '10.1109/ACCESS.2019.2911098' => 'https://doi.org/10.1109/ACCESS.2019.2911098',
            '10.1113/ep089438' => 'https://doi.org/10.1113/ep089438',
            '10.1126/sciadv.aat9533' => 'https://doi.org/10.1126/sciadv.aat9533',
            '10.1136/bmjopen-2019-029616' => 'https://doi.org/10.1136/bmjopen-2019-029616',
            '10.1155/2020/3859472' => 'https://doi.org/10.1155/2020/3859472',
            '10.1177/0003702820920652' => 'https://doi.org/10.1177/0003702820920652',
            'https://doi.org/10.1177%2F0003702820920652' => 'https://doi.org/10.1177/0003702820920652',
            'https://doi.org/10.1177%2F0003702820930292' => 'https://doi.org/10.1177/0003702820930292',
            'https://doi.org/10.1177%2F0003702820945713' => 'https://doi.org/10.1177/0003702820945713',
            'https://doi.org/10.1177%2F0092055X19831329' => 'https://doi.org/10.1177/0092055X19831329',
            '10.1186/s13690-018-0307-z' => 'https://doi.org/10.1186/s13690-018-0307-z',
            '10.1353/pla.2019.0015' => 'https://doi.org/10.1353/pla.2019.0015',
            '10.1371/journal.pone.0207975' => 'https://doi.org/10.1371/journal.pone.0207975',
            '10.1504/ijbg.2015.066098' => 'https://doi.org/10.1504/ijbg.2015.066098',
            'http://dx.doi.org/10.18374/IJBR-18-4.8' => 'https://doi.org/10.18374/IJBR-18-4.8',
            'DOI: 10.2968/064005005' => 'https://doi.org/10.2968/064005005',
            '10.3389/feart.2019.00074' => 'https://doi.org/10.3389/feart.2019.00074',
            '10.3389/feart.2019.00113' => 'https://doi.org/10.3389/feart.2019.00113',
            '10.3389/fpsyg.2018.02448' => 'https://doi.org/10.3389/fpsyg.2018.02448',
            '10.3390/ijerph15112477' => 'https://doi.org/10.3390/ijerph15112477',
            '10.3390/ijerph16030372' => 'https://doi.org/10.3390/ijerph16030372',
            '10.3390/ijerph16071108' => 'https://doi.org/10.3390/ijerph16071108',
            '10.3390/su11164347' => 'https://doi.org/10.3390/su11164347',
            'doi:10.5539/ies.v5n1p137' => 'https://doi.org/10.5539/ies.v5n1p137',
            'doi:10.5539/ies.v6n1p111' => 'https://doi.org/10.5539/ies.v6n1p111',
            'http://library.humboldt.edu/infoservices/indexes/tutorials/ase/' => nil,
            'http://library.humboldt.edu/infoservices/indexes/tutorials/omnifile/' => nil,
            'https://babel.hathitrust.org/cgi/pt?id=mdp.39015077514894&view=1up&seq=45&q1=vivian' => nil,
            'https://digitalcommons.du.edu/collaborativelibrarianship/vol12/iss1/10' => nil,
            'https://hdl.handle.net/2027/mdp.39015077514894?urlappend=%3Bseq=45' => nil,
            'https://hdl.handle.net/2027/mdp.39015077514928?urlappend=%3Bseq=79' => nil,
            'https://hdl.handle.net/2027/mdp.39015077515172?urlappend=%3Bseq=7' => nil,
            'https://hdl.handle.net/2027/mdp.39015077515222?urlappend=%3Bseq=39' => nil,
            'https://www.jstor.org/stable/20405757' => nil,
            'https://www.jstor.org/stable/20439359' => nil,
          }

          return unless map.key?(@work.doi.first)

          new = map[@work.doi]

          if new.nil? # this is not really a doi
            @work.related_url = @work.doi
            @work.doi = []
          else
            @work.doi = [new]
          end
        end

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

          if @work.degree_level.blank?
            if @work.resource_type.first == 'Masters Thesis'
              @work.degree_level = 'Masters'
            elsif @work.resource_type.first == 'Dissertation'
              @work.degree_level = 'Doctoral'
            end
            return
          end

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

        #
        # Get mapping file
        #
        # @param name [String]  name of file (sans folder and extension)
        #
        def get_mapping_file(name)
          mapping = {}
          path = File.expand_path('mapping/' + name + '.txt', __dir__)
          content = File.read(path)
          lines = content.split("\n")
          lines.each do |line|
            parts = line.split("\t")
            mapping[parts[0]] = parts[1]
          end

          mapping
        end
      end
    end
  end
end
