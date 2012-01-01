def successfully_renders
  page.should_not have_content 'Error'
end


def renders_error
  page.should have_content 'Error'
end
