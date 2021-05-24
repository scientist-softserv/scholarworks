# services/discipline_service.rb
module DisciplineService
  #
  # Provides array of top disciplines and hash of all disciplines
  #

  # classes to provide an access to attributes for javascript
  class Discipline
    attr_reader :name, :children, :ancestor

    def initialize(name, children, ancestor)
      @name = name
      @children = children
      @ancestor = ancestor
    end
  end

  class SimpleDiscipline
    attr_reader :id, :name;

    def initialize(id, name)
      @id = id
      @name = name
    end
  end

  TOP_DISCIPLINES = [
      SimpleDiscipline.new("1", "Architecture").freeze,
      SimpleDiscipline.new("2", "Arts and Humanities").freeze,
      SimpleDiscipline.new("3", "Business").freeze,
      SimpleDiscipline.new("4", "Education").freeze,
      SimpleDiscipline.new("5", "Engineering").freeze,
      SimpleDiscipline.new("6", "Law").freeze
  ].freeze

  DISCIPLINES = {
      # Architecture tree
      "1" => Discipline.new("Architecture", %w[21 22 23 24 1001 26 27 28 29 30 31], %w[]).freeze,
        "21" => Discipline.new("Architectural Engineering", %w[], %w[1]).freeze,
        "22" => Discipline.new("Architectural History and Criticism", %w[], %w[1]).freeze,
        "23" => Discipline.new("Architectural Technology", %w[], %w[1]).freeze,
        "24" => Discipline.new("Construction Engineering", %w[], %w[1]).freeze,
        "1001" => Discipline.new("Cultural Resource Management and Policy Analysis", %w[], %w[1]).freeze,
        "26" => Discipline.new("Environmental Design", %w[], %w[1]).freeze,
        "27" => Discipline.new("Historic Preservation and Conservation", %w[], %w[1]).freeze,
        "28" => Discipline.new("Interior Architecture", %w[], %w[1]).freeze,
        "29" => Discipline.new("Landscape Architecture", %w[], %w[1]).freeze,
        "30" => Discipline.new("Urban, Community and Regional Planning", %w[], %w[1]).freeze,
        "31" => Discipline.new("Other Architecture", %w[], %w[1]).freeze,
      # Arts and Humanities tree
      "2" => Discipline.new("Arts and Humanities", %w[32 33 39 40 58 59 60 61 62 63 72 74 78 79 80 84 91 92 93 94 95 96 101 102 106 110 136 144 148 150 151 153 154 155 156 157 168 169 175 191 192 199 200 201 221 224 225 227 230 231 237 238 239 247 248], %w[]).freeze,
        "32" => Discipline.new("African Languages and Societies", %w[], %w[2]).freeze,
        # American Studies subtree
        "33" => Discipline.new("American Studies", %w[34 35 36 37 38], %w[2]).freeze,
          "34" => Discipline.new("American Film Studies", %w[], %w[2 33]).freeze,
          "35" => Discipline.new("American Literature", %w[], %w[2 33]).freeze,
          "36" => Discipline.new("American Material Culture", %w[], %w[2 33]).freeze,
          "37" => Discipline.new("American Popular Culture", %w[], %w[2 33]).freeze,
          "38" => Discipline.new("Other American Studies", %w[], %w[2 33]).freeze,
        "39" => Discipline.new("Appalachian Studies", %w[], %w[2]).freeze,
        # Art and Design subtree
        "40" => Discipline.new("Art and Design", %w[41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57], %w[2]).freeze,
          "41" => Discipline.new("Art and Materials Conservation", %w[], %w[2 40]).freeze,
          "42" => Discipline.new("Book and Paper", %w[], %w[2 40]).freeze,
          "43" => Discipline.new("Ceramic Arts", %w[], %w[2 40]).freeze,
          "44" => Discipline.new("Fashion Design", %w[], %w[2 40]).freeze,
          "45" => Discipline.new("Fiber, Textile, and Weaving Arts", %w[], %w[2 40]).freeze,
          "46" => Discipline.new("Furniture Design", %w[], %w[2 40]).freeze,
          "47" => Discipline.new("Game Design", %w[], %w[2 40]).freeze,
          "48" => Discipline.new("Glass Arts", %w[], %w[2 40]).freeze,
          "49" => Discipline.new("Graphic Design", %w[], %w[2 40]).freeze,
          "50" => Discipline.new("Illustration", %w[], %w[2 40]).freeze,
          "51" => Discipline.new("Industrial and Product Design", %w[], %w[2 40]).freeze,
          "52" => Discipline.new("Interactive Arts", %w[], %w[2 40]).freeze,
          "53" => Discipline.new("Interdisciplinary Arts and Media", %w[], %w[2 40]).freeze,
          "54" => Discipline.new("Metal and Jewelry Arts", %w[], %w[2 40]).freeze,
          "55" => Discipline.new("Painting", %w[], %w[2 40]).freeze,
          "56" => Discipline.new("Printmaking", %w[], %w[2 40]).freeze,
          "57" => Discipline.new("Sculpture", %w[], %w[2 40]).freeze,
        "58" => Discipline.new("Art Practice", %w[], %w[2]).freeze,
        "59" => Discipline.new("Audio Arts and Acoustics", %w[], %w[2]).freeze,
        "60" => Discipline.new("Australian Studies", %w[], %w[2]).freeze,
        "61" => Discipline.new("Basque Studies", %w[], %w[2]).freeze,
        "62" => Discipline.new("Celtic Studies", %w[], %w[2]).freeze,
        # Classics subtree
        "63" => Discipline.new("Classics", %w[65 66 67 68 69 70 71], %w[2]).freeze,
          "65" => Discipline.new("Ancient History, Greek and Roman through Late Antiquity", %w[], %w[2 63]).freeze,
          "66" => Discipline.new("Ancient Philosophy", %w[], %w[2 63]).freeze,
          "67" => Discipline.new("Byzantine and Modern Greek", %w[], %w[2 63]).freeze,
          "68" => Discipline.new("Classical Archaeology and Art History", %w[], %w[2 63]).freeze,
          "69" => Discipline.new("Classical Literature and Philology", %w[], %w[2 63]).freeze,
          "70" => Discipline.new("Indo-European Linguistics and Philology", %w[], %w[2 63]).freeze,
          "71" => Discipline.new("Other Classics", %w[], %w[2 63]).freeze,
        # Comparative Literature subtree
        "72" => Discipline.new("Comparative Literature", %w[73], %w[2]).freeze,
          "73" => Discipline.new("Translation Studies", %w[], %w[2 72]).freeze,
        # Creative Writing subtree
        "74" => Discipline.new("Creative Writing", %w[75 76 77], %w[2]).freeze,
          "75" => Discipline.new("Fiction", %w[], %w[2 74]).freeze,
          "76" => Discipline.new("Nonfiction", %w[], %w[2 74]).freeze,
          "77" => Discipline.new("Poetry", %w[], %w[2 74]).freeze,
        "78" => Discipline.new("Digital Humanities", %w[], %w[2]).freeze,
        "79" => Discipline.new("Dutch Studies", %w[], %w[2]).freeze,
        # East Asian Languages and Societies subtree
        "80" => Discipline.new("East Asian Languages and Societies", %w[81 82 83], %w[2]).freeze,
          "81" => Discipline.new("Chinese Studies", %w[], %w[2 80]).freeze,
          "82" => Discipline.new("Japanese Studies", %w[], %w[2 80]).freeze,
          "83" => Discipline.new("Korean Studies", %w[], %w[2 80]).freeze,
        # English Language and Literature subtree
        "84" => Discipline.new("English Language and Literature", %w[85 86 87 88 89 90], %w[2]).freeze,
          "85" => Discipline.new("Children's and Young Adult Literature", %w[], %w[2 84]).freeze,
          "86" => Discipline.new("Literature in English, Anglophone outside British Isles and North America", %w[], %w[2]).freeze,
          "87" => Discipline.new("Literature in English, British Isles", %w[], %w[2 84]).freeze,
          "88" => Discipline.new("Literature in English, North America", %w[], %w[2 84]).freeze,
          "89" => Discipline.new("Literature in English, North America, Ethnic and Cultural Minority", %w[], %w[2 84]).freeze,
          "90" => Discipline.new("Other English Language and Literature", %w[], %w[2 84]).freeze,
        "91" => Discipline.new("European Languages and Societies", %w[], %w[2]).freeze,
        # Feminist, Gender, and Sexuality Studies subtree
        "92" => Discipline.new("Feminist, Gender, and Sexuality Studies", %w[93 94 95], %w[2]).freeze,
        "93" => Discipline.new("Feminist, Gender, and Sexuality Studies: Lesbian, Gay, Bisexual, and Transgender Studies", %w[], %w[2]).freeze,
        "94" => Discipline.new("Feminist, Gender, and Sexuality Studies: Women's Studies", %w[], %w[2]).freeze,
        "95" => Discipline.new("Feminist, Gender, and Sexuality Studies: Other Feminist, Gender, and Sexuality Studies", %w[], %w[2]).freeze,
        # Film and Media Studies subtree
        "96" => Discipline.new("Film and Media Studies", %w[97 98 99 100], %w[2]).freeze,
          "97" => Discipline.new("Film Production", %w[], %w[2 96]).freeze,
          "98" => Discipline.new("Screenwriting", %w[], %w[2 96]).freeze,
          "99" => Discipline.new("Visual Studies", %w[], %w[2 96]).freeze,
          "100" => Discipline.new("Other Film and Media Studies", %w[], %w[2 96]),
        "101" => Discipline.new("Fine Arts", %w[], %w[2]).freeze,
        # French and Francophone Language and Literature subtree
        "102" => Discipline.new("French and Francophone Language and Literature", %w[103 104 105], %w[2]).freeze,
          "103" => Discipline.new("French and Francophone Literature", %w[], %w[2 102]).freeze,
          "104" => Discipline.new("French Linguistics", %w[], %w[2 102]).freeze,
          "105" => Discipline.new("French and Francophone Language and Literature", %w[], %w[2 102]).freeze,
        # German Language and Literature subtree
        "106" => Discipline.new("German Language and Literature", %w[107 108 109], %w[2]).freeze,
          "107" => Discipline.new("German Linguistics", %w[], %w[2 106]).freeze,
          "108" => Discipline.new("German Literature", %w[], %w[2 106]).freeze,
          "109" => Discipline.new("Other German Language and Literature", %w[], %w[2 106]).freeze,
        # History subtree
        "110" => Discipline.new("History", %w[111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135], %w[2]).freeze,
          "111" => Discipline.new("African History", %w[], %w[2 110]).freeze,
          "112" => Discipline.new("Asian History", %w[], %w[2 110]).freeze,
          "113" => Discipline.new("Canadian History", %w[], %w[2 110]).freeze,
          "114" => Discipline.new("Cultural History", %w[], %w[2 110]).freeze,
          "115" => Discipline.new("Diplomatic History", %w[], %w[2 110]).freeze,
          "116" => Discipline.new("European History", %w[], %w[2 110]).freeze,
          "117" => Discipline.new("Genealogy", %w[], %w[2 110]).freeze,
          "118" => Discipline.new("History of Gender", %w[], %w[2 110]).freeze,
          "119" => Discipline.new("History of the Pacific Islands", %w[], %w[2 110]).freeze,
          "120" => Discipline.new("History of Religion", %w[], %w[2 110]).freeze,
          "121" => Discipline.new("History of Science, Technology, and Medicine", %w[], %w[2 110]).freeze,
          "122" => Discipline.new("Intellectual History", %w[], %w[2 110]).freeze,
          "123" => Discipline.new("Islamic World and Near East History", %w[], %w[2 110]).freeze,
          "124" => Discipline.new("Labor History", %w[], %w[2 110]).freeze,
          "125" => Discipline.new("Latin American History", %w[], %w[2 110]).freeze,
          "126" => Discipline.new("Legal", %w[], %w[2 110]).freeze,
          "127" => Discipline.new("Medieval History", %w[], %w[2 110]).freeze,
          "128" => Discipline.new("Military History", %w[], %w[2 110]).freeze,
          "129" => Discipline.new("Oral History", %w[], %w[2 110]).freeze,
          "130" => Discipline.new("Political History", %w[], %w[2 110]).freeze,
          "131" => Discipline.new("Public History", %w[], %w[2 110]).freeze,
          "132" => Discipline.new("Social History", %w[], %w[2 110]).freeze,
          "133" => Discipline.new("United States History", %w[], %w[2 110]).freeze,
          "134" => Discipline.new("Women's History", %w[], %w[2 110]).freeze,
          "135" => Discipline.new("Other History", %w[], %w[2 110]).freeze,
        # History of Art, Architecture, and Archaeology subtree
        "136" => Discipline.new("History of Art, Architecture, and Archaeology", %w[137 138 139 140 141 142 143], %w[2 110]).freeze,
          "137" => Discipline.new("American Art and Architecture", %w[], %w[2 136]).freeze,
          "138" => Discipline.new("Ancient, Medieval, Renaissance and Baroque Art and Architecture", %w[], %w[2 136]).freeze,
          "139" => Discipline.new("Asian Art and Architecture", %w[], %w[2 136]).freeze,
          "140" => Discipline.new("Contemporary Art", %w[], %w[2 136]).freeze,
          "141" => Discipline.new("Modern Art and Architecture", %w[], %w[2 136]).freeze,
          "142" => Discipline.new("Theory and Criticism", %w[], %w[2 136]).freeze,
          "143" => Discipline.new("Other History of Art, Architecture, and Archaeology", %w[], %w[2 136]).freeze,
        # Italian Language and Literature subtree
        "144" => Discipline.new("Italian Language and Literature", %w[145 146 147], %w[2]).freeze,
          "145" => Discipline.new("Italian Linguistics", %w[], %w[2 144]).freeze,
          "146" => Discipline.new("Italian Literature", %w[], %w[2 144]).freeze,
          "147" => Discipline.new("Other Italian Language and Literature", %w[], %w[2 144]).freeze,
        # Jewish Studies subtree
        "148" => Discipline.new("Jewish Studies", %w[149], %w[2]).freeze,
          "149" => Discipline.new("Yiddish Language and Literature", %w[], %w[2 148]).freeze,
        "150" => Discipline.new("Language Interpretation and Translation", %w[], %w[2]).freeze,
        # Latin American Languages and Societies subtree
        "151" => Discipline.new("Latin American Languages and Societies", %w[152], %w[2]).freeze,
          "152" => Discipline.new("Caribbean Languages and Societies", %w[], %w[2 144]).freeze,
        "153" => Discipline.new("Medieval Studies", %w[], %w[2]).freeze,
        "154" => Discipline.new("Modern Languages", %w[], %w[2]).freeze,
        "155" => Discipline.new("Modern Literature", %w[], %w[2]).freeze,
        "156" => Discipline.new("Museum Studies", %w[], %w[2]).freeze,
        # Music subtree
        "157" => Discipline.new("Music", %w[158 159 160 161 162 163 164 165 166 167], %w[2]).freeze,
          "158" => Discipline.new("Composition", %w[], %w[2 157]).freeze,
          "159" => Discipline.new("Ethnomusicology", %w[], %w[2 157]).freeze,
          "160" => Discipline.new("Music Education", %w[], %w[2 157]).freeze,
          "161" => Discipline.new("Music Practice", %w[], %w[2 157]).freeze,
          "162" => Discipline.new("Music Theory", %w[], %w[2 157]).freeze,
          "163" => Discipline.new("Musicology", %w[], %w[2 157]).freeze,
          "164" => Discipline.new("Music Pedagogy", %w[], %w[2 157]).freeze,
          "165" => Discipline.new("Music Performance", %w[], %w[2 157]).freeze,
          "166" => Discipline.new("Music Therapy", %w[], %w[2 157]).freeze,
          "167" => Discipline.new("Other Music", %w[], %w[2 157]).freeze,
        "168" => Discipline.new("Near Eastern Languages and Societies", %w[], %w[2]).freeze,
        # Pacific Islands Languages and Societies subtree
        "169" => Discipline.new("Pacific Islands Languages and Societies", %w[171 172 173 174], %w[2]).freeze,
          "171" => Discipline.new("Hawaiian Studies", %w[], %w[2 169]).freeze,
          "172" => Discipline.new("Melanesian Studies", %w[], %w[2 169]).freeze,
          "173" => Discipline.new("Micronesian Studies", %w[], %w[2 169]).freeze,
          "174" => Discipline.new("Polynesian Studies", %w[], %w[2 169]).freeze,
        # Philosophy subtree
        "175" => Discipline.new("Philosophy", %w[176 177 178 179 180 181 182 184 185 186 187 188 189 190], %w[2]).freeze,
          "176" => Discipline.new("Applied Ethics", %w[], %w[2 175]).freeze,
          "177" => Discipline.new("Comparative Philosophy", %w[], %w[2 175]).freeze,
          "178" => Discipline.new("Continental Philosophy", %w[], %w[2 175]).freeze,
          "179" => Discipline.new("Epistemology", %w[], %w[2 175]).freeze,
          "180" => Discipline.new("Esthetics", %w[], %w[2 175]).freeze,
          "181" => Discipline.new("Ethics and Political Philosophy", %w[], %w[2 175]).freeze,
          "182" => Discipline.new("Feminist Philosophy", %w[], %w[2 175]).freeze,
          "184" => Discipline.new("History of Philosophy", %w[], %w[2 175]).freeze,
          "185" => Discipline.new("Logic and Foundations of Mathematics", %w[], %w[2 175]).freeze,
          "186" => Discipline.new("Metaphysics", %w[], %w[2 175]).freeze,
          "187" => Discipline.new("Philosophy of Language", %w[], %w[2 175]).freeze,
          "188" => Discipline.new("Philosophy of Mind", %w[], %w[2 175]).freeze,
          "189" => Discipline.new("Philosophy of Science", %w[], %w[2 175]).freeze,
          "190" => Discipline.new("Other Philosophy", %w[], %w[2 175]).freeze,
        "191" => Discipline.new("Photography", %w[], %w[2]).freeze,
        # Race, Ethnicity and Post-Colonial Studies subtree
        "192" => Discipline.new("Race, Ethnicity and Post-Colonial Studies", %w[193 194 195 196 197 198], %w[2]).freeze,
          "193" => Discipline.new("African American Studies", %w[], %w[2 192]).freeze,
          "194" => Discipline.new("Asian American Studies", %w[], %w[2 192]).freeze,
          "195" => Discipline.new("Chicana/o Studies", %w[], %w[2 192]).freeze,
          "196" => Discipline.new("Ethnic Studies", %w[], %w[2 192]).freeze,
          "197" => Discipline.new("Indigenous Studies", %w[], %w[2 192]).freeze,
          "198" => Discipline.new("Latina/o Studies", %w[], %w[2 192]).freeze,
        "199" => Discipline.new("Radio", %w[], %w[2]).freeze,
        "200" => Discipline.new("Reading and Language", %w[], %w[2 192]).freeze,
        # Religion subtree
        "201" => Discipline.new("Religion", %w[202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220], %w[2]).freeze,
          "202" => Discipline.new("Biblical Studies", %w[], %w[2 201]).freeze,
          "203" => Discipline.new("Buddhist Studies", %w[], %w[2 201]).freeze,
          "204" => Discipline.new("Catholic Studies", %w[], %w[2 201]).freeze,
          "205" => Discipline.new("Christianity", %w[], %w[2 201]).freeze,
          "206" => Discipline.new("Christian Denominations and Sects", %w[], %w[2 201]).freeze,
          "207" => Discipline.new("Comparative Methodologies and Theories", %w[], %w[2 201]).freeze,
          "208" => Discipline.new("Ethics in Religion", %w[], %w[2 201]).freeze,
          "209" => Discipline.new("Hindu Studies", %w[], %w[2 201]).freeze,
          "210" => Discipline.new("History of Christianity", %w[], %w[2 201]).freeze,
          "211" => Discipline.new("History of Religions of Eastern Origins", %w[], %w[2 201]).freeze,
          "212" => Discipline.new("History of Religions of Western Origin", %w[], %w[2 201]).freeze,
          "213" => Discipline.new("Islamic Studies", %w[], %w[2 201]).freeze,
          "214" => Discipline.new("Liturgy and Worship", %w[], %w[2 201]).freeze,
          "215" => Discipline.new("Missions and World Christianity", %w[], %w[2 201]).freeze,
          "216" => Discipline.new("Mormon Studies", %w[], %w[2 201]).freeze,
          "217" => Discipline.new("New Religious Movements", %w[], %w[2 201]).freeze,
          "218" => Discipline.new("Practical Theology", %w[], %w[2 201]).freeze,
          "219" => Discipline.new("Religious Thought, Theology and Philosophy of Religion", %w[], %w[2 201]).freeze,
          "220" => Discipline.new("Other Religion", %w[], %w[2 201]).freeze,
        # Rhetoric and Composition subtree
        "221" => Discipline.new("Rhetoric and Composition", %w[222 223], %w[2]).freeze,
          "222" => Discipline.new("Rhetoric", %w[], %w[2 221]).freeze,
          "223" => Discipline.new("Other Rhetoric and Composition", %w[], %w[2 221]).freeze,
        "224" => Discipline.new("Scandinavian Studies", %w[], %w[2 221]).freeze,
        # Sign Languages subtree
        "225" => Discipline.new("Sign Languages", %w[226], %w[2]).freeze,
          "226" => Discipline.new("American Sign Language", %w[], %w[2 225]).freeze,
        # Slavic Languages and Societies subtree
        "227" => Discipline.new("Slavic Languages and Societies", %w[228 229], %w[2]).freeze,
          "228" => Discipline.new("Slavic Languages and Societies", %w[], %w[2 227]).freeze,
          "229" => Discipline.new("Russian Literature", %w[], %w[2 227]).freeze,
        "230" => Discipline.new("South and Southeast Asian Languages and Societies", %w[], %w[2]).freeze,
        # Spanish and Portuguese Language and Literature subtree
        "231" => Discipline.new("Spanish and Portuguese Language and Literature", %w[232 233 234 235 236], %w[2]).freeze,
          "232" => Discipline.new("Latin American Literature", %w[], %w[2 231]).freeze,
          "233" => Discipline.new("Portuguese Literature", %w[], %w[2 231]).freeze,
          "234" => Discipline.new("Spanish Linguistics", %w[], %w[2 231]).freeze,
          "235" => Discipline.new("Spanish Literature", %w[], %w[2 231]).freeze,
          "236" => Discipline.new("Other Spanish and Portuguese Language and Literature", %w[], %w[2 231]).freeze,
        "237" => Discipline.new("Technical and Professional Writing", %w[], %w[2]).freeze,
        "238" => Discipline.new("Television", %w[], %w[2]).freeze,
        # Theatre and Performance Studies subtree
        "239" => Discipline.new("Theatre and Performance Studies", %w[240 241 242 243 244 245 246], %w[2]).freeze,
          "240" => Discipline.new("Acting", %w[], %w[2 239]).freeze,
          "241" => Discipline.new("Dance", %w[], %w[2 239]).freeze,
          "242" => Discipline.new("Dramatic Literature, Criticism and Theory", %w[], %w[2 239]).freeze,
          "243" => Discipline.new("Performance Studies", %w[], %w[2 239]).freeze,
          "244" => Discipline.new("Playwriting", %w[], %w[2 239]).freeze,
          "245" => Discipline.new("Theatre History", %w[], %w[2 239]).freeze,
          "246" => Discipline.new("Other Theatre and Performance Studies", %w[], %w[2 239]).freeze,
        "247" => Discipline.new("Other Arts and Humanities", %w[], %w[2]).freeze,
        "248" => Discipline.new("Other Languages, Societies, and Cultures", %w[], %w[2]).freeze,
      # Business tree
      "3" => Discipline.new("Business", %w[249 250 251 252 253 254 255 256 257 258 259 260 261 262 263 266 270 271 272 276 277 278 280 281 282 283 284 285 286 287 288 289 290 291 292], %w[]).freeze,
        "249" => Discipline.new("Accounting", %w[], %w[3]).freeze,
        "250" => Discipline.new("Advertising and Promotion Management", %w[], %w[3]).freeze,
        "251" => Discipline.new("Agribusiness", %w[], %w[3]).freeze,
        "252" => Discipline.new("Arts Management", %w[], %w[3]).freeze,
        "253" => Discipline.new("Business Administration, Management, and Operations", %w[], %w[3]).freeze,
        "254" => Discipline.new("Business Analytics", %w[], %w[3]).freeze,
        "255" => Discipline.new("Business and Corporate Communications", %w[], %w[3]).freeze,
        "256" => Discipline.new("Business Intelligence", %w[], %w[3]).freeze,
        "257" => Discipline.new("Business Law, Public Responsibility, and Ethics", %w[], %w[3]).freeze,
        "258" => Discipline.new("Corporate Finance", %w[], %w[3]).freeze,
        "259" => Discipline.new("E-Commerce", %w[], %w[3]).freeze,
        "260" => Discipline.new("Entrepreneurial and Small Business Operations", %w[], %w[3]).freeze,
        "261" => Discipline.new("Fashion Business", %w[], %w[3]).freeze,
        "262" => Discipline.new("Finance and Financial Management", %w[], %w[3]).freeze,
        # Hospitality Administration and Management subtree
        "263" => Discipline.new("Hospitality Administration and Management", %w[264 265], %w[3]).freeze,
          "264" => Discipline.new("Food and Beverage Management", %w[], %w[3 263]).freeze,
          "265" => Discipline.new("Gaming and Casino Operations Management", %w[], %w[3 263]).freeze,
        # Human Resources Management subtree
        "266" => Discipline.new("Human Resources Management", %w[267 268 269], %w[3]).freeze,
          "267" => Discipline.new("Benefits and Compensation", %w[], %w[3 266]).freeze,
          "268" => Discipline.new("Performance Management", %w[], %w[3 266]).freeze,
          "269" => Discipline.new("Training and Development", %w[], %w[3 266]).freeze,
        "270" => Discipline.new("Insurance", %w[], %w[3]).freeze,
        "271" => Discipline.new("International Business", %w[], %w[3]).freeze,
        # Labor Relations subtree
        "272" => Discipline.new("Labor Relations", %w[273 274 275], %w[3]).freeze,
          "273" => Discipline.new("Collective Bargaining", %w[], %w[3 272]).freeze,
          "274" => Discipline.new("International and Comparative Labor Relations", %w[], %w[3 272]).freeze,
          "275" => Discipline.new("Unions", %w[], %w[3 272]).freeze,
        "276" => Discipline.new("Management Information Systems", %w[], %w[3]).freeze,
        "277" => Discipline.new("Management Sciences and Quantitative Methods", %w[], %w[3]).freeze,
        # Marketing subtree
        "278" => Discipline.new("Marketing", %w[279], %w[3]).freeze,
          "279" => Discipline.new("Art Direction", %w[], %w[3 278]).freeze,
        "280" => Discipline.new("Nonprofit Administration and Management", %w[], %w[3]).freeze,
        "281" => Discipline.new("Operations and Supply Chain Management", %w[], %w[3]).freeze,
        "282" => Discipline.new("Organizational Behavior and Theory", %w[], %w[3]).freeze,
        "283" => Discipline.new("Portfolio and Security Analysis", %w[], %w[3]).freeze,
        "284" => Discipline.new("Real Estate", %w[], %w[3]).freeze,
        "285" => Discipline.new("Recreation Business", %w[], %w[3]).freeze,
        "286" => Discipline.new("Sales and Merchandising", %w[], %w[3]).freeze,
        "287" => Discipline.new("Sports Management", %w[], %w[3]).freeze,
        "288" => Discipline.new("Strategic Management Policy", %w[], %w[3]).freeze,
        "289" => Discipline.new("Taxation", %w[], %w[3]).freeze,
        "290" => Discipline.new("Technology and Innovation", %w[], %w[3]).freeze,
        "291" => Discipline.new("Tourism and Travel", %w[], %w[3]).freeze,
        "292" => Discipline.new("Other Business", %w[], %w[3]).freeze,
      # Education tree
      "4" => Discipline.new("Education", %w[293 294 295 296 297 298 299 303 304 305 313 314 315 316 317 318 319 320 323 324 325 326 327 328 329 330 331 332 333 334 335 336 337 338 346 347], %w[]).freeze,
        "293" => Discipline.new("Adult and Continuing Education", %w[], %w[]).freeze,
        "294" => Discipline.new("Art Education", %w[], %w[4]).freeze,
        "295" => Discipline.new("Bilingual, Multilingual, and Multicultural Education", %w[], %w[4]).freeze,
        "296" => Discipline.new("Community College Leadership", %w[], %w[4]).freeze,
        "297" => Discipline.new("Curriculum and Instruction", %w[], %w[4]).freeze,
        "298" => Discipline.new("Curriculum and Social Inquiry", %w[], %w[4]).freeze,
        # Disability and Equity in Education subtree
        "299" => Discipline.new("Disability and Equity in Education", %w[301 302], %w[4]).freeze,
          "301" => Discipline.new("Accessibility", %w[], %w[4 299]).freeze,
          "302" => Discipline.new("Gender Equity in Education", %w[], %w[4 299]).freeze,
        "303" => Discipline.new("Early Childhood Education", %w[], %w[4]).freeze,
        "304" => Discipline.new("Education Economics", %w[], %w[4]).freeze,
        # Educational Administration and Supervision subtree
        "305" => Discipline.new("Educational Administration and Supervision", %w[306 307 308 309 310 311 312], %w[4]).freeze,
          "306" => Discipline.new("Adult and Continuing Education Administration", %w[], %w[4 305]).freeze,
          "307" => Discipline.new("Community College Education Administration", %w[], %w[4 305]).freeze,
          "308" => Discipline.new("Elementary and Middle and Secondary Education Administration", %w[], %w[4 305]).freeze,
          "309" => Discipline.new("Higher Education Administration", %w[], %w[4 305]).freeze,
          "310" => Discipline.new("Special Education Administration", %w[], %w[4 305]).freeze,
          "311" => Discipline.new("Urban Education", %w[], %w[4 305]).freeze,
          "312" => Discipline.new("Other Educational Administration and Supervision", %w[], %w[4 305]).freeze,
        "313" => Discipline.new("Educational Assessment, Evaluation, and Research", %w[], %w[4]).freeze,
        "314" => Discipline.new("Educational Leadership", %w[], %w[4]).freeze,
        "315" => Discipline.new("Educational Methods", %w[], %w[4]).freeze,
        "316" => Discipline.new("Educational Psychology", %w[], %w[4]).freeze,
        "317" => Discipline.new("Elementary Education", %w[], %w[4]).freeze,
        "318" => Discipline.new("Gifted Education", %w[], %w[4]).freeze,
        "319" => Discipline.new("Health and Physical Education", %w[], %w[4]).freeze,
        # Higher Education subtree
        "320" => Discipline.new("Higher Education", %w[321 322], %w[4]).freeze,
          "321" => Discipline.new("Scholarship of Teaching and Learning", %w[], %w[4 320]).freeze,
          "322" => Discipline.new("University Extension", %w[], %w[4 320]).freeze,
        "323" => Discipline.new("Home Economics", %w[], %w[4]).freeze,
        "324" => Discipline.new("Humane Education", %w[], %w[4]).freeze,
        "325" => Discipline.new("Indigenous Education", %w[], %w[4]).freeze,
        "326" => Discipline.new("Instructional Media Design", %w[], %w[4]).freeze,
        "327" => Discipline.new("International and Comparative Education", %w[], %w[4]).freeze,
        "328" => Discipline.new("Language and Literacy Education", %w[], %w[4]).freeze,
        "329" => Discipline.new("Liberal Studies", %w[], %w[4]).freeze,
        "330" => Discipline.new("Online and Distance Education", %w[], %w[4]).freeze,
        "331" => Discipline.new("Outdoor Education", %w[], %w[4]).freeze,
        "332" => Discipline.new("Prison Education and Reentry", %w[], %w[4]).freeze,
        "333" => Discipline.new("Science and Mathematics Education", %w[], %w[4]).freeze,
        "334" => Discipline.new("Secondary Education", %w[], %w[4]).freeze,
        "335" => Discipline.new("Social and Philosophical Foundations of Education", %w[], %w[4]).freeze,
        "336" => Discipline.new("Special Education and Teaching", %w[], %w[4]).freeze,
        "337" => Discipline.new("Student Counseling and Personnel Services", %w[], %w[4]).freeze,
        # Teacher Education and Professional Development subtree
        "338" => Discipline.new("Teacher Education and Professional Development", %w[339 340 341 342 343 344 345], %w[4]).freeze,
          "339" => Discipline.new("Adult and Continuing Education and Teaching", %w[], %w[4 338]).freeze,
          "340" => Discipline.new("Elementary Education and Teaching", %w[], %w[4 338]).freeze,
          "341" => Discipline.new("Higher Education and Teaching", %w[], %w[4 338]).freeze,
          "342" => Discipline.new("Junior High, Intermediate, Middle School Education and Teaching", %w[], %w[4 338]).freeze,
          "343" => Discipline.new("Pre-Elementary, Early Childhood, Kindergarten Teacher Education", %w[], %w[4 338]).freeze,
          "344" => Discipline.new("Secondary Education and Teaching", %w[], %w[4 338]).freeze,
          "345" => Discipline.new("Other Teacher Education and Professional Development", %w[], %w[4 338]).freeze,
        "346" => Discipline.new("Other Education", %w[], %w[4]).freeze,
        "347" => Discipline.new("Vocational Education", %w[], %w[4]).freeze,
      # Engineering tree
      "5" => Discipline.new("Engineering", %w[348 359 360 365 376 377 389 398 399 407 419 420 425 426 434 446 448 449 450 457 458], %w[]).freeze,
        # Aerospace Engineering subtree
        "348" => Discipline.new("Aerospace Engineering", %w[349 350 351 352 353 354 355 356 357 358], %w[5]).freeze,
          "349" => Discipline.new("Aerodynamics and Fluid Mechanics", %w[], %w[5 348]).freeze,
          "350" => Discipline.new("Aeronautical Vehicles", %w[], %w[5 348]).freeze,
          "351" => Discipline.new("Astrodynamics", %w[], %w[5 348]).freeze,
          "352" => Discipline.new("Multi-Vehicle Systems and Air Traffic Control", %w[], %w[5 348]).freeze,
          "353" => Discipline.new("Navigation, Guidance, Control and Dynamics", %w[], %w[5 348]).freeze,
          "354" => Discipline.new("Propulsion and Power", %w[], %w[5 348]).freeze,
          "355" => Discipline.new("Space Vehicles", %w[], %w[5 348]).freeze,
          "356" => Discipline.new("Structures and Materials", %w[], %w[5 348]).freeze,
          "357" => Discipline.new("Systems Engineering and Multidisciplinary Design Optimization", %w[], %w[5 348]).freeze,
          "358" => Discipline.new("Other Aerospace Engineering", %w[], %w[5 348]).freeze,
        "359" => Discipline.new("Automotive Engineering", %w[], %w[5]).freeze,
        # Aviation subtree
        "360" => Discipline.new("Aviation", %w[361 362 363 364], %w[5]).freeze,
          "361" => Discipline.new("Aviation and Space Education", %w[], %w[5 360]).freeze,
          "362" => Discipline.new("Aviation Safety and Security", %w[], %w[5 360]).freeze,
          "363" => Discipline.new("Maintenance Technology", %w[], %w[5 360]).freeze,
          "364" => Discipline.new("Management and Operations", %w[], %w[5 360]).freeze,
        # Biomedical Engineering and Bioengineering subtree
        "365" => Discipline.new("Biomedical Engineering and Bioengineering", %w[366 367 368 369 370 371 372 373 374 375], %w[5]).freeze,
          "366" => Discipline.new("Bioelectrical and Neuroengineering", %w[], %w[5 365]).freeze,
          "367" => Discipline.new("Bioimaging and Biomedical Optics", %w[], %w[5 365]).freeze,
          "368" => Discipline.new("Biological Engineering", %w[], %w[5 365]).freeze,
          "369" => Discipline.new("Biomaterials", %w[], %w[5 365]).freeze,
          "370" => Discipline.new("Biomechanics and Biotransport", %w[], %w[5 365]).freeze,
          "371" => Discipline.new("Biomedical Devices and Instrumentation", %w[], %w[5 365]).freeze,
          "372" => Discipline.new("Molecular, Cellular, and Tissue Engineering", %w[], %w[5 365]).freeze,
          "373" => Discipline.new("Systems and Integrative Engineering", %w[], %w[5 365]).freeze,
          "374" => Discipline.new("Vision Science", %w[], %w[5 365]).freeze,
          "375" => Discipline.new("Other Biomedical Engineering and Bioengineering", %w[], %w[5 365]).freeze,
        "376" => Discipline.new("Bioresource and Agricultural Engineering", %w[], %w[5 365]).freeze,
        # Chemical Engineering subtree
        "377" => Discipline.new("Chemical Engineering", %w[378 379 380 381 382 383 384 385 386 387], %w[5]).freeze,
          "378" => Discipline.new("Biochemical and Biomolecular Engineering", %w[], %w[5 377]).freeze,
          "379" => Discipline.new("Catalysis and Reaction Engineering", %w[], %w[5 377]).freeze,
          "380" => Discipline.new("Complex Fluids", %w[], %w[5 377]).freeze,
          "381" => Discipline.new("Membrane Science", %w[], %w[5 377]).freeze,
          "382" => Discipline.new("Petroleum Engineering", %w[], %w[5 377]).freeze,
          "383" => Discipline.new("Polymer Science", %w[], %w[5 377]).freeze,
          "384" => Discipline.new("Process Control and Systems", %w[], %w[5 377]).freeze,
          "385" => Discipline.new("Thermodynamics", %w[], %w[5 377]).freeze,
          "386" => Discipline.new("Transport Phenomena", %w[], %w[5 377]).freeze,
          "387" => Discipline.new("Other Chemical Engineering", %w[], %w[5 377]).freeze,
        # Civil and Environmental Engineering subtree
        "389" => Discipline.new("Civil and Environmental Engineering", %w[390 391 392 393 394 395 396 397], %w[5]).freeze,
          "390" => Discipline.new("Civil Engineering", %w[], %w[5 389]).freeze,
          "391" => Discipline.new("Construction Engineering and Management", %w[], %w[5 389]).freeze,
          "392" => Discipline.new("Environmental Engineering", %w[], %w[5 389]).freeze,
          "393" => Discipline.new("Geotechnical Engineering", %w[], %w[5 389]).freeze,
          "394" => Discipline.new("Hydraulic Engineering", %w[], %w[5 389]).freeze,
          "395" => Discipline.new("Structural Engineering", %w[], %w[5 389]).freeze,
          "396" => Discipline.new("Transportation Engineering", %w[], %w[5 389]).freeze,
          "397" => Discipline.new("Other Civil and Environmental Engineering", %w[], %w[5 389]).freeze,
        "398" => Discipline.new("Computational Engineering", %w[], %w[5]).freeze,
        # Computer Engineering subtree
        "399" => Discipline.new("Computer Engineering", %w[400 401 402 403 404 405 406], %w[5]).freeze,
          "400" => Discipline.new("Computer and Systems Architecture", %w[], %w[5 399]).freeze,
          "401" => Discipline.new("Data Storage Systems", %w[], %w[5 399]).freeze,
          "402" => Discipline.new("Digital Circuits", %w[], %w[5 399]).freeze,
          "403" => Discipline.new("Digital Communications and Networking", %w[], %w[5 399]).freeze,
          "404" => Discipline.new("Hardware Systems", %w[], %w[5 399]).freeze,
          "405" => Discipline.new("Robotics", %w[], %w[5 399]).freeze,
          "406" => Discipline.new("Other Computer Engineering", %w[], %w[5 399]).freeze,
        # Electrical and Computer Engineering subtree
        "407" => Discipline.new("Electrical and Computer Engineering", %w[408 409 410 411 412 413 414 415 416 417 418], %w[5]).freeze,
          "408" => Discipline.new("Biomedical", %w[], %w[5 407]).freeze,
          "409" => Discipline.new("Controls and Control Theory", %w[], %w[5 407]).freeze,
          "410" => Discipline.new("Electrical and Electronics", %w[], %w[5 407]).freeze,
          "411" => Discipline.new("Electromagnetics and Photonics", %w[], %w[5 407]).freeze,
          "412" => Discipline.new("Electronic Devices and Semiconductor Manufacturing", %w[], %w[5 407]).freeze,
          "413" => Discipline.new("Nanotechnology Fabrication", %w[], %w[5 407]).freeze,
          "414" => Discipline.new("Power and Energy", %w[], %w[5 407]).freeze,
          "415" => Discipline.new("Signal Processing", %w[], %w[5 407]).freeze,
          "416" => Discipline.new("Systems and Communications", %w[], %w[5 407]).freeze,
          "417" => Discipline.new("VLSI and Circuits, Embedded and Hardware Systems", %w[], %w[5 407]).freeze,
          "418" => Discipline.new("Other Electrical and Computer Engineering", %w[], %w[5 407]).freeze,
        "419" => Discipline.new("Engineering Education", %w[], %w[5]).freeze,
        # Engineering Science and Materials subtree
        "420" => Discipline.new("Engineering Science and Materials", %w[421 422 423 424], %w[5]).freeze,
          "421" => Discipline.new("Dynamics and Dynamical Systems", %w[], %w[5 420]).freeze,
          "422" => Discipline.new("Engineering Mechanics", %w[], %w[5 420]).freeze,
          "423" => Discipline.new("Mechanics of Materials", %w[], %w[5 420]).freeze,
          "424" => Discipline.new("Other Engineering Science and Materials", %w[], %w[5 420]).freeze,
        "425" => Discipline.new("Geological Engineering", %w[], %w[5]).freeze,
        # Materials Science and Engineering subtree
        "426" => Discipline.new("Materials Science and Engineering", %w[427 428 429 430 431 432 433], %w[5]).freeze,
          "427" => Discipline.new("Biology and Biomimetic Materials", %w[], %w[5 426]).freeze,
          "428" => Discipline.new("Ceramic Materials", %w[], %w[5 426]).freeze,
          "429" => Discipline.new("Metallurgy", %w[], %w[5 426]).freeze,
          "430" => Discipline.new("Polymer and Organic Materials", %w[], %w[5 426]).freeze,
          "431" => Discipline.new("Semiconductor and Optical Materials", %w[], %w[5 426]).freeze,
          "432" => Discipline.new("Structural Materials", %w[], %w[5 426]).freeze,
          "433" => Discipline.new("Other Materials Science and Engineering", %w[], %w[5 426]).freeze,
        # Mechanical Engineering subtree
        "434" => Discipline.new("Mechanical Engineering", %w[435 436 437 438 439 440 441 442 443 444 445], %w[5]).freeze,
          "435" => Discipline.new("Acoustics, Dynamics, and Controls", %w[], %w[5 434]).freeze,
          "436" => Discipline.new("Applied Mechanics", %w[], %w[5 434]).freeze,
          "437" => Discipline.new("Biomechanical Engineering", %w[], %w[5 434]).freeze,
          "438" => Discipline.new("Computer-Aided Engineering and Design", %w[], %w[5 434]).freeze,
          "439" => Discipline.new("Electro-Mechanical Systems", %w[], %w[5 434]).freeze,
          "440" => Discipline.new("Energy Systems", %w[], %w[5 434]).freeze,
          "441" => Discipline.new("Heat Transfer, Combustion", %w[], %w[5 434]).freeze,
          "442" => Discipline.new("Manufacturing", %w[], %w[5 434]).freeze,
          "443" => Discipline.new("Ocean Engineering", %w[], %w[5 434]).freeze,
          "444" => Discipline.new("Tribology", %w[], %w[5 434]).freeze,
          "445" => Discipline.new("Other Mechanical Engineering", %w[], %w[5 434]).freeze,
        # Mining Engineering subtree
        "446" => Discipline.new("Mining Engineering", %w[447], %w[5]).freeze,
          "447" => Discipline.new("Explosives Engineering", %w[], %w[5 446]).freeze,
        "448" => Discipline.new("Nanoscience and Nanotechnology", %w[], %w[5]).freeze,
        "449" => Discipline.new("Nuclear Engineering", %w[], %w[5]).freeze,
        # Mining Engineering subtree
        "450" => Discipline.new("Operations Research, Systems Engineering and Industrial Engineering", %w[451 452 453 454 455 456], %w[5]).freeze,
          "451" => Discipline.new("Ergonomics", %w[], %w[5 450]).freeze,
          "452" => Discipline.new("Industrial Engineering", %w[], %w[5 450]).freeze,
          "453" => Discipline.new("Industrial Technology", %w[], %w[5 450]).freeze,
          "454" => Discipline.new("Operational Research", %w[], %w[5 450]).freeze,
          "455" => Discipline.new("Systems Engineering", %w[], %w[5 450]).freeze,
          "456" => Discipline.new("Other Operations Research, Systems Engineering and Industrial Engineering", %w[], %w[5 450]).freeze,
        "457" => Discipline.new("Risk Analysis", %w[], %w[5]).freeze,
        "458" => Discipline.new("Other Engineering", %w[], %w[5]).freeze,
      # Law tree
      "6" => Discipline.new("Law", %w[459 460 461 462 463 464 465 466 467 468 469 470 471 472 473 474 475 476 477 478 479 64 480 481 482 483 484 485 486 487 488 489 490 491 492 493 494 495 496 497 498 499 500 501 502 503 504 505 506 507 508 509 510 511 512 513 514 515 516 517 518 519 520 521 522 523 524 525 526 527 528 529 530 531 532 533 534 535 536 537 538 539 540 541 542 543 544 545 546 547 548 559 550 551 552 553 554 555 556 557 558 559 560 561 562 563 564 565 566 567 568 569 570 571 572 573 574], %w[]).freeze,
        "459" => Discipline.new("Accounting Law", %w[], %w[6]).freeze,
        "460" => Discipline.new("Administrative Law", %w[], %w[6]).freeze,
        "461" => Discipline.new("Admiralty", %w[], %w[6]).freeze,
        "462" => Discipline.new("Agency", %w[], %w[6]).freeze,
        "463" => Discipline.new("Agriculture Law", %w[], %w[6]).freeze,
        "464" => Discipline.new("Air and Space Law", %w[], %w[6]).freeze,
        "465" => Discipline.new("Animal Law", %w[], %w[6]).freeze,
        "466" => Discipline.new("Antitrust and Trade Regulation", %w[], %w[6]).freeze,
        "467" => Discipline.new("Banking and Finance Law", %w[], %w[6]).freeze,
        "468" => Discipline.new("Bankruptcy Law", %w[], %w[6]).freeze,
        "469" => Discipline.new("Business Organizations Law", %w[], %w[6]).freeze,
        "470" => Discipline.new("Civil Law", %w[], %w[6]).freeze,
        "471" => Discipline.new("Civil Procedure", %w[], %w[6]).freeze,
        "472" => Discipline.new("Civil Rights and Discrimination", %w[], %w[6]).freeze,
        "473" => Discipline.new("Commercial Law", %w[], %w[6]).freeze,
        "474" => Discipline.new("Common Law", %w[], %w[6]).freeze,
        "475" => Discipline.new("Communications Law", %w[], %w[6]).freeze,
        "476" => Discipline.new("Comparative and Foreign Law", %w[], %w[6]).freeze,
        "477" => Discipline.new("Computer Law", %w[], %w[6]).freeze,
        "478" => Discipline.new("Conflict of Laws", %w[], %w[6]).freeze,
        "479" => Discipline.new("Constitutional Law", %w[], %w[6]).freeze,
        "64" => Discipline.new("Construction Law", %w[], %w[6]).freeze,
        "480" => Discipline.new("Consumer Protection Law", %w[], %w[6]).freeze,
        "481" => Discipline.new("Contracts", %w[], %w[6]).freeze,
        "482" => Discipline.new("Courts", %w[], %w[6]).freeze,
        "483" => Discipline.new("Criminal Law", %w[], %w[6]).freeze,
        "484" => Discipline.new("Criminal Procedure", %w[], %w[6]).freeze,
        "485" => Discipline.new("Cultural Heritage Law", %w[], %w[6]).freeze,
        "486" => Discipline.new("Disability Law", %w[], %w[6]).freeze,
        "487" => Discipline.new("Disaster Law", %w[], %w[6]).freeze,
        "488" => Discipline.new("Dispute Resolution and Arbitration", %w[], %w[6]).freeze,
        "489" => Discipline.new("Education Law", %w[], %w[6]).freeze,
        "490" => Discipline.new("Elder Law", %w[], %w[6]).freeze,
        "491" => Discipline.new("Election Law", %w[], %w[6]).freeze,
        "492" => Discipline.new("Energy and Utilities Law", %w[], %w[6]).freeze,
        "493" => Discipline.new("Entertainment, Arts, and Sports Law", %w[], %w[6]).freeze,
        "494" => Discipline.new("Environmental Law", %w[], %w[6]).freeze,
        "495" => Discipline.new("Estates and Trusts", %w[], %w[6]).freeze,
        "496" => Discipline.new("European Law", %w[], %w[6]).freeze,
        "497" => Discipline.new("Evidence", %w[], %w[6]).freeze,
        "498" => Discipline.new("Family Law", %w[], %w[6]).freeze,
        "499" => Discipline.new("First Amendment", %w[], %w[6]).freeze,
        "500" => Discipline.new("Food and Drug Law", %w[], %w[6]).freeze,
        "501" => Discipline.new("Fourteenth Amendment", %w[], %w[6]).freeze,
        "502" => Discipline.new("Fourth Amendment", %w[], %w[6]).freeze,
        "503" => Discipline.new("Gaming Law", %w[], %w[6]).freeze,
        "504" => Discipline.new("Government Contracts", %w[], %w[6]).freeze,
        "505" => Discipline.new("Health Law and Policy", %w[], %w[6]).freeze,
        "506" => Discipline.new("Housing Law", %w[], %w[6]).freeze,
        "507" => Discipline.new("Human Rights Law", %w[], %w[6]).freeze,
        "508" => Discipline.new("Immigration Law", %w[], %w[6]).freeze,
        "509" => Discipline.new("Indian and Aboriginal Law", %w[], %w[6]).freeze,
        "510" => Discipline.new("Insurance Law", %w[], %w[6]).freeze,
        "511" => Discipline.new("Intellectual Property Law", %w[], %w[6]).freeze,
        "512" => Discipline.new("International Humanitarian Law", %w[], %w[6]).freeze,
        "513" => Discipline.new("International Law", %w[], %w[6]).freeze,
        "514" => Discipline.new("International Trade Law", %w[], %w[6]).freeze,
        "515" => Discipline.new("Internet Law", %w[], %w[6]).freeze,
        "516" => Discipline.new("Judges", %w[], %w[6]).freeze,
        "517" => Discipline.new("Jurisdiction", %w[], %w[6]).freeze,
        "518" => Discipline.new("Jurisprudence", %w[], %w[6]).freeze,
        "519" => Discipline.new("Juvenile Law", %w[], %w[6]).freeze,
        "520" => Discipline.new("Labor and Employment Law", %w[], %w[6]).freeze,
        "521" => Discipline.new("Land Use Law", %w[], %w[6]).freeze,
        "522" => Discipline.new("Law and Economics", %w[], %w[6]).freeze,
        "523" => Discipline.new("Law and Gender", %w[], %w[6]).freeze,
        "524" => Discipline.new("Law and Philosophy", %w[], %w[6]).freeze,
        "525" => Discipline.new("Law and Politics", %w[], %w[6]).freeze,
        "526" => Discipline.new("Law and Psychology", %w[], %w[6]).freeze,
        "527" => Discipline.new("Law and Race", %w[], %w[6]).freeze,
        "528" => Discipline.new("Law and Society", %w[], %w[6]).freeze,
        "529" => Discipline.new("Law Enforcement and Corrections", %w[], %w[6]).freeze,
        "530" => Discipline.new("Law of the Sea", %w[], %w[6]).freeze,
        "531" => Discipline.new("Legal Biography", %w[], %w[6]).freeze,
        "532" => Discipline.new("Legal Education", %w[], %w[6]).freeze,
        "533" => Discipline.new("Legal Ethics and Professional Responsibility", %w[], %w[6]).freeze,
        "534" => Discipline.new("Legal History", %w[], %w[6]).freeze,
        "535" => Discipline.new("Legal Profession", %w[], %w[6]).freeze,
        "536" => Discipline.new("Legal Remedies", %w[], %w[6]).freeze,
        "537" => Discipline.new("Legal Writing and Research", %w[], %w[6]).freeze,
        "538" => Discipline.new("Legislation", %w[], %w[6]).freeze,
        "539" => Discipline.new("Litigation", %w[], %w[6]).freeze,
        "540" => Discipline.new("Marketing Law", %w[], %w[6]).freeze,
        "541" => Discipline.new("Medical Jurisprudence", %w[], %w[6]).freeze,
        "542" => Discipline.new("Military, War, and Peace", %w[], %w[6]).freeze,
        "543" => Discipline.new("National Security Law", %w[], %w[6]).freeze,
        "544" => Discipline.new("Natural Law", %w[], %w[6]).freeze,
        "545" => Discipline.new("Natural Resources Law", %w[], %w[6]).freeze,
        "546" => Discipline.new("Nonprofit Organizations Law", %w[], %w[6]).freeze,
        "547" => Discipline.new("Oil, Gas, and Mineral Law", %w[], %w[6]).freeze,
        "548" => Discipline.new("Organizations Law", %w[], %w[6]).freeze,
        "549" => Discipline.new("President/Executive Department", %w[], %w[6]).freeze,
        "550" => Discipline.new("Privacy Law", %w[], %w[6]).freeze,
        "551" => Discipline.new("Property Law and Real Estate", %w[], %w[6]).freeze,
        "552" => Discipline.new("Public Law and Legal Theory", %w[], %w[6]).freeze,
        "553" => Discipline.new("Religion Law", %w[], %w[6]).freeze,
        "554" => Discipline.new("Retirement Security Law", %w[], %w[6]).freeze,
        "555" => Discipline.new("Rule of Law", %w[], %w[6]).freeze,
        "556" => Discipline.new("Science and Technology Law", %w[], %w[6]).freeze,
        "557" => Discipline.new("Second Amendment", %w[], %w[6]).freeze,
        "558" => Discipline.new("Secured Transactions", %w[], %w[6]).freeze,
        "559" => Discipline.new("Securities Law", %w[], %w[6]).freeze,
        "560" => Discipline.new("Sexuality and the Law", %w[], %w[6]).freeze,
        "561" => Discipline.new("Social Welfare Law", %w[], %w[6]).freeze,
        "562" => Discipline.new("State and Local Government Law", %w[], %w[6]).freeze,
        "563" => Discipline.new("Supreme Court of the United States", %w[], %w[6]).freeze,
        "564" => Discipline.new("Tax Law", %w[], %w[6]).freeze,
        "565" => Discipline.new("Taxation-Federal", %w[], %w[6]).freeze,
        "566" => Discipline.new("Taxation-Federal Estate and Gift", %w[], %w[6]).freeze,
        "567" => Discipline.new("Taxation-State and Local", %w[], %w[6]).freeze,
        "568" => Discipline.new("Taxation-Transnational", %w[], %w[6]).freeze,
        "569" => Discipline.new("Torts", %w[], %w[6]).freeze,
        "570" => Discipline.new("Transnational Law", %w[], %w[6]).freeze,
        "571" => Discipline.new("Transportation Law", %w[], %w[6]).freeze,
        "572" => Discipline.new("Water Law", %w[], %w[6]).freeze,
        "573" => Discipline.new("Workers' Compensation Law", %w[], %w[6]).freeze,
        "574" => Discipline.new("Other Law", %w[], %w[6]).freeze
  }.freeze

  def self.get_ancestor_str(id)
    discipline = DISCIPLINES[id]
    return '' if discipline.nil?

    discipline.ancestor.join(' ')
  end

  def self.get_full_path(id, separator = ': ')
    discipline = DISCIPLINES[id]
    return '' if discipline.nil?
    return discipline.name if discipline.ancestor.empty?

    discipline_path = ''
    discipline.ancestor.each_with_index do |ancestor_id, i|
      ancestor = DISCIPLINES[ancestor_id]
      next if ancestor.nil?

      discipline_path += ancestor.name + separator
    end

    discipline_path += discipline.name
    discipline_path
  end

  def self.add_to_new_discipline(discipline_filters, new_counts, key, value)
    return unless discipline_filters.include? key

    new_counts.has_key?(key) ? new_counts[key] += value : new_counts[key] = value
  end

  def self.recalculate_discipline_filter(res)
    return unless res.key?('facet_counts') &&
        res['facet_counts'].key?('facet_fields') &&
        res['facet_counts']['facet_fields'].key?('discipline_sim') &&
        res['facet_counts']['facet_fields']['discipline_sim'].any?

    # use the search discipline and its children if it's a search field; otherwise, use top disciplines
    discipline_filters = []
    fq = res['responseHeader']['params']['fq']   # need to figure out if discipline is one of the searching field
    fq.each do |f|
      # notice that fq.include? '{!dismax qf=discipline_search_ids_teim}' would only work if exact match but discipline ID is different every time
      next unless f.include? '{!dismax qf=discipline_search_ids_teim}'

      discipline_search_ids = f[39..-1]
      discipline_filters << discipline_search_ids
      discipline_filters.push(DISCIPLINES[discipline_search_ids].children).flatten!
      break
    end

    discipline_filters = TOP_DISCIPLINES.map { |d| d.id } if discipline_filters.empty?
    new_counts = {}
    # convert the array of discipline and its count into a hash
    counts = Hash[*res['facet_counts']['facet_fields']['discipline_sim'].flatten(1)]

    counts.each do |key, value|
      # validate the key
      next if DISCIPLINES[key].nil?

      # loop through its ancestors first to preserve the discipline order
      DISCIPLINES[key].ancestor.each do |a|
        add_to_new_discipline(discipline_filters, new_counts, a, value)
      end
      add_to_new_discipline(discipline_filters, new_counts, key, value)
    end
    res['facet_counts']['facet_fields']['discipline_sim'] = new_counts.to_a.flatten(1)
  end
end
