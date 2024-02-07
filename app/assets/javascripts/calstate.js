/*
 * Handlers for frontend to deal with composite person, date, submit button, tinymce
 */

/*
 * these functions are used by composite person.
*/

/*
    These functions allow dynamic creation and deserialization of the composite element.
 */

var scholarworks = scholarworks || {};
scholarworks.composite_element =  {
    // these are the composite elements we support.
    SUBTYPES : ['name', 'email', 'institution', 'orcid', 'role', 'identifier'],

    text : function(elem_value, elem_type, subtype_tag, elem_num, elem_required) {
        let subtype_label = subtype_tag.charAt(0).toUpperCase() + subtype_tag.slice(1);
        return  "<div class='label_input_div'>" +
            "<label for='" + elem_type + "_" + subtype_tag + elem_num + "' class='label_field'>" +
            "<span class='sr-only'>" + elem_type + " </span>" + subtype_label +
            (elem_required ? " <span class='label label-info required-tag'>required</span>" : " ") +
            "</label>" +
            "<input type='text' id='" + elem_type + "_" + subtype_tag + elem_num + "' value='" + elem_value + "'" +
            " aria-required='" + (elem_required ? "true" : "false") + "' " + (elem_required ? "required='required'" : "") +
            " class='string multi_value " + (elem_required ? "required " : " ") + elem_type + "_" + subtype_tag +
            " margin_bottom_10 multi-text-field multi_value input_field' />" +
            "</div>";
    },

    email : function(elem_value, elem_type, elem_num, elem_required) {
        return  "<div class='label_input_div'>" +
            " <label for='" + elem_type + "_email" + elem_num + "' class='label_field'>" +
            " <span class='sr-only'>" + elem_type + " </span>Email" +
            (elem_required ? " <span class='label label-info required-tag'>required</span>" : " ") +
            " </label>" +
            " <input type='email' id='" + elem_type + "_email" + elem_num + "' value='" + elem_value + "'" +
            " class='" + elem_type + "_email margin_bottom_10 multi-text-field multi_value input_field' />" +
            "</div>";
    },

    orcid : function(elem_value, elem_type, elem_num, elem_required) {
        return "<div class='label_input_div'>" +
            " <label for='" + elem_type + "_orcid" + elem_num + "' class='label_field'>" +
            " <span class='sr-only'>" + elem_type + " </span>ORCID" +
            (elem_required ? " <span class='label label-info required-tag'>required</span>" : " ") +
            " </label>" +
            " <input type='text'" +
            " id='" + elem_type + "_orcid" + elem_num + "' value='" + elem_value + "'" +
            " class='" + elem_type + "_orcid composite_orcid margin_bottom_10 multi-text-field multi_value input_field' " +
            " data-element-type='" + elem_type + "' data-element-num='" + elem_num + "' />" +
            " <span id='" + elem_type + "_orcid_error" + elem_num + "' class='" + elem_type + "_orcid_error composite_orcid_error error text-danger error text-danger margin_bottom_10 d_none'" +
            " role='alert' aria-hidden='true'>must be a string of 19 characters, e.g., '0000-0000-0000-0000'</span>" +
            "</div>";
    },

    name : function(elem_value, elem_type, elem_num, elem_required) {
        return this.text(elem_value, elem_type, this.SUBTYPES[0], elem_num, elem_required);
    },

    institution : function(elem_value, elem_type, elem_num, elem_required) {
        return this.text(elem_value, elem_type, this.SUBTYPES[2], elem_num, elem_required);
    },

    role : function(elem_value, elem_type, elem_num, elem_required) {
        return this.text(elem_value, elem_type, this.SUBTYPES[4], elem_num, elem_required);
    },

    identifier : function(elem_value, elem_type, elem_num, elem_required) {
        return this.text(elem_value, elem_type, this.SUBTYPES[5], elem_num, elem_required);
    },

    generate_sub_elements : function(elem_type, elem_num, elem_required, subtypes, subvalues) {
        let ret_elem = '';
        const subtypes_arr = subtypes.split(" ");
        const sub_values_arr = subvalues.split(":::");
        for (let i = 0; i < subtypes_arr.length; i++) {
            if (!this.SUBTYPES.includes(subtypes_arr[i])) {
                // not in the subtype that we can support
                continue;
            }

            let sub_value = (sub_values_arr.length >= 1 && sub_values_arr[i] ? sub_values_arr[i] : '').replaceAll("'", "&#39;");
            let required = (i == 0 ? elem_required : false);
            //console.log('calling function ' + subtypes_arr[i] + ' value [' + sub_value + '] required ' + required);
            ret_elem += this[subtypes_arr[i]](sub_value, elem_type, elem_num, required);
        }
        return ret_elem;
    },


    generate_element : function(add_button_id) {
        let button_elem = $('#' + add_button_id);
        if (!button_elem.length) return "";

        let elem_model = button_elem.data('element-model');
        let elem_type = button_elem.data('element-type');
        let elem_required = button_elem.data('element-required');
        let subtypes = button_elem.data('subtypes');
        let elem_num = eval('scholarworks.' + elem_type + '_num');
        let sub_elem = this.generate_sub_elements(elem_type, elem_num, elem_required, subtypes, '');

        let ret_elem =
            "<div id='" + elem_type + "_divider" + elem_num + "' class='row divider " + elem_type + "_divider'></div>" +
            "<div id='" + elem_type + "_div" + elem_num + "' class='row " + elem_type + "_div flex_center'>" +
            " <input type='hidden' name='" + elem_model + "[" + elem_type + "][]' id='" + elem_type + elem_num +
            "' class='" + elem_type + " composite_element'" +
            " data-element-type='" + elem_type + "'" +
            " data-element-num='" + elem_num + "'" +
            " data-element-required='" + elem_required + "'" +
            " data-subtypes='" + subtypes + "'" +
            " value='' />" +
            " <div id='" + elem_type + "_composite" + elem_num + "' class='col-xs-8'>" +
            sub_elem +
            " </div>" +
            " <div class='col-sm'>" +
            " <button id='remove_" + elem_type + elem_num + "'" +
            " class='btn btn-link remove element_remove " + elem_type + "_remove' aria-hidden='true' " +
            " type='button'" +
            " data-element-type='" + elem_type + "'" +
            " data-element-num='" + elem_num + "'" +
            " data-element-required='" + elem_required + "'" +
            " data-element-post-remove='scholarworks.composite_element.post_action'" +
            ">" +
            " <span class='glyphicon glyphicon-remove'></span>" +
            " <span class='controls-remove-text'>Remove</span>" +
            " <span class='sr-only'>" + elem_type + "</span>" +
            " </button>" +
            " </div>" +
            "</div>";

        return ret_elem;
    },

    valid_orcid : function() {
        let regex = /^\d{4}-\d{4}-\d{4}-\d{3}[\dX]$/;
        let has_valid_orcid = true;
        $('.composite_orcid_error').addClass('d_none').attr('aria-hidden', 'true');
        $('.composite_orcid').each(function () {
            let orcid_val = $.trim($(this).val());
            if (orcid_val != '' && !regex.test(orcid_val)) {
                let elem_type = $(this).data('element-type');
                let id = $(this).data('element-num')
                $('#' + elem_type + '_orcid_error' + id).removeClass('d_none').attr('aria-hidden', 'false');
                has_valid_orcid = false;
		        $(this).focus();
                return false;
            }
        });
        return has_valid_orcid;
    },

    any_empty_main_element : function (main_elem) {
        let ret_val = false;
        //console.log('inside any_empty_main_element main_elem ' + main_elem);
        $('.' + main_elem).each(function () {
            //console.log('any_empty_element: value [' + $.trim($(this).val()) + ']');
            if ($.trim($(this).val()) == '') {
                ret_val = true;
                return false;
            }
        })
        return ret_val;
    },

    any_empty_element : function(add_button_id) {
        let ret_val = false;
        let button_elem = $('#' + add_button_id);
        if (!button_elem.length) return ret_val;

        let elem_type = button_elem.data('element-type');
        let subtypes = button_elem.data('subtypes');
        const subtypes_arr = subtypes.split(" ");
        // subtypes 0 (first one) is the main field
        let main_elem = elem_type + '_' + subtypes_arr[0];
        //console.log('inside any_empty_element elem_type ' + elem_type + ' main_elem ' + main_elem);
        ret_val = this.any_empty_main_element(main_elem);
        return ret_val;
    },

    element_change : function(elem_type, subtypes, elem_required) {
        //console.log('element_change add focusout on orcid element');
        $('.composite_orcid').focusout(function() {
            scholarworks.is_required_field_complete();
        });
	    scholarworks.is_required_field_complete();
    },

    // to be used after add and remove action
    post_action : function(button_id) {
        //console.log('inside post_element_action button_id[' + button_id + ']');
        let button_elem = $('#' + button_id);
        if (!button_elem.length) return;

        let elem_type = button_elem.data('element-type');
        let subtypes = button_elem.data('subtypes');
        let elem_required = button_elem.data('element-required');
        //console.log('post_element_action button_id [' + button_id + '] elem_type [' + elem_type + ' subtypes [' + subtypes + ' elem_required [' + elem_required + ']');
        this.element_change(elem_type, subtypes, elem_required);
    },

    /*
        serialize and deserialize are used during loading and saving the forms.
        They should work on all different types of composite element such that different composite
        person can have different subtypes.
        composite_person1 can have name, email, institution, and orcid
        composite_person2 can have name, role, identifier, etc..
        It would rely on data field called data-subtypes
        For serialize, the name field would have data-subtypes that contains all the subtypes
        so for composite_person1 data-subfields='email institution orcid'
        while composite_person2  data-subfields='role identifier'
        For deserialize, the composite field (serialized data) would have data-subtypes to contain all its subtypes.
     */
    serialize : function() {
        $('.composite_element').each(function () {
            let elem_type = $(this).data('element-type');
            let elem_num = $(this).data('element-num');
            let subtypes = $(this).data('subtypes');
            const subtypes_arr = subtypes.split(" ");
            // subtypes 0 (first one) is the main field
            try {
                let main_field = $.trim($('#' + elem_type + '_' + subtypes_arr[0] + elem_num).val());
                let composite_value = ''
                if (main_field.length > 0) {
                    composite_value = main_field
                    for (let i = 1; i < subtypes_arr.length; i++) {
                        composite_value += ':::' + $('#' + elem_type + '_' + subtypes_arr[i] + elem_num).val();
                    }
                }
                //console.log('serialize type [' + elem_type + '] elem_num [' + elem_num + '] subtypes [' + subtypes + '] composite_value [' + composite_value + ']');
                $(this).val(composite_value);
            }
            catch (err) {
                console.log('Fail to serialize element type ' + elem_type + ' for element number ' + elem_num);
            }
        });
    },

    deserialize : function(elem_type) {
        $('.' + elem_type).each(function () {
            //let elem_type = $(this).data('element-type');
            let elem_num = $(this).data('element-num');
            let elem_required = $(this).data('element-required');
            let subtypes = $(this).data('subtypes');
            let composite_elem_div = $('#' + elem_type + '_composite' + elem_num);
            if (composite_elem_div.length) {
                //console.log('composite value ' + $(this).val());
                let composite_element = scholarworks.composite_element.generate_sub_elements(elem_type, elem_num, elem_required, subtypes, $(this).val());
                composite_elem_div.append(composite_element);
            }
        });
    }
};

