// these functions are used by composite person but we

if (typeof serialize_person !== 'function') {
    serialize_person = function(person_type) {
        $('.' + person_type).each(function () {
            let elem_num = $(this).data('element-num');
            let name = $.trim($('#' + person_type + '_name' + elem_num).val());
            if (name.length > 0) {
                let email = $('#' + person_type + '_email' + elem_num).val();
                let institution = $('#' + person_type + '_institution' + elem_num).val();
                let orcid = $('#' + person_type + '_orcid' + elem_num).val();
                $(this).val(name + ':::' + email + ':::' + institution + ':::' + orcid);
            }
            else {
                $(this).val('');
            }
        });
    };
}

if (typeof deserialize_person !== 'function') {
    deserialize_person = function(person_type) {
        $('.' + person_type).each(function () {
            let elem_num = $(this).data('element-num');
            let name_str = $(this).val();
            let result = name_str.split(":::");
            if (result.length > 1) {
                $('#' + person_type + '_email' + elem_num).val(result[1]);
                $('#' + person_type + '_institution' + elem_num).val(result[2]);
                $('#' + person_type + '_orcid' + elem_num).val(result[3]);
            }
            $('#' + person_type + '_name' + elem_num).val(result[0]);
            $('#remove_' + person_type + '_aria' + elem_num).html(' ' + result[0]);
        });
    };
}

if (typeof invalid_orcid !== 'function') {
    invalid_orcid =  function() {
        let regex = /^\d{4}-\d{4}-\d{4}-\d{3}[\dX]$/;
        let has_invalid_orcid = false;
        $('.person_orcid_error').addClass('d_none').attr('aria-hidden', 'true');
        $('.person_orcid').each(function () {
            let orcid_val = $.trim($(this).val());
            if (orcid_val != '' && !regex.test(orcid_val)) {
                let person_type = $(this).data('element-class');
                let id = $(this).data('element-num')
                //console.log('invalid_orcid person_type ' + person_type + ' element id ' + id);
                $('#' + person_type + '_orcid_error' + id).removeClass('d_none').attr('aria-hidden', 'false');
                has_invalid_orcid = true;
                return false;
            }
        });
        return has_invalid_orcid;
    }
}

if (typeof any_empty_element !== 'function') {
    any_empty_element = function(element_class) {
        // person_type to distinguish between creator, contributor, etc...
        let retVal = false;
        $('.' + element_class + '_name').each(function () {
            // console.log('any_empty_element: value [' + $.trim($(this).val()) + '] html [' + $(this).html() + ']');
            if ($.trim($(this).val()) == '') {
                retVal = true;
                return false;
            }
        })
        return retVal;
    }
}

if (typeof toggle_submit !== 'function') {
    toggle_submit = function(disabled) {
        if (disabled) {
            $('#required-metadata').removeClass('complete').addClass('incomplete');
        }
        else {
            $('#required-metadata').addClass('complete').removeClass('incomplete');
        }
        $('#with_files_submit').attr('disabled', disabled);
    }
}

if (typeof generate_person !== 'function') {
    generate_person = function(model_type, person_type, required_name) {
        let elem = "";
        let cur_elem_num = window['cur_' + person_type + '_num'];
        elem =
            "<div id='" + person_type + "_divider" + cur_elem_num + "' class='row divider " + person_type + "_divider'></div>" +
            "<div id='" + person_type + cur_elem_num + "' class='row " + person_type + "_div flex_center'>" +
            "  <input type='hidden' name='" + model_type + "[" + person_type + "][]' id='" + person_type + cur_elem_num + "' class='" + person_type + "' data-element-num='" + cur_elem_num + "' value='' />" +
            "  <div class='col-xs-8'>" +
            "    <div class='label_input_div'>" +
            "      <label for='" + person_type + "_name" + cur_elem_num + "' class='label_field'>" +
            "        <span class='sr-only'>" + person_type + " </span>Name " +
            (required_name ? "<span class='label label-info required-tag'>required</span>" : "") +
            "      </label>" +
            "      <input type='text'  id='" + person_type + "_name" + cur_elem_num + "' value='' aria-required='" + (required_name ? "true" : "false") + "' " +
            (required_name ? "required='required' " : "") +
            "             class='string multi_value " + (required_name ? "required " : " ") + person_type + "_name margin_bottom_10 multi-text-field multi_value input_field' />" +
            "    </div>" +
            "    <div class='label_input_div'>" +
            "      <label for='" + person_type + "_email" + cur_elem_num + "' class='label_field'>" +
            "        <span class='sr-only'>" + person_type + " </span>Email" +
            "      </label>" +
            "      <input type='email' name='<%= model_type %>[" + person_type + "_email][]' id='" + person_type + "_email" + cur_elem_num + "' value='' class='" + person_type + "_email margin_bottom_10 multi-text-field multi_value input_field' />" +
            "    </div>" +
            "    <div class='label_input_div'>" +
            "      <label for='" + person_type + "_institution" + cur_elem_num + "' class='label_field'>" +
            "        <span class='sr-only'>" + person_type + " </span>Institution" +
            "      </label>" +
            "      <input type='text' name='<%= model_type %>[" + person_type + "_institution][]' id='" + person_type + "_institution" + cur_elem_num + "' value='' class='" + person_type + "_institution margin_bottom_10 multi-text-field multi_value input_field' />" +
            "    </div>" +
            "    <div class='label_input_div'>" +
            "      <label for='" + person_type + "_orcid" + cur_elem_num + "' class='label_field'>" +
            "        <span class='sr-only'>" + person_type + " </span>ORCID" +
            "      </label>" +
            "      <input type='text' name='<%= model_type %>[" + person_type + "_orcid][]' id='" + person_type + "_orcid" + cur_elem_num + "' value='' class='" + person_type + "_orcid person_orcid margin_bottom_10 multi-text-field multi_value input_field' data-element-class='" + person_type + "' data-element-num='" + cur_elem_num + "' />" +
            "      <span id='" + person_type + "_orcid_error" + cur_elem_num + "' class='" + person_type + "_orcid_error person_orcid_error error text-danger error text-danger margin_bottom_10 d_none' role='alert' aria-hidden='true'>must be a string of 19 characters, e.g., '0000-0000-0000-0000'</span>" +
            "    </div>" +
            "  </div>" +
            "  <div class='col-sm'>" +
            "    <button class='btn btn-link remove element_remove <%= key %>_remove' aria-hidden='true' " +
            "            type='button' data-element-class='" + person_type + "' data-element-num='" + cur_elem_num + "'>" +
            "      <span class='glyphicon glyphicon-remove'></span>" +
            "      <span class='controls-remove-text'>Remove</span>" +
            "      <span class='sr-only'>" + person_type + "</span>" +
            "    </button>" +
            "  </div>" +
            "</div>";
        return elem;
    }
}

