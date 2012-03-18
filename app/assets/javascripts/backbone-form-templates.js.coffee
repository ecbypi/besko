templates =
  form:
    """
    <form class="simple_form">
      {{fieldsets}}
    </form>
    """

  field:
    """
    <div class="input">
      <label for="{{id}}">{{title}}</label>
      <span>{{editor}}</span>
    </div>
    """

  fieldset:
    """
    <div class="inputs">
      {{fields}}
    </div>
    """

classNames =
  error: 'field_with_errors'

Backbone.Form.helpers.setTemplates(templates, classNames)