scholarworks.element_add = function() {
    let elem_type = $(this).data('element-type');
    let elem_empty_func = $(this).data('element-empty');
    let elem_generate_func = $(this).data('element-generate');
    let add_button_id = $(this).attr('id');
    //let elem_cnt = window[elem_type + '_cnt'];
    //let cur_elem_num = window['cur_' + elem_type + '_num'];
    let elem_cnt = eval('scholarworks.' + elem_type + '_cnt');
    let cur_elem_num = eval('scholarworks.' + elem_type + '_num');
    //console.log('element_add elem_type ' + elem_type + ' elem_empty_func [' + elem_empty_func + '] elem_generate_func [' + elem_generate_func + '] elem_cnt ' + elem_cnt + ' cur_elem_num ' + cur_elem_num);
    let any_empty_elem = false;
    try {
        any_empty_elem = eval(elem_empty_func + '("' + add_button_id + '")');
    }
    catch(err) {
        console.log('Could not find check for empty function for ' + elem_type + ' so use the default one');
    }

    // console.log('element_add: any_empty_elem ' + any_empty_elem);
    if (any_empty_elem) {
        // turn on warning message when we already have empty field
        //console.log('there is an empty element for type ' + elem_type);
        $('#' + elem_type + '_warning').removeClass('d_none').attr('aria-hidden', 'false');
    }
    else {
        let elem_parent = $('#' + elem_type + '_divs');
        let new_elem = null;
        //console.log('elem_add any_empty_elem ' + any_empty_elem + ' elem_type ' + elem_type + ' add id [' + $(this).attr('id') + ']');
        try {
            new_elem = eval(elem_generate_func + '("' + add_button_id + '")');
        }
        catch (err) {
            console.log('fail to find element generate function ' + elem_generate_func);
        }
        if (elem_parent.length && new_elem != null) {
            elem_parent.append(new_elem);
            $('.' + elem_type + '_remove').removeClass('d_none').attr('aria-hidden', 'false');
            eval('scholarworks.' + elem_type + '_cnt' + ' = ' + elem_cnt + ' + 1;');
            eval('scholarworks.' + elem_type + '_num' + ' = ' + cur_elem_num + ' + 1;');
            /*
            elem_cnt = eval('scholarworks.' + elem_type + '_cnt');
            cur_elem_num = eval('scholarworks.' + elem_type + '_num');
            console.log('element_add after add elem_cnt ' + elem_cnt + ' cur_elem_num ' + cur_elem_num);
             */
            $('.element_remove').on('click', scholarworks.element_remove);
            let elem_post_add_func = $(this).data('element-post-add');
            try {
                //console.log('invoke post generate [' + elem_post_add_func + '] add_button_id [' + add_button_id + ']');
                eval(elem_post_add_func + '("' + add_button_id + '")');
            }
            catch (err) {
                console.log('fail to find post add element function ' + elem_post_add_func);
            }
        }
    }
}