if (typeof post_add_person !== 'function') {
    post_add_person = function() {
        $('.person_orcid').on('focusout', invalid_orcid);    // comment this to test server ORCID validation
    }
}

if (typeof element_add !== 'function') {
    element_add = function() {
        let elem_class = $(this).data('element-class');
        // console.log('elem_add class ' + elem_class);
        // console.log('element_add: elem_cnt ' + window[elem_class + '_cnt'] + ' cur_elem_num ' + window['cur_' + elem_class + '_num']);

        // let's turn off the warning message first
        $('#' + elem_class + '_warning').addClass('d_none').attr('aria-hidden', 'true');

        let any_empty_elem = false;
        try {
            any_empty_elem = eval('any_empty_' + elem_class + '()');
        }
        catch(err) {
            console.log('Could not find check for empty function for ' + elem_class + ' so use the default one');
            any_empty_elem = any_empty_element(elem_class);
        }

        // console.log('element_add: any_empty_elem ' + any_empty_elem);
        if (any_empty_elem) {
            // turn on warning message when we already have empty field
            $('#' + elem_class + '_warning').removeClass('d_none').attr('aria-hidden', 'false');
        }
        else {
            $('.' + elem_class + '_remove').removeClass('d_none').attr('aria-hidden', 'false');
            let elem_parent = $('#' + elem_class + '_divs');
            let new_elem = null;
            try {
                new_elem = eval('generate_' + elem_class + '()');
                window[elem_class + '_cnt']++;
                window['cur_' + elem_class + '_num']++;
                //console.log('element_add: after adding ' + elem_class + ' elem_cnt ' + window[elem_class + '_cnt'] + ' cur_elem_num ' + window['cur_' + elem_class + '_num']);
            }
            catch (err) {
                console.log('fail to find function generate_' + elem_class);
            }
            if (elem_parent.length && new_elem != null) {
                elem_parent.append(new_elem);
                $('.element_remove').on('click', element_remove);
                try {
                    eval('post_add_' + elem_class + '()');
                }
                catch (err) {
                    // notice that specific field post add function is not required, just an ability to allow that field to do more stuffs
                    // console.log('fail to find post add function for ' + elem_class + ' so just use default post_add_person');
                    // if failed to find specific class post add, just use the default one
                    post_add_person();
                }
            }
        }
    }
}

if (typeof element_remove !== 'function') {
    element_remove = function() {
        let elem_class = $(this).data('element-class');
        let elem_num = $(this).data('element-num');
        // console.log('element_remove: elem_class ' + elem_class + ' elem_num ' + elem_num);

        try {
            console.log('element_remove: elem_cnt for ' + elem_class + ' ' + window[elem_class + '_cnt']);
            if (window[elem_class + '_cnt'] > 1) {
                let removing_elem = $('#' + elem_class + elem_num);
                if (removing_elem.length) {
                    removing_elem.remove();
                    window[elem_class + '_cnt']--;
                    try {
                        eval('post_remove_' + elem_class + '()');
                    }
                    catch (err) {
                        console.log('element_remove: failed to call post remove function for class ' + elem_class + ' maybe this class does not need one');
                    }
                    console.log('element_remove: elem_cnt after decrement for ' + elem_class + ' ' + window[elem_class + '_cnt']);
                    if (window[elem_class + '_cnt'] == 1) {
                        $('.' + elem_class + '_divider').remove();
                        $('.' + elem_class + '_remove').addClass('d_none').attr('aria-hidden', 'true');
                    }
                    else {
                        if ($('#' + elem_class + '_divider' + elem_num).length) {
                            $('#' + elem_class + '_divider' + elem_num).remove();
                        }
                    }
                    $('#' + elem_class + '_warning').addClass('d_none').attr('aria-hidden', 'true');
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
        if (invalid_orcid() || invalid_description() || invalid_title()) {
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

        // serialize creator
        serialize_person('creator');

        // serialize contributor if field exists
        if (window['contributor_cnt'] !== undefined) {
            serialize_person('contributor');
        }

        // serialize editor if field exists
        if (window['editor_cnt'] !== undefined) {
            serialize_person('editor');
        }

        // serialize advisor if field exists
        if (window['advisor_cnt'] !== undefined) {
            serialize_person('advisor');
        }

        // serialize committee_member if field exists
        if (window['committee_member_cnt'] !== undefined) {
            serialize_person('committee_member');
        }

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

$(function() {
    // these functions are used by composite person but we
    $('.person_orcid').on('focusout', invalid_orcid);
    if (invalid_orcid()) {
        $('#with_files_submit').attr('disabled', true);
    }
});
