module SiteHelpers

  def page_title
    title = "Conrad VanLandingham"
    if data.page.title
      title << " | " + data.page.title
    end
    title
  end
  
  def page_description
    if data.page.description
      description = data.page.description
    else
      description = "Conrad VanLandingham is an interactive, film, and new media designer, developer, photographer and producer."
    end
    description
  end

end