scholarworks.element_remove = function() {
    let elem_type = $(this).data('element-type');
    let elem_num = $(this).data('element-num');
    //console.log('element_remove: elem_type ' + elem_type + ' elem_num ' + elem_num);

    try {
        let elem_cnt = eval('scholarworks.' + elem_type + '_cnt');
        //console.log('element_remove: elem_cnt ' + elem_cnt);
        if (elem_cnt > 1) {
            let removing_elem = $('#' + elem_type + '_div' + elem_num);
            if (removing_elem.length) {
                removing_elem.remove();
                eval('scholarworks.' + elem_type + '_cnt' + ' = ' + elem_cnt + ' - 1;');
                //window[elem_type + '_cnt']--;
                try {
                    let elem_post_remove_func = $(this).data('element-post-remove');
                    //console.log('element_remove elem_post_remove_func [' + elem_post_remove_func + ']');
                    eval(elem_post_remove_func + '("' + 'add_' + elem_type + '")');
                }
                catch (err) {
                    console.log('element_remove: failed to call post remove function for type ' + elem_type + ' maybe this type does not need one');
                }
                elem_cnt = eval('scholarworks.' + elem_type + '_cnt');
                //console.log('element_remove: elem_cnt after decrement for ' + elem_type + ' ' + elem_cnt);
                if (elem_cnt == 1) {
                    $('.' + elem_type + '_divider').remove();
                    $('.' + elem_type + '_remove').addClass('d_none').attr('aria-hidden', 'true');
                }
                else {
                    if ($('#' + elem_type + '_divider' + elem_num).length) {
                        $('#' + elem_type + '_divider' + elem_num).remove();
                    }
                }
                $('#' + elem_type + '_warning').addClass('d_none').attr('aria-hidden', 'true');
            }

        }
    }
    catch (err) {
        console.log('element_remove: fail to eval elem count');
    }
}
// only one save_handler for submit button event handler
scholarworks.save_handler = function(event) {
    //console.log('inside save handler');
    // need to check for required parameters again in case editor had checked for all its required parameters
    // but not our required parameters which it doesn't monitor
    if (!scholarworks.is_required_field_complete()) {
       event.preventDefault();
       return;
    }

    // if it's just an abstract work, remove dummy file element
    if ($('#dummy_file').length) {
        $('#dummy_file').remove();
	    // change the id of the upload file warning so editor allow submission
        $('#required-files').attr('id', 'required-files-warning');
    }

    // serialize all composite elements
    scholarworks.composite_element.serialize();
}

