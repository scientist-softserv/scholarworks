/* these functions are used by composite person.
*/

/*
    These functions allow dynamic creation and deserialization of the composite element.
 */

var scholarworks = scholarworks || {};
scholarworks.composite_element =  {
    // these are the composite elements we support.
    SUBTYPES : ['name', 'email', 'institution', 'orcid'],

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

    generate_sub_elements : function(elem_type, elem_num, elem_required, subtypes, subvalues) {
        let ret_elem = '';
        const subtypes_arr = subtypes.split(" ");
        const sub_values_arr = subvalues.split(":::");
        for (let i = 0; i < subtypes_arr.length; i++) {
            if (!this.SUBTYPES.includes(subtypes_arr[i])) {
                // not in the subtype that we can support
                continue;
            }

            let sub_value = (sub_values_arr.length > 1 ? sub_values_arr[i] : '');
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
        let elem_num =  window['cur_' + elem_type + '_num'];
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
            " data-subtypes='" + subtypes + "'" +
            "'>" +
            " <span class='glyphicon glyphicon-remove'></span>" +
            " <span class='controls-remove-text'>Remove</span>" +
            " <span class='sr-only'>" + elem_type + "</span>" +
            " </button>" +
            " </div>" +
            "</div>";

        return ret_elem;
    },

    invalid_orcid : function() {
        let regex = /^\d{4}-\d{4}-\d{4}-\d{3}[\dX]$/;
        let has_invalid_orcid = false;
        $('.composite_orcid_error').addClass('d_none').attr('aria-hidden', 'true');
        $('.composite_orcid').each(function () {
            let orcid_val = $.trim($(this).val());
            if (orcid_val != '' && !regex.test(orcid_val)) {
                let elem_type = $(this).data('element-type');
                let id = $(this).data('element-num')
                $('#' + elem_type + '_orcid_error' + id).removeClass('d_none').attr('aria-hidden', 'false');
                has_invalid_orcid = true;
                return false;
            }
        });
        return has_invalid_orcid;
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
            toggle_submit(scholarworks.composite_element.invalid_orcid());
        });
        toggle_submit(scholarworks.composite_element.invalid_orcid());

        /*
        This is the extra checking to turn on/off the submit button based on the main subfield
        but for some reason it seems to be conflict with hyrax event handler so I just comment it
        out since the main subfield is a required field and will be checked by browser and hyrax

        console.log('element_change elem_required ' + elem_required);
        if (elem_required) {
            const subtypes_arr = subtypes.split(" ");
            // subtypes 0 (first one) is the main field
            let main_elem = elem_type + '_' + subtypes_arr[0];
            $('.' + main_elem).change(function() {
                console.log('element_change main element ' + main_elem + ' changed ');
                toggle_submit(scholarworks.composite_element.any_empty_main_element(main_elem));
                //toggle_submit(!scholarworks.composite_element.any_fill_main_element(main_elem));
            });
            toggle_submit(scholarworks.composite_element.any_empty_main_element(main_elem));
            //toggle_submit(!scholarworks.composite_element.any_fill_main_element(main_elem));
        }
        */
    },

    // to be used after add and remove action
    post_action : function(add_button_id) {
        //console.log('inside post_element_action add_button_id[' + add_button_id + ']');
        let button_elem = $('#' + add_button_id);
        if (!button_elem.length) return;

        let elem_type = button_elem.data('element-type');
        let subtypes = button_elem.data('subtypes');
        let elem_required = button_elem.data('element-required');
        //console.log('post_element_action button_id [' + add_button_id + '] elem_type [' + elem_type + ' subtypes [' + subtypes + ' elem_required [' + elem_required + ']');
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

if (typeof toggle_submit !== 'function') {
    toggle_submit = function(disabled) {
        //console.log('inside toggle_submit disabled [' + disabled + ']');
        if (disabled) {
            $('#required-metadata').removeClass('complete').addClass('incomplete');
            $('#with_files_submit').prop('disabled', disabled);
        }
        else {
            $('#required-metadata').addClass('complete').removeClass('incomplete');
            $('#with_files_submit').removeProp('disabled');
        }
    }
}

if (typeof element_add !== 'function') {
    element_add = function() {
        let elem_type = $(this).data('element-type');
        let elem_empty_func = $(this).data('element-empty');
        let elem_generate_func = $(this).data('element-generate');
        let add_button_id = $(this).attr('id');
        let elem_cnt = window[elem_type + '_cnt'];
        let cur_elem_num = window['cur_' + elem_type + '_num'];
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
                //console.log('element_add: after adding ' + elem_type + ' elem_cnt ' + window[elem_type + '_cnt'] + ' cur_elem_num ' + window['cur_' + elem_type + '_num']);
            }
            catch (err) {
                console.log('fail to find element generate function ' + elem_generate_func);
            }
            if (elem_parent.length && new_elem != null) {
                elem_parent.append(new_elem);
                $('.' + elem_type + '_remove').removeClass('d_none').attr('aria-hidden', 'false');
                window[elem_type + '_cnt']++;
                window['cur_' + elem_type + '_num']++;
                let elem_cnt = window[elem_type + '_cnt'];
                let cur_elem_num = window['cur_' + elem_type + '_num'];
                //console.log('element_add after add elem_cnt ' + elem_cnt + ' cur_elem_num ' + cur_elem_num);
                $('.element_remove').on('click', element_remove);
                try {
                    let elem_post_add_func = $(this).data('element-post-add');
                    //console.log('invoke post generate [' + elem_post_add_func + '] add_button_id [' + add_button_id + ']');
                    eval(elem_post_add_func + '("' + add_button_id + '")');
                }
                catch (err) {
                    console.log('fail to find post add element function ' + elem_post_add_func);
                }
            }
        }
    }
}

