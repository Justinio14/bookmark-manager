feature 'Adding more than one tag' do

  scenario 'I can add multiple tags to a new link' do
    visit '/new'
    fill_in 'url',    with: 'http://www.makersacademy.com/'
    fill_in 'title',  with: 'Makers Academy'
    fill_in 'tags',  with: 'education school'
    click_button 'Create link'
    link = Link.first
    expect(link.tags.map(&:name)).to include('education','school')
end

end