// functions for data_issued
scholarworks.adjust_date_issued_day = function(index) {
    //console.log('adjust date issued day')
    let year = $('#date_issued_year_' + index).val();
    let day = $('#date_issued_day_' + index);

    day.empty();
    // setting month to select if year is empty
    if (!year) {
        $('#date_issued_month_' + index).val("");
    }

    let day_elem = document.createElement("option");
    day_elem.value = "";
    day_elem.textContent = "Select";
    day.append(day_elem);

    let month = $('#date_issued_month_' + index).val();
    if (month) {
       //get the last day, so the number of days in that month
        let days = new Date(year, parseInt(month), 0).getDate();
        //lets create the days of that month
        for (let d = 1; d <= days; d++) {
            let day_elem = document.createElement("option");
            day_elem.value = d;
            day_elem.textContent = d;
            day.append(day_elem);
        }
    }
}

scholarworks.date_issued_date_change = function(event) {
    let index = $(this).data('element-num');
    let elem_class = $(this).attr('class');

    if (!$(this).hasClass('date_issued_day')) {
        scholarworks.adjust_date_issued_day(index);
    }

    let date_issued_str = $('#date_issued_year_' + index).val();
    let month = $('#date_issued_month_' + index).val();
    let day = $('#date_issued_day_' + index).val();
    if (month != '') {
        if (Number(month) < 10) {
            month = '0' + month;
        }
        date_issued_str = date_issued_str + '-' + month;
        if (day != '') {
            if (Number(day) < 10) {
                day = '0' + day;
            }
            date_issued_str = date_issued_str + '-' + day;
         }
    }
    $('#date_issued_' + index).val(date_issued_str);
    scholarworks.is_required_field_complete();
}

