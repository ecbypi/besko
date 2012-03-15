#= require application

describe "Besko.Views.DeliveriesTableRow", ->
  beforeEach ->
    @delivery = new Besko.Models.Delivery(
      id: 1
      deliverer: 'FedEx'
      delivered_at: '10:30 AM'
      package_count: 3
      worker:
        first_name: 'Micro'
        last_name: 'Helpline'
        email: 'mrhalp@mit.edu'
    )
    @view = new Besko.Views.DeliveriesTableRow model: @delivery
    @view.render()

  it "is a tr", ->
    expect(@view.$el).toBe('tr')

  it "represents a delivery model", ->
    expect(@view.$el).toHaveData('resource', 'delivery')

  it "has a link to email the applicant", ->
    expect(@view.$el).toContain('a[href="mailto:mrhalp@mit.edu"]')

  it "formats the date the delivery was received", ->
    expect(@view.$el).toHaveText(/10:30 AM/)

  it "has the deliverer", ->
    expect(@view.$el).toHaveText(/FedEx/)

  it "has the total number of packages", ->
    expect(@view.$el).toHaveText(/3/)
