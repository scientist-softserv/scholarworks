
scholarworks.discipline = {

    DISCIPLINES : {},

    generate_discipline_children : function(discipline_id, select_id, elem_num) {
        let html = null;
        let discipline = this.DISCIPLINES[discipline_id];
        //console.log('inside generate_discipline_children discipline ' + discipline.id + ' children ' + discipline.children + 'children size ' + discipline.children.length);
        if (discipline !== undefined) {
            let discpline_children = discipline.children;
            for (let i = 0; i < discpline_children.length; i++) {
                let child = this.DISCIPLINES[discpline_children[i]];
                if (child != undefined) {
                    if (select_id != null && select_id == discpline_children[i]) {
                        html += "<option selected value='" + discpline_children[i] + "'>" + child.name + "</option>";
                    }
                    else {
                        html += "<option value='" + discpline_children[i] + "'>" +child.name + "</option>";
                    }
                }
            }
            if (html != null) {
                html = "<div class='margin_bottom_5'><select class='form-control discipline' data-element-num='" + elem_num + "'>" +
                    "<option value=''>Select...</option>" + html + "</select></div>";
            }
        }

        //console.log('generate_discipline_children ' + html);
        return html;
    },

    discipline_change : function() {
        //console.log('disciplineChange [' + $(this).val() + ']');
        let cat_id = $(this).val();
        let parent_cat_id = '';

        // if current select is blank, let's try to find its parent value
        if (cat_id == '') {
            let prev_select = $(this).parent().prev().find('select');
            if (prev_select !== undefined) {
                parent_cat_id = prev_select.val();
            }
        }

        //console.log('discipline_change cat_id ' + cat_id);
        let elem_num = $(this).data('element-num');
        let disc_hidden_elem = $('#discipline_' + elem_num + '_hidden');
        if (disc_hidden_elem.length) {
            if (cat_id != '') {
                disc_hidden_elem.val(cat_id);
            }
            else {
                disc_hidden_elem.val(parent_cat_id);
            }
        }

        let siblings = $(this).parent().nextAll();
        //console.log('siblings text  ' + siblings.text());
        //console.log('siblings html  ' + siblings.html());

        if (siblings !== undefined) {
            siblings.remove();
        }

        if (cat_id == '') return;

        let warning_elem = $('#discipline_warning');
        if (warning_elem.length) {
            warning_elem.addClass('d_none').attr('aria-hidden', 'true');
        }
        let children = scholarworks.discipline.generate_discipline_children(cat_id, null, elem_num);
        //console.log('discipline_change children ' + children);
        if (children != null) {
            $(this).parent().parent().append(children);
            $('.discipline').on('change', scholarworks.discipline.discipline_change);
        }
    },

    any_empty_discipline : function() {
        //console.log('any_empty_discipline');
        let ret_val = false;
        $('.discipline_div').each(function () {
            if ($(this).find('.discipline').val() == '') {
                ret_val = true;
                return false;
            }
        });
        return ret_val;
    },

    post_add_discipline : function () {
        //console.log('in post_add_discipline discipline_cnt ' + this.discipline_cnt + ' cur_discipline_num ' + this.cur_discipline_num);
        $('.discipline').on('change', scholarworks.discipline.discipline_change);
    },

    generate_discipline : function (add_button_id) {
        let elem_model = $('#' + add_button_id).data('element-model');
        let elem_type = $('#' + add_button_id).data('element-type');
        return "<div id='discipline_divider" + scholarworks.discipline_num + "' class='row divider discipline_divider'></div>" +
            "<div id='discipline_div" + scholarworks.discipline_num + "' class='row flex_center margin_bottom_10 discipline_div'>" +
            "  <div class='col-xs-10'>" +
            "    <input name='" + elem_model + "[" + elem_type + "][]' id='" + elem_type + "_" + scholarworks.discipline_num + "_hidden' class='discipline_hidden' type='hidden' value='' />" +
            "    <div class='margin_bottom_5'>" +
            "      <select value='' class='form-control discipline' data-element-num='" + scholarworks.discipline_num + "'>" +
            $('#discipline_divs select.discipline').html() + // get top level discipline options from first select element
            "      </select>" +
            "    </div>" +
            "  </div>" +
            "  <div class='col-xs'>" +
            "    <button class='btn btn-link remove element_remove discipline_remove' aria-hidden='true' " +
            "            type='button' data-element-type='discipline' data-element-num='" + scholarworks.discipline_num + "'>" +
            "      <span class='glyphicon glyphicon-remove'></span>" +
            "      <span class='controls-remove-text'>Remove</span>" +
            "      <span class='sr-only'>discipline</span>" +
            "    </button>" +
            "  </div>" +
            "</div>";
    },

    init_discipline : function () {
        let elem_cnt = 0

        $('.discipline_hidden').each(function () {
            let disc_id = $(this).val();
            let disc = scholarworks.discipline.DISCIPLINES[disc_id];
            //console.log('init_discipline disc_id ' + disc_id + ' disc ' + disc);
            if (disc == undefined) {
                $(this).parent().find('select').val('');
            } else {
                let ancestor = disc.ancestor;
                let div_elem = $(this).parent();
                //console.log(' ancestor length ' + ancestor.length);
                if (ancestor.length == 0) {
                    // top level
                    div_elem.find('select').val(disc_id);
                } else {
                    div_elem.find('select').val(ancestor[0]);
                    let parent_id;
                    let child;
                    for (let i = 1; i <= ancestor.length; i++) {
                        //console.log('init ancestor ' + ancestor[i]);
                        parent_id = ancestor[i - 1];
                        if (i == ancestor.length) {
                            child = disc_id;
                        } else {
                            child = ancestor[i];
                        }
                        let children = scholarworks.discipline.generate_discipline_children(parent_id, child, elem_cnt);
                        //console.log('init children ' + children);
                        if (children != null) {
                            //console.log('appending');
                            div_elem.append(children);
                        }
                    }
                }
                // now generate the child for the disc_id
                let children = scholarworks.discipline.generate_discipline_children(disc_id, null, elem_cnt);
                if (children != null) {
                    div_elem.append(children);
                }
            }
            elem_cnt++;
        });

        $('.discipline').on('change', this.discipline_change);
        //console.log('discipline_init elem_cnt ' + elem_cnt);
        return elem_cnt;
    }

}