if (typeof element_remove !== 'function') {
    element_remove = function() {
        let elem_type = $(this).data('element-type');
        let elem_num = $(this).data('element-num');
        //console.log('element_remove: elem_type ' + elem_type + ' elem_num ' + elem_num);

        try {
            if (window[elem_type + '_cnt'] > 1) {
                let removing_elem = $('#' + elem_type + '_div' + elem_num);
                if (removing_elem.length) {
                    removing_elem.remove();
                    window[elem_type + '_cnt']--;
                    try {
                        let elem_post_remove_func = $(this).data('element-post-remove');
                        //console.log('element_remove elem_post_remove_func [' + elem_post_remove_func + ']');
                        eval(elem_post_remove_func + '("' + 'add_' + elem_type + '")');
                    }
                    catch (err) {
                        console.log('element_remove: failed to call post remove function for type ' + elem_type + ' maybe this type does not need one');
                    }
                    //console.log('element_remove: elem_cnt after decrement for ' + elem_type + ' ' + window[elem_type + '_cnt']);
                    if (window[elem_type + '_cnt'] == 1) {
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
}

// only one save_handler for submit button event handler
if (typeof save_handler !== 'function') {
    save_handler = function(event) {
        $('.title_tinymce').each(function () {
            let editor_txt = tinymce.get($(this).prop('id')).getContent();
            $(this).text(editor_txt);
        });

        $('.description_tinymce').each(function () {
            let editor_txt = tinymce.get($(this).prop('id')).getContent();
            $(this).text(editor_txt);
        });

        // comment this to test server ORCID validation by remove the condition invalid_orcid
        if (scholarworks.composite_element.invalid_orcid() || invalid_description() || invalid_title()) {
            event.preventDefault();
            toggle_submit(true);
            return;
        }

        if (typeof invalid_date_issued === 'function') {
            if (invalid_date_issued()) {
                event.preventDefault();
                toggle_submit(true);
                return;
            }
        }

        // serialize all composite elements
        scholarworks.composite_element.serialize();

        $('.date_issued_div').each(function () {
            let index = $(this).prop('id').substring($(this).prop('id').lastIndexOf('_') + 1);
            let date_issued_str = $('#date_issued_year_' + index).val();
            let month = $('#date_issued_month_' + index).val();
            let day = $('#date_issued_day_' + index).val();
            if (month != '' && day != '') {
                if (Number(month) < 10) {
                    month = '0' + month;
                }
                if (Number(day) < 10) {
                    day = '0' + day;
                }
                date_issued_str = date_issued_str + '-' + month + '-' + day;
            }
            $('#date_issued_' + index).val(date_issued_str);
        });
    }
}

// functions for data_issued
function adjust_date_issued_day(index) {
    let year = $('#date_issued_year_' + index).val();
    let month = parseInt($('#date_issued_month_' + index).val());
    let day = $('#date_issued_day_' + index);
    day.empty();

    // setting month to select if year is empty
    if (!year) {
        $('#date_issued_month_' + index).val("");
    }

    //get the last day, so the number of days in that month
    let days = new Date(year, month, 0).getDate();

    let day_elem = document.createElement("option");
    day_elem.value = "";
    day_elem.textContent = "Select";
    day.append(day_elem);

    //lets create the days of that month
    for (let d = 1; d <= days; d++) {
        let day_elem = document.createElement("option");
        day_elem.value = d;
        day_elem.textContent = d;
        day.append(day_elem);
    }
}

function initialize_date_issued(index, date_str) {
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
    year_elem.trigger("change");
    adjust_date_issued_day(index);
    $('#date_issued_day_' + index).val(input_day);

}

function any_empty_date_issued_year() {
    let retVal = false;
    $('.date_issued_year').each(function () {
        if ($(this).val() == '') {
            retVal = true;
            return false;
        }
    })
    return retVal;
}

function invalid_date_issued() {
    let retVal = false;
    if (date_issued_required) {
        retVal = true;
        $('.date_issued_year').each(function () {
            if ($(this).val() != '') {
                retVal = false;
                return false;
            }
        })
    }
    return retVal;
}

function date_issued_change() {
    toggle_submit(invalid_date_issued());
}

function date_issued_remove() {
    $('#date_issued_warning').addClass('d_none').attr('aria-hidden', 'true');
    if (date_issued_cnt > 1) {
        let div_parent = $(this).parent().parent();
        if (div_parent.length) {
            div_parent.remove();
            date_issued_cnt--;
            if (date_issued_cnt == 1) {
                $('.date_issued_remove').addClass('d_none').attr('aria-hidden', 'true');
            }
        }
    }
}

function date_issued_add(elem_model, elem_type) {
    if (any_empty_date_issued_year()) {
        $('#date_issued_warning').removeClass('d_none').attr('aria-hidden', 'false');
        return;
    }

    $('#date_issued_warning').addClass('d_none').attr('aria-hidden', 'true');
    $('.date_issued_remove').removeClass('d_none').attr('aria-hidden', 'false');
    $('#date_issued_divs')
        .append(
            "<div id='date_issued_div_" + cur_date_issued_num + "' class='date_issued_div'>" +
            "  <input type='hidden' name='" + elem_model + "[date_issued][]' id='" + elem_type + "_" + cur_date_issued_num + "' class='date_issued_date_hidden' value='' />" +
            "  <label for='date_issued_year_" + cur_date_issued_num + "' class='date_label'><span class='sr-only'>date issued </span>Year</label>" +
            "  <select id='date_issued_year_" + cur_date_issued_num + "' class='date_issued date_issued_date date_issued_year' " +
            "          onclick='adjust_date_issued_day(" + cur_date_issued_num + ")'></select>" +
            "  <label for='date_issued_month_" + cur_date_issued_num + "' class='date_label'><span class='sr-only'>date issued </span>Month</label>" +
            "  <select id='date_issued_month_" + cur_date_issued_num + "' onclick='adjust_date_issued_day(" + cur_date_issued_num + ")' class='date_issued date_issued_date date_issued_month'></select>" +
            "  <label for='date_issued_day_" + cur_date_issued_num + "' class='date_label'><span class='sr-only'>date issued </span>Day</label>" +
            "  <select id='date_issued_day_" + cur_date_issued_num + "' class='date_issued date_issued_day'></select>" +
            "  <span class='date_label'>" +
            "    <button  type='button' class='btn btn-link remove date_issued_remove' aria-hidden='false'>" +
            "      <span class='glyphicon glyphicon-remove'></span>" +
            "      <span class='controls-remove-text'>Remove</span>" +
            "      <span class='sr-only'> date issued</span>" +
            "    </button>" +
            "  </span>" +
            "<div>");
    // initialize date selector
    initialize_date_issued(cur_date_issued_num, null);
    $('.date_issued_remove').on('click', date_issued_remove);
    $('.date_issued_year').on('change', date_issued_change);
    date_issued_cnt++;
    cur_date_issued_num++;
}

// function for description
function invalid_description() {
    /* will need to check to see if class has required in it if we have more
       than one textarea tinymce where one of them is not required but for now
       only one textarea tinymce description is rquired in the work except for collection.
       let class_str = $('#<%= model_type %>_description').prop('class'); or loop through
       $('.description_tinymce').each(function () {
         let class_str = $('#' + $(this).prop('class'));
         and check if it contains required string
       });
    */
    let desc_content = tinymce.get('scholarworks_description').getContent();
    if (desc_content.length > 0) {
        $('#empty_description').addClass('d-none');
        $('#description_content').removeClass('has-error');
        return false;
    }
    $('#empty_description').removeClass('d-none');
    $('#description_content').addClass('has-error');
    return true;
}

function invalid_title() {
    let title_content = tinymce.get('scholarworks_title').getContent();
    if (title_content.length > 0) {
        $('#empty_title').addClass('d-none');
        $('#title_content').removeClass('has-error');
        return false;
    }
    $('#empty_title').removeClass('d-none');
    $('#title_content').addClass('has-error');
    return true;
}