scholarworks.initialize_date_issued = function(index, date_str) {
    //console.log('initialize date issue');
    const MONTH_NAMES = ["Select", "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    ];
    let input_year = "";
    let input_month = "";
    let input_day = "";
    let date = new Date();
    let cur_year = date.getFullYear();
    let year_elem = $('#date_issued_year_' + index);
    //console.log('initialize_date_issued index ' + index + ' date_str [' + date_str +']');

    // generate the option year dynamically
    for (let y = 0; y <= (cur_year - 1940); y++) {
        let prev_year = document.createElement("option");
        prev_year.value = cur_year - y;
        prev_year.textContent = cur_year - y;
        year_elem.append(prev_year);
    }

    for (let y = 1; y < 3; y++) {
        let next_year = document.createElement("option");
        next_year.value = cur_year + y;
        next_year.textContent = cur_year + y
        year_elem.prepend(next_year);
    }

    let prev_year = document.createElement("option");
    prev_year.value = "";
    prev_year.textContent = "Select";
    year_elem.prepend(prev_year);

    // generate the option month dynamically
    for (let m = 0; m <= 12; m++) {
        let month = MONTH_NAMES[m];
        let month_elem = document.createElement("option");
        if (m == 0) {
            month_elem.value = "";
        }
        else {
            month_elem.value = m;
        }
        month_elem.textContent = month;
        $('#date_issued_month_' + index).append(month_elem);
    }


    if (date_str) {
        let y_m_d = date_str.split('-', 3);
        if (!isNaN(y_m_d[0])) {
            // year is a number, let check if it's a valid year
            let y = parseInt(y_m_d[0]);
            if (y < cur_year + 3 && y > 1900) {
                // at least year seems to be valid
                input_year = y;
                if (!isNaN(y_m_d[1])) {
                    let m = parseInt(y_m_d[1]);
                    if (m >= 1 && m <= 12) {
                        input_month = m;
                        if (!isNaN(y_m_d[2])) {
                            let d = parseInt(y_m_d[2]);
                            if (d >= 1 && d <= 31) {
                                input_day = d;
                            }
                         }
                    }
                }
            }
        }
    }
    //console.log('index ' + index + ' date_str ' + date_str + ' input_year ' + input_year + ' input_month ' + input_month + ' input_day ' + input_day);

    year_elem.val(input_year);
    $('#date_issued_month_' + index).val(input_month);
    //year_elem.trigger("change");
    scholarworks.adjust_date_issued_day(index);
    $('#date_issued_day_' + index).val(input_day);

}

scholarworks.any_empty_date_issued_year = function() {
    //console.log('any empty date issue year');
    let retVal = false;
    $('.date_issued_year').each(function () {
        if ($(this).val() == '') {
            retVal = true;
            return false;
        }
    })
    return retVal;
}
scholarworks.date_issued_remove = function() {
    //console.log('date issued remove');
    $('#date_issued_warning').addClass('d_none').attr('aria-hidden', 'true');
    if (scholarworks.date_issued_cnt > 1) {
        let div_parent = $(this).parent().parent();
        if (div_parent.length) {
            div_parent.remove();
            scholarworks.date_issued_cnt--;
            if (scholarworks.date_issued_cnt == 1) {
                $('.date_issued_remove').addClass('d_none').attr('aria-hidden', 'true');
            }
        }
    }
}

scholarworks.date_issued_add = function(elem_model, elem_type) {
    //console.log('date issued add');
    if (scholarworks.any_empty_date_issued_year()) {
        $('#date_issued_warning').removeClass('d_none').attr('aria-hidden', 'false');
        return;
    }

    let required_attr = '';
    let aria_attr = '';
    let elem_class = 'date_issued date_issued_date_hidden ' + elem_model + '_' + elem_type;
    if (scholarworks.date_issued_required) {
        elem_class = elem_class + " required";
        required_attr = "required='required'";
        aria_attr = "aria-required='true'";
    }
    $('#date_issued_warning').addClass('d_none').attr('aria-hidden', 'true');
    $('.date_issued_remove').removeClass('d_none').attr('aria-hidden', 'false');
    $('#date_issued_divs')
        .append(
            "<div id='date_issued_div_" + scholarworks.date_issued_num + "' class='date_issued_div'>" +
            "  <input type='hidden' name='" + elem_model + "[date_issued][]' " +
            "         id='" + elem_type + "_" + scholarworks.date_issued_num + "' " +
            "         class='date_issued date_issued_date_hidden " + elem_model + '_' + elem_type + "' " +
            "         value='' />" +
            "  <label for='date_issued_year_" + scholarworks.date_issued_num + "' class='date_label'><span class='sr-only'>date issued </span>Year</label>" +
            "  <select id='date_issued_year_" + scholarworks.date_issued_num + "' " +
            "          data-element-num='" + scholarworks.date_issued_num + "' " +
            "          class='date_issued_date date_issued_year'>" +
            "  </select>" +
            "  <label for='date_issued_month_" + scholarworks.date_issued_num + "' class='date_label'><span class='sr-only'>date issued </span>Month</label>" +
            "  <select id='date_issued_month_" + scholarworks.date_issued_num + "' " +
            "          data-element-num='" + scholarworks.date_issued_num + "' " +
            "          class='date_issued_date date_issued_month'></select>" +
            "  <label for='date_issued_day_" + scholarworks.date_issued_num + "' class='date_label'><span class='sr-only'>date issued </span>Day</label>" +
            "  <select id='date_issued_day_" + scholarworks.date_issued_num + "' " +
            "          data-element-num='" + scholarworks.date_issued_num + "' " +
            "          class='date_issued_date date_issued_day'></select>" +
            "  <span class='date_label'>" +
            "    <button  type='button' class='btn btn-link remove date_issued_remove' aria-hidden='false'>" +
            "      <span class='glyphicon glyphicon-remove'></span>" +
            "      <span class='controls-remove-text'>Remove</span>" +
            "      <span class='sr-only'> date issued</span>" +
            "    </button>" +
            "  </span>" +
            "<div>");
    // initialize date selector
    scholarworks.initialize_date_issued(scholarworks.date_issued_num, null);
    $('.date_issued_remove').on('click', scholarworks.date_issued_remove);
    $('.date_issued_date').on('change', scholarworks.date_issued_date_change);
    scholarworks.date_issued_cnt++;
    scholarworks.date_issued_num++;
}

scholarworks.update_tinymcearea = function(e) {
    if (e.target.id != undefined && tinymce.get(e.target.id) != null) {
        $('#' + e.target.id).val(tinymce.get(e.target.id).getContent());
    }
    scholarworks.is_required_field_complete();
}

scholarworks.is_required_field_complete = function() {
    // validate orcid fields
    let completed = scholarworks.composite_element.valid_orcid();
    // now check for the rest of required inputs
    if (completed) {
        $('#metadata').find(':input[required]').each(function () {
            if ($(this).val() == null || $(this).val().length < 1) {
                completed = false;
                return false;
            }
        });
    }
    // turn on/off warning of required inputs
    if (completed) {
        $('#required-metadata').addClass('complete').removeClass('incomplete');
    }
    else {
        $('#required-metadata').removeClass('complete').addClass('incomplete');
    }

    // now check agreement box and upload file
    completed = completed && $('#agreement').is(":checked");
    if (scholarworks.is_work_new()) {
        // editor only checks upload file for new work
	let uploaded_files = $('input[name="uploaded_files[]"]').length == 0 ? false : true;
        completed = completed && uploaded_files;
    }
    if (completed) {
        $('#with_files_submit').removeProp('disabled');
    }
    else {
        $('#with_files_submit').prop('disabled', true);
    }
    return completed;
}

scholarworks.tab_click_handler = function(e) {
    // we need a wrapper since we want to ignore the return of scholarworks.is_required_field_complete
    // a return of false would prevent user from clicking on any tab with class of hyrax_work_form_tab
    scholarworks.is_required_field_complete();
}

scholarworks.is_abstract_change = function(e) {
    if ($('#is_abstract').is(":checked")) {
	    if (!$('#dummy_file').length) {
	        // need to insert dummy file to fool the hydra-editor
	        $('#fileupload').prepend('<input id="dummy_file" type="hidden" name="uploaded_files[]" value="0">');
	    }
        $('#required-files').addClass('d_none')
    }
    else {
	    $('#dummy_file').remove();
        if ($('input[name="uploaded_files[]"]').length > 0) {
            $('#required-files').removeClass('incomplete d_none').addClass('complete');
        }
        else {
            $('#required-files').removeClass('complete d_none').addClass('incomplete');
        }
    }
    scholarworks.is_required_field_complete();
}

scholarworks.is_work_new = function() {
    // this is how editor test if work is new
    return $('form').attr('id').startsWith('new');
}
