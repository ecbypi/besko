//= require application

describe("custom Backbone.Form.templates", function() {
  var form;

  describe("wraps inputs similar to simple_form defaults", function() {
    beforeEach(function() {
      form = new Backbone.Form({
        schema: {
          name: {
            validators: ['required'],
            title: 'Your Name',
            help: 'On your birth certificiate'
          }
        }
      });
      form.render();
    });

    it("wraps fieldsets as div.inputs", function() {
      expect(form.$el).toContain('div.inputs');
    });

    it("wraps label/input elements in div.input", function() {
      expect(form.$('div.inputs')).toContain('div.input');
    });

    it("adds default rails/simple_form error class", function() {
      form.validate();
      expect(form.$el).toContain('div.input.field_with_errors');
    });

    it("retains the label", function() {
      expect(form.$el).toContain('label');
    });
  });
});
